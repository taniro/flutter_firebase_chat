import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_chat/model/Message.dart';

class ChatService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String message) async {
    final String senderId = _firebaseAuth.currentUser!.uid;
    final String senderEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderId: senderId,
      senderEmail: senderEmail,
      message: message,
      timestamp: timestamp,
    );

    await _firebaseFirestore.collection("messages").add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages() {
    return _firebaseFirestore
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
