import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _error = false;

  FirebaseFirestore _instance;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _instance = FirebaseFirestore.instance;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  Widget _getLoadingWidget([String _label = "Initializing Firebase..."]) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text(_label),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getErrorWidget(
      [String _label = "An error has occurred. Please try again"]) {
    return Scaffold(
      body: Center(
        child: Text(_label),
      ),
    );
  }

  Widget _getSuccessWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riskfactor"),
      ),
      body: StreamBuilder(
        stream: _instance.collection("users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return _getErrorWidget("Couldn't retrieve users.");
          }

          if (snapshot.connectionState == ConnectionState.active) {
            List<String> userNames = snapshot.data.docs
                .map((user) => user.data()['name'].toString())
                .toList();
            return SafeArea(
              child: Container(
                child: Center(
                  child: ListView.builder(
                      itemCount: userNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(userNames[index]),
                        );
                      }),
                ),
              ),
            );
          }

          return _getLoadingWidget("Getting all users...");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_error) return _getErrorWidget();
    if (_instance == null) return _getLoadingWidget();
    return _getSuccessWidget();
  }
}
