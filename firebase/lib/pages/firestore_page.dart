// ignore_for_file: prefer_final_fields, unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestorePage extends StatefulWidget {
  FirestorePage({Key? key}) : super(key: key);

  @override
  State<FirestorePage> createState() => _FirestorePageState();
}

class _FirestorePageState extends State<FirestorePage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                veriEklemeAdd();
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: Text("Veri Ekle"),
            ),
            ElevatedButton(
              onPressed: () {
                veriEklemeSet();
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: Text("Veri Ekle"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text("geri dön"),
            ),
          ],
        ),
      ),
    );
  }

  void veriEklemeAdd() {
    Map<String, dynamic> _eklenecekUser = <String, dynamic>{};
    _eklenecekUser['isim'] = 'yavuz';
    _eklenecekUser['yas'] = 23;
    _eklenecekUser['ogrenciMi'] = true;
    _eklenecekUser['adres'] = {'il': 'istanbul', 'ilce': 'beyoglu'};
    _eklenecekUser['renkler'] = FieldValue.arrayUnion(['mavi', 'yeşil']);
    _eklenecekUser['renkler'] = FieldValue.serverTimestamp();
    _firestore.collection('users2').add(_eklenecekUser);
  }

  void veriEklemeSet() {}
}
