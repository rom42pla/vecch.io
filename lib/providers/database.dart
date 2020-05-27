import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vecchio/pages/medicines.dart';
import 'package:requests/requests.dart';

class DatabaseProvider {
  static String _dbPath = "vecchio.db";
  Database _db;

  ///
  /// Local storage
  ///

  Future<void> clearLocalStorage() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase(appDocumentDir.path + _dbPath);
    var store = stringMapStoreFactory.store('credentials');
    store.delete(_db);
  }

  Future<Map> getLoggedUserCredentialsFromLocalStorage() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase(appDocumentDir.path + _dbPath);
    var store = stringMapStoreFactory.store('credentials');
    RecordSnapshot record = await store.findFirst(_db, finder: Finder());
    var userCredentials;
    try {
      userCredentials = record.value;
    } catch (e) {
      userCredentials = null;
    }
    return userCredentials;
  }

  Future<void> saveUserCredentialsToLocalStorage({String username}) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    _db = await databaseFactoryIo.openDatabase(appDocumentDir.path + _dbPath);
    var store = stringMapStoreFactory.store('credentials');

    await store.record(username).put(
        _db, await getUserCredentials(username: username, email: username));
  }

  ///
  /// Firebase storage
  ///

  static var _databaseReference = Firestore.instance;

  void updateData() {
    try {
      _databaseReference
          .collection('Medicine')
          .document('Luigi')
          .updateData({'Medicine': 2});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> checkIfUserExists({String username, String email}) async {
    List documents;
    // check if the username exists
    if (username != null) {
      documents = new List();
      await _databaseReference
          .collection("credentials")
          .where("username", isEqualTo: username)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) => documents.add(f.data));
      });
      if (documents.isNotEmpty) return true;
    }
    // check if the email exists
    if (email != null) {
      documents = new List();
      await _databaseReference
          .collection("credentials")
          .where("email", isEqualTo: email)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) => documents.add(f.data));
      });
      if (documents.isNotEmpty) return true;
    }
    // the user doesn't exists yet
    return false;
  }

  Future<Map> getUserCredentials({String username, String email}) async {
    if (username == null && email == null)
      throw Exception("No user nor email given");
    List documents;
    // check if the username exists
    if (username != null) {
      documents = new List();
      await _databaseReference
          .collection("credentials")
          .where("username", isEqualTo: username)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) => documents.add(f.data));
      });
      if (documents.isNotEmpty) return documents[0];
    }
    // check if the email exists
    if (email != null && documents.isEmpty) {
      documents = new List();
      await _databaseReference
          .collection("credentials")
          .where("email", isEqualTo: email)
          .getDocuments()
          .then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) => documents.add(f.data));
      });
      if (documents.isNotEmpty) return documents[0];
    }
    return null;
  }

  void createUser(
      {String name,
      String surname,
      String username,
      String email,
      String password}) async {
    if (!await checkIfUserExists(username: username, email: email)) {
      await _databaseReference
          .collection("credentials")
          .document(username)
          .setData({
        'name': name,
        'surname': surname,
        'username': username,
        'email': email,
        'password': password,
        'registration_date': DateTime.now().toString()
      });
    }
  }

  void deleteUser() async {
    try {
      String _username =
          (await getLoggedUserCredentialsFromLocalStorage())["username"];
      await _databaseReference.collection('credentials').document(_username).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  ///
  ///
  /// Medicines
  ///
  ///
  Future<void> addMedicine({String medicineName, int slot}) async {
    String _username =
        (await getLoggedUserCredentialsFromLocalStorage())["username"];
    if (!(await getMedicines()).containsKey(medicineName)){
      await _databaseReference
          .collection("medicines")
          .document("$_username")
          .setData({
        medicineName: {
          'container_slot': slot,
          'registration_date': DateTime.now().toString(),
          'alarms': [],
          'assumptions_dates': []
        }
      });
    }
    else{
      await _databaseReference
          .collection("medicines")
          .document("$_username")
          .updateData({
        medicineName: {
          'container_slot': slot,
          'registration_date': DateTime.now().toString(),
          'alarms': [],
          'assumptions_dates': []
        }
      });
    }
  }

  Future<Map> getMedicines() async {
    String _username =
        (await getLoggedUserCredentialsFromLocalStorage())["username"];
    Map medicines = new Map();
    await _databaseReference
        .collection("medicines")
        .document("$_username")
        .get()
        .then((value) => medicines = value.data);
    if(medicines == null) medicines = new Map();
    return medicines;
  }

  Future<void> deleteMedicine({String medicineName}) async {
    try {
      String _username =
      (await getLoggedUserCredentialsFromLocalStorage())["username"];
      Map _oldData = await getMedicines();
      _oldData.remove(medicineName);
      await _databaseReference.collection('medicines').document(_username).setData(_oldData);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateMedicineSlot({String medicineName, int slot}) async {
    String _username =
    (await getLoggedUserCredentialsFromLocalStorage())["username"];
    await _databaseReference
        .collection("medicines")
        .document("$_username")
        .updateData({
      medicineName: {
        'container_slot': slot,
      }
    });
  }

  Future<void> addAlarm({String medicineName, Map alarmMap}) async {
    String _username =
    (await getLoggedUserCredentialsFromLocalStorage())["username"];
    Map _oldData = await getMedicines();
    List alarms = _oldData[medicineName]["alarms"].toList();
    alarms.add(alarmMap);
    _oldData[medicineName]["alarms"] = alarms;
    await _databaseReference
        .collection("medicines")
        .document("$_username")
        .updateData(_oldData);
  }

  Future<void> deleteAlarm({String medicineName, int index}) async {
    String _username =
    (await getLoggedUserCredentialsFromLocalStorage())["username"];
    Map _oldData = await getMedicines();
    List alarms = _oldData[medicineName]["alarms"].toList();
    alarms.removeAt(index);
    _oldData[medicineName]["alarms"] = alarms;
    await _databaseReference
        .collection("medicines")
        .document("$_username")
        .updateData(_oldData);
  }
}
