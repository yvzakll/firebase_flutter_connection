// ignore_for_file: unused_local_variable

import 'package:firebase/pages/firestore2_page.dart';
import 'package:firebase/pages/firestore_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseAuth auth;
  final String _email = "ali.akll66@gmail.com";
  final String _password = "yenisifre";

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        debugPrint('Kullanıcı oturumu kapattı');
      } else {
        debugPrint(
            'oturum aktif ${user.email} ve email durumu ${user.emailVerified} ');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                createUserEmailAndPassword();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text("email şifre kayıt"),
            ),
            ElevatedButton(
              onPressed: () {
                loginUserEmailAndPassword();
              },
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: const Text("email şifre ile giriş"),
            ),
            ElevatedButton(
              onPressed: () {
                signOutUser();
              },
              style: ElevatedButton.styleFrom(primary: Colors.green),
              child: const Text("çıkış yap"),
            ),
            ElevatedButton(
              onPressed: () {
                deleteUser();
              },
              style: ElevatedButton.styleFrom(primary: Colors.purple),
              child: const Text("User silme"),
            ),
            ElevatedButton(
              onPressed: () {
                changePassword();
              },
              style: ElevatedButton.styleFrom(primary: Colors.brown),
              child: const Text("PAROLA DEĞİŞTİR"),
            ),
            ElevatedButton(
              onPressed: () {
                changeEmail();
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: const Text("EMAIL DEĞİŞTİR"),
            ),
            ElevatedButton(
              onPressed: () {
                googleIleGiris();
              },
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              child: const Text("gmail ile gir"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FirestorePage2(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Text("Firestore git"),
            ),
          ],
        ),
      ),
    );
  }

  //email ve pasaport ile kullanıcı oluşturma metodu
  Future<void> createUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      var _myUser = _userCredential.user;

      if (!_myUser!.emailVerified) {
        await _myUser.sendEmailVerification();
      } else {
        debugPrint("kullanıcı emailini onaylamadı,lütfen emaili onaylayın");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //email ve pasaport ile giriş yapma metodu
  Future<void> loginUserEmailAndPassword() async {
    try {
      var _userCredential = await auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      debugPrint(_userCredential.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> signOutUser() async {
    var _user = GoogleSignIn().currentUser;
    if (_user != null) {
      await GoogleSignIn().signOut();
    }
    await auth.signOut();
  }

  Future<void> deleteUser() async {
    if (auth.currentUser != null) {
      await auth.currentUser!.delete();
    } else {
      debugPrint("kullanıcı oturum açmadığı için silinemez");
    }
  }

  Future<void> changePassword() async {
    try {
      await auth.currentUser!.updatePassword("yenisifre");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        debugPrint("tekrar giriş yapılması gerekiyor");
        var credential =
            EmailAuthProvider.credential(email: _email, password: _password);
        auth.currentUser!.reauthenticateWithCredential(credential);
        await auth.currentUser!.updatePassword("yenisifre");
        await auth.signOut();
        debugPrint("şifre güncellendi");
      }
    } catch (e) {}
  }

  Future<void> changeEmail() async {
    try {
      await auth.currentUser!.updateEmail("slmakll@gmail.com");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        debugPrint("tekrar giriş yapılması gerekiyor");
        var credential =
            EmailAuthProvider.credential(email: _email, password: _password);
        auth.currentUser!.reauthenticateWithCredential(credential);
        await auth.currentUser!.updateEmail("slmakll@gmail.com");
        await auth.signOut();
        debugPrint("email güncellendi");
      }
    } catch (e) {}
  }

  Future<UserCredential> googleIleGiris() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
