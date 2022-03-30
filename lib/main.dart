import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp();
    
    if (kDebugMode) {
      // FirebaseFirestore.instance.useFirestoreEmulator(
      //   Platform.isAndroid ? "10.0.2.2" : "localhost",
      //   8080,
      // );
      FirebaseFirestore.instance.settings = Settings(
        host: Platform.isAndroid ? "10.0.2.2:8080" : "localhost:8080",
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }
  } 
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _incrementCounter() async {
    await _firestore.collection("increment").doc("inc").update({
      "value": FieldValue.increment(1),
    });
  }

  @override
  void initState() {
    super.initState();
    _firestore.collection("increment").doc("inc").get().then((value) {});
  }

  Widget _body(BuildContext context,
      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text(
        "Loading ...",
        style: Theme.of(context).textTheme.headline4,
      );
    }
    if (snapshot.data!.exists) {
      Map<String, dynamic>? data = snapshot.data!.data();
      return Text(
        data!["value"].toString(),
        style: Theme.of(context).textTheme.headline4,
      );
    }

    return Text(
      "No connection found",
      style: Theme.of(context).textTheme.headline4,
    );
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
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              stream: _firestore.collection("increment").doc("inc").snapshots(),
              builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) =>
                  _body(context, snapshot),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
