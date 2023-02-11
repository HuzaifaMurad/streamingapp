import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming/page/director.dart';
import 'package:streaming/page/participant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _channalName = TextEditingController();
  final _userName = TextEditingController();
  late int uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserUid();
  }

  Future<void> getUserUid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? storeUid = preferences.getInt('localUid');
    if (storeUid != null) {
      uid = storeUid;
    } else {
      //if not created Uid we create it
      //should only happens once;
      int time = DateTime.now().millisecondsSinceEpoch;
      uid = int.parse(time.toString().substring(1, time.toString().length - 3));
      preferences.setInt('localUid', uid);
      log('setting uid :${uid}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://raw.githubusercontent.com/tadaspetra/flutter-projects/main/streamer/images/streamer.png',
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text('Streaming with people'),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                controller: _userName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(29),
                        borderSide: const BorderSide(color: Colors.grey)),
                    hintText: 'User Name'),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: TextField(
                controller: _channalName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(29),
                        borderSide: const BorderSide(color: Colors.grey)),
                    hintText: 'User Channal'),
              ),
            ),
            const SizedBox(
              height: 19,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Particpant(
                      channalName: _channalName.text,
                      userName: _userName.text,
                      uid: uid,
                    );
                  },
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Participant'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.live_tv),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Director(
                      channalName: _channalName.text,
                    );
                  },
                ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Director'),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.cancel_presentation),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
