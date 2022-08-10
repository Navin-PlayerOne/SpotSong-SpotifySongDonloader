import 'package:spotify/spotify.dart';
import 'package:spotsong/model/song_model.dart';

const _clientId = 'e0761290696148fc8f8b697af88587fc';
const _clientSecret = '4cfce017435043fc9b7c5e516dd5e67b';

Future getPlayList(String token) async {
  try {
    List<SongInfo> infos = [];
    final credentials = await SpotifyApiCredentials(_clientId, _clientSecret);
    final spotify = await SpotifyApi(credentials);
    var res = await spotify.playlists.getTracksByPlaylistId(token).all();
    res.forEach((each) {
      infos.add(SongInfo(
          title: each.name!,
          artist: each.artists!.first.name!,
          imgurl: each.album!.images!.first.url!));
    });
    return infos;
  } catch (e) {
    throw SpotifyException;
  }
}

Future getSong(String token) async {
  final credentials = await SpotifyApiCredentials(_clientId, _clientSecret);
  final spotify = await SpotifyApi(credentials);
  var res = await spotify.tracks.get(token);
  List<SongInfo> infos = [];
  SongInfo info = SongInfo(
      artist: res.artists!.first.name!,
      imgurl: res.album!.images!.first.url!,
      title: res.name!);
  infos.add(info);
  return infos;
}
