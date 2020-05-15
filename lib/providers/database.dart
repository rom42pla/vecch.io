import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';

class DatabaseProvider{

  String _dbPath;
  Database _db;

  DatabaseProvider() {
    _dbPath = "vecchio.db";
  }

  clearDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase(appDocumentDir.path + _dbPath);
    var store = stringMapStoreFactory.store('credentials');
    store.delete(_db);
  }

  Future<Map> getUserCredentials(username) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase(appDocumentDir.path + _dbPath);
    var store = stringMapStoreFactory.store('credentials');
    var records = (await store.find(_db,
        finder: Finder(filter: Filter.byKey(username))));
    print(records);
    var userCredentials = await store.record(username).get(_db);
    return userCredentials;
  }

  Future<void> saveUserCredentials(String username) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase(appDocumentDir.path + _dbPath);
    var store = stringMapStoreFactory.store('credentials');

    await store.record(username).put(_db, {'username': username, 'password': username, 'email': username});
  }

  Future<String> getPassword(String username) async {
    Map userCredentials = await getUserCredentials(username);
    return userCredentials["password"];
  }
}