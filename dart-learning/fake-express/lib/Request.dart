import 'dart:io';

class RequestObject {
  HttpRequest _request;
  Map<String, String> _params = {};
  Map<String, String> _query = {};

  RequestObject(this._request);

  String path() {
    return this._request.uri.toString();
  }

  String method() {
    return this._request.method;
  }

  HttpHeaders headers() {
    return this._request.headers;
  }

  void setParams(Map<String, String> params) {
    this._params.addAll(params);
  }

  Map<String, String> getParams() {
    return this._params;
  }

  void setQuery(Map<String, String> query) {
    this._query.addAll(query);
  }

  Map<String, String> getQuery() {
    return this._query;
  }
}
