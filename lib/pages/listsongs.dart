import 'package:flutter/material.dart';
import 'package:spotsong/model/song_model.dart';
import 'package:spotsong/services/songs_list_services.dart';

class ShownSongs extends StatefulWidget {
  const ShownSongs({Key? key}) : super(key: key);

  @override
  State<ShownSongs> createState() => _ShownSongsState();
}

class _ShownSongsState extends State<ShownSongs> {
  //Map data = {};
  var info;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    get();
  }

  get() async {
    info = await getPlayList(SongModel.token);
    setState(() {
      isLoading = false;
    });
    return info;
  }

  @override
  Widget build(BuildContext context) {
    //data = ModalRoute.of(context)!.settings.arguments as Map;
    return isLoading
        ? const Scaffold(
            body: Center(
              child: Text("loading"),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'FetchedSongList ',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(25.0)),
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Title : " + info[index].first),
                        Text("Artist : " + info[index].last)
                      ],
                    ),
                  ),
                );
              },
              itemCount: info.length,
            ),
          );
  }
}
