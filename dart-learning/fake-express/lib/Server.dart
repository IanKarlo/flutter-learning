import 'dart:io';

import 'Request.dart';
import 'Response.dart';
import 'Router.dart';

class Server {
  int port;

  Router router = new Router();

  Server(this.port) {}

  void use(Router router) {
    this.router.merge(router);
  }

  void get(String route, RequestHandlerFn handler) {
    this.router.get(route, handler);
  }

  void post(String route, RequestHandlerFn handler) {
    this.router.post(route, handler);
  }

  void listen() async {
    var PORT = this.port;
    final server = await HttpServer.bind(InternetAddress.anyIPv6, PORT);
    print('Server listening on port $PORT');
    await server.forEach((HttpRequest httpRequest) {
      var request = new RequestObject(httpRequest);
      var response = new ResponseObject(httpRequest);
      this.router.handling(request, response);
    });
  }
}
