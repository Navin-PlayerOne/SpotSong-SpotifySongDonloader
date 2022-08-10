class SongModel {
  static String token = "";
  static String type = "";
}

class SongInfo {
  String title = "";
  String artist = "";
  String imgurl = "";
  double progress = 0.0;
  int statusCode = 0;
  String ytvname = "";
  var ytvid;
  SongInfo({this.artist = "", this.title = "", this.imgurl = ""});
}
