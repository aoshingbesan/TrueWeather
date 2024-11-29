import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  final userUid = user?.uid;
  if (userUid != null) {
    final userData = await FirebaseFirestore.instance
        .collection('users') // Replace with your collection name
        .doc(userUid)
        .get();
    return userData;
  }
  return Future.error('User not authenticated');
}
