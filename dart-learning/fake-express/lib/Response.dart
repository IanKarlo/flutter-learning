import 'dart:io';

import 'dart:convert';

class ResponseObject {
  HttpRequest _request;
  int statusCode = 200;

  ResponseObject(this._request);

  void send(Object message) {
    this._request.response.statusCode = this.statusCode;
    this._request.response.write(jsonEncode(message));
    this._request.response.close();
  }

  ResponseObject status(int statusCode) {
    var newRequest = new ResponseObject(this._request);

    newRequest.statusCode = statusCode;

    return newRequest;
  }
}
