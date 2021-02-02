import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

CollectionReference refreshcollection =
    FirebaseFirestore.instance.collection('refresh');

refreshStarter() async {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  var doc = refreshcollection.doc(firebaseUser.uid);
  await doc.set({
    'uid': firebaseUser.uid,
    'refresh': 1,
  });
}
