import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:kuzzle/kuzzle.dart';

import 'helpers/kuzzle.dart';

void main() {
  final kuzzle = Kuzzle(WebSocketProtocol('localhost'));
  String defaultIndex;
  String defaultCollection;

  setUpAll(() async {
    await connectKuzzle(kuzzle);
    await kuzzle.auth.login('local', adminCredentials);
    defaultIndex = Uuid().v1();
    defaultCollection = 'posts';
  });

  group('collection', () {
    setUpAll(() async {
      await kuzzle.index.create(defaultIndex);
    });
    test('creation', () async {
      final response = await kuzzle.collection.create(
        defaultIndex,
        defaultCollection,
        mapping: {'title': {}},
      );
      expect(response['acknowledged'], true);
    });
    test('delete', () async {
      final response = await kuzzle.collection.delete(
        defaultIndex,
        defaultCollection,
      );

      expect(response, true);
    });

    test('delete specification', () async {
      final response = await kuzzle.collection.deleteSpecifications(
        defaultIndex,
        defaultCollection,
      );
      expect(response['acknowledged'], true);
    });

    test('exists', () async {
      final response = await kuzzle.collection.exists(
        defaultIndex,
        defaultCollection,
      );
      expect(response, true);
    });

    test('get mapping', () async {
      final response = await kuzzle.collection.getMapping(
        defaultIndex,
        defaultCollection,
      );
      expect(
        response[defaultIndex]['mappings'][defaultCollection]['properties'],
        <String, dynamic>{},
      );
    });
    test('list all collections', () async {
      final response = await kuzzle.collection.list(defaultIndex);
      print(response);
      expect(
        response['collections'].length,
        greaterThanOrEqualTo(1),
      );
      expect(
        response['collections'][0]['name'],
        defaultCollection,
      );
    });

    test('refresh', () async {
      final response = await kuzzle.collection.refresh(
        defaultIndex,
        defaultCollection,
      );

      expect(response, true);
    });

    test('search specifications', () async {
      final response = await kuzzle.collection.searchSpecifications(
        defaultIndex,
      );
      expect(response.hits.length, greaterThanOrEqualTo(0));
    });

    test('truncate', () async {
      final response = await kuzzle.collection.truncate(
        defaultIndex,
        defaultCollection,
      );
      expect(response.length, 1);
    });

    test('update specifications', () async {
      final response = await kuzzle.collection.updateSpecifications(
        defaultIndex,
        defaultCollection,
        false,
        {},
      );
      expect(response, <String, dynamic>{});
    });

    test('get specifications', () async {
      final response = await kuzzle.collection.getSpecifications(
        defaultIndex,
        defaultCollection,
      );
      expect(response, {
        'validation': {},
        'index': defaultIndex,
        'collection': defaultCollection,
      });
      expect(response['validation'], <String, dynamic>{});
    });
    test('validate specifications', () async {
      final response = await kuzzle.collection.validateSpecifications(
        defaultIndex,
        defaultCollection,
        false,
        {},
      );
      expect(response, true);
    });

    tearDownAll(() async {
      await kuzzle.index.delete(defaultIndex);
    });
  });

  tearDownAll(kuzzle.disconnect);
}
