import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Home Screen",
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              child: const Text("Go to Home Screen"),
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
            ),
          ],
        ),
      ),
    );
  }
}