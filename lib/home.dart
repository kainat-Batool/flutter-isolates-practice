import 'dart:isolate';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            ElevatedButton(
              onPressed: () async{
                var total = await complexTask1();
                debugPrint('Result 01: ${total.toString()}');
              },
              child: Text('Task 01 '),
            ),
            ElevatedButton(
              onPressed: () async {
                final receivePort = ReceivePort();
                Isolate.spawn(complexTask2, receivePort.sendPort);
                receivePort.listen((total) {
                  debugPrint('Result 02: ${total.toString()}');
                });
              },
              child: Text('Task 02 '),
            ),
          ],
        ),
      ),
    );
  }

  Future<double> complexTask1() async{
    var total = 0.0;
    for(var i = 0 ; i < 1000000000; i++){
      total += i;
    }
    return total;
  }
}

complexTask2 (SendPort sentPort){
  var total = 0.0;
  for(var i = 0 ; i < 1000000000; i++){
    total += i;
  }
  sentPort.send(total);
}