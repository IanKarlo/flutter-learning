import 'dart:io';

import 'lib/Server.dart';
import 'routes.dart';

void makeServer() async {
  var server = new Server(8080);
  var routes = makeRoutes();
  server.use(routes);
  server.listen();
}

void main() {
  makeServer();
}
