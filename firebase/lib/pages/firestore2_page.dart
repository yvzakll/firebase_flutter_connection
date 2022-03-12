// ignore_for_file: await_only_futures, unused_local_variable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestorePage2 extends StatelessWidget {
  FirestorePage2({Key? key}) : super(key: key);
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? __userSubscribe;

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
              child: Text("Veri Ekle add"),
            ),
            ElevatedButton(
              onPressed: () {
                veriEklemeSet();
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: Text("Veri Ekle set"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text("geri dön"),
            ),
            ElevatedButton(
              onPressed: () {
                veriGuncelleme();
              },
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              child: Text("Veri Güncelle"),
            ),
            ElevatedButton(
              onPressed: () {
                veriSil();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Veri Sil"),
            ),
            ElevatedButton(
              onPressed: () {
                veriOkuOneTime();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Veri Oku Onetime"),
            ),
            ElevatedButton(
              onPressed: () {
                veriOkuRealTime();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: Text("Veri Oku RealTime"),
            ),
            ElevatedButton(
              onPressed: () {
                batchKavrami();
              },
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              child: Text("Batch Kavrami"),
            ),
            ElevatedButton(
              onPressed: () {
                veriSorgulama();
              },
              style: ElevatedButton.styleFrom(primary: Colors.amber),
              child: Text("Veri Sorgulama"),
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

  void veriEklemeSet() async {
    await _firestore
        .doc('users2/q43sbbvNWlH3qZEW59EI')
        .set({'okul': 'Süleyman Demire Üniversitesi'}, SetOptions(merge: true));
  }

  Future<void> veriGuncelleme() async {
    await _firestore
        .doc('users2/q43sbbvNWlH3qZEW59EI')
        .update({'adres.ilce': 'esenyurt yeni'});
  }

  Future<void> veriSil() async {
    await _firestore.doc('users2/q43sbbvNWlH3qZEW59EI').delete();
  }

  //snapshot şeklinde yani anlık olarak bir kereliğine veriler getirilir.
  Future<void> veriOkuOneTime() async {
    //koleksiyondan dökümana gidildi
    var _usersDocuments = await _firestore.collection('users2').get();
    debugPrint(_usersDocuments.docs.length.toString());

    for (var eleman in _usersDocuments.docs) {
      debugPrint("doöküman id:  ${eleman.id}");
      Map _userMap = eleman.data();
      debugPrint(_userMap['isim']);
    }
    var _selimDoc = await _firestore.doc('users2/Djvb32nT7JSslFpVIUNK').get();
    debugPrint(_selimDoc.data().toString());
  }

  Future<void> veriOkuRealTime() async {
    var _userStream = await _firestore
        .collection('users2')
        .snapshots(); //databasedeki tüm verileri bir kere getirir
    __userSubscribe = _userStream.listen((event) {
      //_userStream.liste değişiklikleri dinlediğiimiz method bunu daha sonra durdurabilmek için _userSubscribe olarak atıyoruz
      event.docChanges.forEach((element) {
        debugPrint(element.doc
            .data()
            .toString()); //burası da verilerdeki değişiklikleri tek tek okuyup ekrana yazdırdığımız kısım
      });

      /*   event.docs.forEach((element) {
        debugPrint(element.data().toString());    //bu da aynı görevde
      }); */
    });
  }

  streamDurdur() {
    __userSubscribe?.cancel();
  }

  void batchKavrami() async {
    WriteBatch _batch = _firestore.batch();
    CollectionReference _counterColRef = _firestore.collection('counter');
    //batch ile toplu eleman ekleme
    /*  for (var i = 0; i < 100; i++) {
      var _yeniDoc = _counterColRef.doc();
      _batch.set(_yeniDoc, {'sayac': i++, 'id': _yeniDoc.id});
    } */

    //toplu güncelleme
    /*    var _counterDocs = await _counterColRef.get();
    _counterDocs.docs.forEach((element) {
      _batch.update(
          element.reference, {'createdAt': FieldValue.serverTimestamp()});
    }); */

    //toplu silme işlemi komple tüm documenti ve collectionu siler
    var _counterDocs = await _counterColRef.get();
    _counterDocs.docs.forEach((element) {
      _batch.delete(element.reference);
    });
    await _batch.commit();
  }

  Future<void> veriSorgulama() async {
    var _userRef = _firestore.collection("users2");
    var sonuc = await _userRef
        .where('yas', isLessThan: 45)
        .get(); //sorgu scripti burası
    for (var user in sonuc.docs) {
      debugPrint(user.data().toString());
    }
    var _sirala = await _userRef.orderBy('yas', descending: false).get();
    for (var user in _sirala.docs) {
      debugPrint(user.data().toString());
    }
  }
}
