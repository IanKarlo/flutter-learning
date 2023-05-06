import 'lib/Router.dart';

Router makeRoutes() {
  var router = new Router();

  router.get('/', (request, response) {
    return response.status(200).send('Server up');
  });

  router.post('/user', (request, response) {
    return response.status(201).send('');
  });

  router.get('/user/teste', (request, response) {
    return response.send('Testando 123');
  });

  router.get('/:user/teste', (request, response) {
    var params = request.getParams();
    var query = request.getQuery();

    return response.send(params);
  });

  return router;
}
