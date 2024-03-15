import 'dart:io';

import 'package:easy_youtube/constants/runtime.dart';
import 'package:easy_youtube/datasource/file_download_datasource.dart';
import 'package:easy_youtube/datasource/media_merge_datasource.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MediaDownloadDatasource {
  final MediaMergeDatasource _mergeDatasource = MediaMergeDatasource();

  final List<AudioOnlyStreamInfo> _audios;
  final Directory _downloadDir;
  late FileDownloadDatasource _downloadDatasource;

  MediaDownloadDatasource(this._audios, this._downloadDir) {
    _downloadDatasource = FileDownloadDatasource(_downloadDir);
  }

  Future<String> downloadVideo(
    VideoStreamInfo video,
    String title,
  ) async {
    logger.i('Starting downloading video');
    String downloadedVideo =
        await _downloadDatasource.downloadStreamClient(video, null);
    logger.i('Video downloaded');
    logger.i('Starting downloading audio');
    var audio = _suitableAudio(video);
    String downloadedAudio =
        await _downloadDatasource.downloadStreamClient(audio, null);
    logger.i('audio downloaded');
    logger.i('starting merging');
    var finalFilePath = await _mergeDatasource.mergeInPlace(
      videoPath: downloadedVideo,
      audioPath: downloadedAudio,
      outputPath: _getMediaOutputPath(video, title),
    );
    logger.i('merged successfully');
    return finalFilePath;
  }

  Future<String> downloadAudio(
    AudioStreamInfo audio,
    String? audioTitle,
  ) async {
    String title = audioTitle ?? gId.generate();
    return _downloadDatasource.downloadStreamClient(audio, title);
  }

  AudioOnlyStreamInfo _suitableAudio(VideoStreamInfo video) {
    var videoBitrate = video.bitrate;
    double distance = double.infinity;
    AudioOnlyStreamInfo closestAudio = _audios.first;

    for (var audio in _audios) {
      int currentDistance =
          audio.bitrate.bitsPerSecond - videoBitrate.bitsPerSecond;
      if (currentDistance < distance) {
        closestAudio = audio;
      }
    }
    return closestAudio;
  }

  String _getMediaOutputPath(StreamInfo info, String title) {
    String ext = info.codec.subtype;

    return '${_downloadDir.path}/$title.$ext';
  }
}
