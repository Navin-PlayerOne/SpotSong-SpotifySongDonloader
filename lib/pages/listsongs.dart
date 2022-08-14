import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spotsong/model/song_model.dart';
import 'package:spotsong/services/songs_list_services.dart';
import 'package:spotify/spotify.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../decorations/toast.dart';

class ShownSongs extends StatefulWidget {
  const ShownSongs({Key? key}) : super(key: key);

  @override
  State<ShownSongs> createState() => _ShownSongsState();
}

class _ShownSongsState extends State<ShownSongs> {
  //Map data = {};
  var info;
  bool isLoading = true;

  bool isStartedDownloading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    try {
      get();
    } on SpotifyException catch (_, e) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  get() async {
    if (SongModel.type == "playlist") {
      info = await getPlayList(SongModel.token);
    } else if (SongModel.type == "track") {
      info = await getSong(SongModel.token);
    }
    setState(() {
      isLoading = false;
    });
    return info;
  }

  @override
  Widget build(BuildContext context) {
    //data = ModalRoute.of(context)!.settings.arguments as Map;
    return isLoading
        ? Scaffold(body: ListView.builder(
            itemBuilder: (context, index) {
              return getEffect();
            },
          ))
        : Scaffold(
            //bottomNavigationBar: const NewNavBar(),
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              centerTitle: true,
              title: Text(
                'FetchedSongs : (${info.length})',
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return ShowCase(index);
              },
              itemCount: info.length,
            ),
            floatingActionButton: !isStartedDownloading
                ? FloatingActionButton(
                    child: Icon(Icons.download),
                    onPressed: () {
                      showMessage('Download Started', Colors.green, context);
                      setState(() {
                        isStartedDownloading = true;
                      });
                      startProcess(info);
                    })
                : null);
  }

  Widget ShowCase(index) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      elevation: 7.0,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: info[index].imgurl,
            height: 60,
            width: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(info[index].title,
            overflow: TextOverflow.ellipsis, maxLines: 1),
        subtitle: Text(info[index].artist,
            overflow: TextOverflow.ellipsis, maxLines: 1),
        trailing: isStartedDownloading ? processdl(info[index]) : null,
      ),
    );
  }

  startProcess(info) async {
    for (int i = 0; i < info.length; i++) {
      setState(() {
        info[i].statusCode = 2;
      });
      String query = info[i].title + " by " + info[i].artist;
      var yt = YoutubeExplode();
      var buff;
      try {
        buff = await yt.search.search(query, filter: TypeFilters.video);
      } catch (e) {
        setState(() {
          isStartedDownloading = false;
        });
        showMessage('Network error', Colors.red, context);
        return null;
      }
      var result = buff.first;
      info[i].ytvname = result.title;
      info[i].ytvid = result.id;
      int status = await download(info[i]);
      if (status == 0 || status == 1) {
        setState(() {
          info[i].statusCode = 1;
        });
      } else if (status == -1) {
        setState(() {});
        info[i].statusCode = -1;
      }
    }
  }

  Widget processdl(song) {
    switch (song.statusCode) {
      case 0:
        return const Icon(Icons.timelapse_outlined);
      case 1:
        return const Icon(Icons.download_done_outlined);
      case -1:
        return IconButton(
            icon: const Icon(Icons.refresh_outlined),
            color: Colors.red,
            onPressed: () async {
              int status = await download(song);
              if (status == 0 || status == 1) {
                setState(() {
                  song.statusCode = 1;
                });
              } else if (status == -1) {
                setState(() {});
                song.statusCode = -1;
              }
            });
      case 2:
        return CircularProgressIndicator(
          value: song.progress,
          backgroundColor: Colors.white,
          valueColor: const AlwaysStoppedAnimation(Colors.green),
          strokeWidth: 5,
        );
    }
    return Icon(Icons.error);
  }

  Future download(songInfo) async {
    //var video = await yt.videos.get(id);
    //getting permissinon
    final statusStorage = await Permission.storage.request();
    //final statusExStorage = await Permission.manageExternalStorage.request();
    //final statusMediaLoc = await Permission.accessMediaLocation.request();
    final downloadPath = await getExternalStorageDirectory();

    if (statusStorage.isGranted &&
        // statusExStorage.isGranted &&
        //statusMediaLoc.isGranted &&
        downloadPath != null) {
      var yt = YoutubeExplode();

      var manifest = await yt.videos.streamsClient.getManifest(songInfo.ytvid);

      //getting audio with highest bitrate avilable

      var audio = manifest.audioOnly.withHighestBitrate();
      var checkPath =
          File('${downloadPath.path.split("/Android")[0]}/spotsongs');
      //create download folder if not exists
      if (!checkPath.existsSync()) {
        //downloadedFile.create(recursive: true,);
        Directory('${downloadPath.path.split("/Android")[0]}/spotsongs')
            .createSync();
      }
      String buff = songInfo.ytvname;
      buff = buff.replaceAll('?', '');
      print(buff);
      final downloadedFile = await File(
          '${downloadPath.path.split("/Android")[0]}/spotsongs/${buff.toString()}.mp3');
      print("errorrs");
      print(downloadedFile.path);
      print('hii');
      if (downloadedFile.existsSync() && downloadedFile.lengthSync() > 0) {
        return 0;
      }
      print("bye");
      var file = File(downloadedFile.path);
      var fileStream = file.openWrite();

      var audioStream = yt.videos.streamsClient.get(audio);

      var len = audio.size.totalBytes;
      var count = 0;

      await for (final data in audioStream) {
        // Keep track of the current downloaded data.
        count += data.length;

        // Calculate the current progress.
        //var progress = ((count / len) * 100).ceil();

        //      setState(() {
        double progress = count / len;
        //    });
        //print(progress);
        setState(() {
          songInfo.progress = progress;
        });
        // Write to file.
        fileStream.add(data);
      }

      //await yt.videos.streamsClient.get(audio).pipe(fileStream);

      //await localFile.close();
      await fileStream.flush();
      await fileStream.close();
      return 1;
    } else {
      print("failed");
      return -1;
    }
  }
}

Shimmer getEffect() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 100,
          color: Colors.white,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 18.0,
                color: Colors.white,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 14.0,
                color: Colors.white,
              ),
            ],
          ),
        )
      ],
    ),
  );
}
