import 'package:spotify/spotify.dart';

const _clientId = 'e0761290696148fc8f8b697af88587fc';
const _clientSecret = '4cfce017435043fc9b7c5e516dd5e67b';

Future<List> getPlayList(String token) async {
  final credentials = await SpotifyApiCredentials(_clientId, _clientSecret);
  final spotify = await SpotifyApi(credentials);
  var res = await spotify.playlists.getTracksByPlaylistId(token).all();
  List playlistInfo = res.map((e) => {e.name, e.artists!.first.name}).toList();
  print(playlistInfo);
  return playlistInfo;
}
