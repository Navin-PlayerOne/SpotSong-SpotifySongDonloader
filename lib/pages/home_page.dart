import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Spotify Downloader'),
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
      showMessage('Invalid link', Colors.red);
    }
    if (flag) {
      Navigator.pushNamed(context, '/showinfo',
          arguments: {'type': type, 'token': token});
    }
  }

  void showMessage(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
          height: 30.0,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(20.0))),
          child: Center(
            child: Text(
              msg,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          )),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ));
  }
}
