import 'dart:io';

import 'package:easy_youtube/datasource/download_datasource.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import "package:collection/collection.dart";

class StreamInfoDatasource {
  final _yt = YoutubeExplode();

  final Directory _downloadDir;
  StreamInfoDatasource(this._downloadDir);

  Future<void> downloadLink(String link) async {
    var video = await _yt.videos.get(link);
    String videoId = video.id.value;
    String title = video.title;
    var streams = await _yt.videos.streams.getManifest(videoId);
    var audios = getAudios(streams);
    var videos = getVideos(streams);

    DownloadDatasource downloadDatasource =
        DownloadDatasource(audios, _downloadDir);
    await downloadDatasource.downloadVideo(videos.first, title);
    print('Downloaded');
  }

  List<VideoOnlyStreamInfo> getVideos(StreamManifest streams) {
    String ext = 'mp4';
    // var q = streams.video.getAllVideoQualities();
    var videoOnly =
        streams.videoOnly.where((element) => element.container.name == ext);
    List<VideoOnlyStreamInfo> highestBitrateVideos = [];

    var groupedStreams = groupBy(videoOnly,
        (video) => video.videoResolution.width * video.videoResolution.height);

    groupedStreams.forEach((resolution, streams) {
      VideoOnlyStreamInfo highestBitrateVideo = streams.reduce(
          (a, b) => a.bitrate.bitsPerSecond > b.bitrate.bitsPerSecond ? a : b);
      highestBitrateVideos.add(highestBitrateVideo);
    });

    return highestBitrateVideos;
  }

  List<AudioOnlyStreamInfo> getAudios(StreamManifest streams) {
    return streams.audioOnly;
  }
}
