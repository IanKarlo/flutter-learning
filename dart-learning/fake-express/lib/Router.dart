import 'Request.dart';
import 'Response.dart';

typedef void RequestHandlerFn(RequestObject request, ResponseObject response);

class Router {
  Map<String, RequestHandler> staticRoutes = {};
  Map<String, RequestHandler> dinamicRoutes = {};

  MyRouter() {}

  void get(String route, RequestHandlerFn handler) {
    const method = 'GET';
    var isDinamic = this.isDinamic(route);
    if (isDinamic) {
      dinamicRoutes['$method - $route'] = new RequestHandler(route, handler);
    } else {
      staticRoutes['$method - $route'] = new RequestHandler(route, handler);
    }
  }

  void post(String route, RequestHandlerFn handler) {
    const method = 'POST';
    var isDinamic = this.isDinamic(route);
    if (isDinamic) {
      dinamicRoutes['$method - $route'] = new RequestHandler(route, handler);
    } else {
      staticRoutes['$method - $route'] = new RequestHandler(route, handler);
    }
  }

  bool isDinamic(String route) {
    var paths = route.split('/');
    paths = paths.where((element) => element.length > 0).toList();
    return paths.any((element) => element[0] == ':');
  }

  void handling(RequestObject request, ResponseObject response) {
    final method = request.method();
    final route = request.path();

    var handler = getHandler(route, method);

    if (handler != null) {
      handler.handle(request, response);
    } else {
      response.status(404).send('Not Found');
    }
  }

  RequestHandler? getHandler(String route, String method) {
    var queryParams = this.handleQueryParams(route);

    var filteredRoute = route.split('?')[0];

    var handler = this.staticRoutes['$method - $filteredRoute'];

    if (handler != null) {
      handler.setQuery(queryParams);
      return handler;
    }

    return this.handleDynamicRoute(filteredRoute, method, queryParams);
  }

  RequestHandler? handleDynamicRoute(
      String route, String method, Map<String, String> queryParams) {
    var splited = route.split('/');
    splited = splited.where((element) => element.length > 0).toList();

    var dynamicRoutesKeys = this.dinamicRoutes.keys.toList();

    for (var key in dynamicRoutesKeys) {
      if (!key.contains(method)) {
        continue;
      }

      var splittedKey = key.split('/');
      splittedKey.removeAt(0);
      if (splittedKey.length != splited.length) {
        continue;
      }
      var isEqual = true;
      Map<String, String> params = {};
      for (var pathIndex = 0; pathIndex < splittedKey.length; pathIndex++) {
        if (splittedKey[pathIndex][0] == ':') {
          var key = splittedKey[pathIndex];
          key = key.replaceAll(':', '');
          params[key] = splited[pathIndex];
          continue;
        } else if (splittedKey[pathIndex] == splited[pathIndex]) {
          continue;
        } else {
          isEqual = false;
          break;
        }
      }

      if (!isEqual) {
        break;
      }

      this.dinamicRoutes[key]?.setParams(params);
      this.dinamicRoutes[key]?.setQuery(queryParams);
      return this.dinamicRoutes[key];
    }

    return null;
  }

  Map<String, String> handleQueryParams(String route) {
    Map<String, String> query = {};

    if (route.contains('?')) {
      String queries = route.split('?')[1];
      var values = queries.split('&');
      for (final pair in values) {
        var keyAndValue = pair.split('=');
        if (!keyAndValue.any((element) => element.length <= 0)) {
          query[keyAndValue[0]] = keyAndValue[1];
        }
      }
    }

    return query;
  }

  List<Map<String, RequestHandler>> getRoutes() {
    return [this.staticRoutes, this.dinamicRoutes];
  }

  void mergeRoutes(
      Map<String, RequestHandler> static, Map<String, RequestHandler> dinamic) {
    this.staticRoutes.addAll(static);
    this.dinamicRoutes.addAll(dinamic);
  }

  void merge(Router router) {
    var routes = router.getRoutes();
    var staticRoutes = routes[0];
    var dinamicRoutes = routes[1];

    this.mergeRoutes(staticRoutes, dinamicRoutes);
  }
}

class RequestHandler {
  String _path;
  RequestHandlerFn _handler;
  Map<String, String> _params = {};
  Map<String, String> _query = {};

  RequestHandler(this._path, this._handler) {}

  void handle(RequestObject request, ResponseObject response) {
    request.setParams(this._params);
    request.setQuery(this._query);

    this._handler(request, response);

    this.resetParams();
    this.resetQuery();
  }

  List<String> getSplitedRoute() {
    return this._path.split('/');
  }

  void setParams(Map<String, String> params) {
    this._params.addAll(params);
  }

  void resetParams() {
    this._params.clear();
  }

  void setQuery(Map<String, String> query) {
    this._query.addAll(query);
  }

  void resetQuery() {
    this._query.clear();
  }
}
