import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:spotify/spotify.dart';

class ShowInfo extends StatefulWidget {
  const ShowInfo({Key? key}) : super(key: key);

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  Map data = {};
  final _clientId = 'e0761290696148fc8f8b697af88587fc';
  final _clientSecret = '4cfce017435043fc9b7c5e516dd5e67b';
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final credentials =
                await SpotifyApiCredentials(_clientId, _clientSecret);
            final spotify = await SpotifyApi(credentials);
            print(credentials.expiration);
            print(credentials.isExpired);
            if (data['type'] == 'track') {
              //var res = spotify.tracks.get(data['token']);
              print('nooo');
            } else if (data['type'] == 'playlist') {
              var res =
                  await spotify.playlists.getTracksByPlaylistId(data['token']);
              //spotify.playlists.
              //var rres = (await res.first()).items!.first;
              var ans = (await res.first()).items!.toList();
              print(ans.length);
              ans.forEach((element) {
                print(element.name);
              });
            }
          },
          child: Text("fetch"),
        ),
      ),
    );
  }
}
