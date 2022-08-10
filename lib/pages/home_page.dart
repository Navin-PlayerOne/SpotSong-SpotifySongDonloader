import 'package:flutter/material.dart';
import 'package:spotsong/model/song_model.dart';
import 'package:spotsong/pages/navigation_bar.dart';

import '../decorations/toast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _link = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: NewNavBar(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Spotify Song Downloader',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(25.0),
          children: [
            TextField(
              decoration: const InputDecoration(
                  hintText: 'PlayList or Song Link from spotify'),
              controller: _link,
            ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
                child: const Text('Validate'),
                onPressed: () {
                  validate(_link.text);
                })
          ],
        ),
      ),
    );
  }

  void validate(String link) {
    String type = '';
    String token = '';
    bool flag = false;
    if (link.contains('track') && link.contains('spotify')) {
      type = 'track';
      flag = true;
      String req = link.split('/').last;
      token = req.split('?').first;
    } else if (link.contains('playlist') && link.contains('spotify')) {
      type = 'playlist';
      flag = true;
      String req = link.split('/').last;
      token = req.split('?').first;
    } else {
      showMessage('Invalid link', Colors.red, context);
    }
    if (flag) {
      SongModel.token = token;
      SongModel.type = type;
      Navigator.pushNamed(context, '/showsongs');
    }
  }
}
