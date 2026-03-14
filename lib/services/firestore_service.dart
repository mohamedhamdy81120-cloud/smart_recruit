import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set(data);
  }

  Stream<DocumentSnapshot> getUser(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }
}
