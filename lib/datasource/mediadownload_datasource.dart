// import 'dart:io';

// import 'package:easy_youtube/constants/runtime.dart';
// import 'package:easy_youtube/datasource/files_datasource.dart';
// import 'package:easy_youtube/datasource/media_merge_datasource.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// class MediaDownloadDatasource {
//   final _yt = YoutubeExplode();
//   late FilesDatasource _filesDatasource;
//   final MediaMergeDatasource _mergeDatasource = MediaMergeDatasource();

//   final List<AudioOnlyStreamInfo> _audios;
//   final Directory _downloadDir;

//   MediaDownloadDatasource(this._audios, this._downloadDir) {
//     _filesDatasource = FilesDatasource(parent: _downloadDir);
//   }

//   Future<String> downloadVideo(
//     VideoStreamInfo video,
//     String title,
//   ) async {
//     String downloadedVideo = await _downloadStreamClient(video, title);
//     var audio = _suitableAudio(video);
//     String downloadedAudio = await _downloadStreamClient(audio, title);
//     return _mergeDatasource.mergeInPlace(
//       videoPath: downloadedVideo,
//       audioPath: downloadedAudio,
//     );
//   }

//   Future<String> downloadAudio(
//     AudioStreamInfo audio,
//     String? audioTitle,
//   ) async {
//     String title = audioTitle ?? gId.generate();
//     return _downloadStreamClient(audio, title);
//   }

//   Future<String> _downloadStreamClient(
//     StreamInfo info,
//     String title,
//   ) async {
//     String ext = info.codec.subtype;
//     String fileName = '$title.$ext';
//     var stream = _yt.videos.streamsClient.get(info);
//     fileName = await _generateFileName(fileName);
//     String downloadPath = '${_downloadDir.path}/$fileName';
//     File file = File(downloadPath);
//     if (!_downloadDir.existsSync()) {
//       _downloadDir.createSync(recursive: true);
//     }
//     var fileStream = file.openWrite();
//     await stream.pipe(fileStream);
//     await fileStream.flush();
//     await fileStream.close();
//     return file.path;
//   }

//   AudioOnlyStreamInfo _suitableAudio(VideoStreamInfo video) {
//     var videoBitrate = video.bitrate;
//     double distance = double.infinity;
//     AudioOnlyStreamInfo closestAudio = _audios.first;

//     for (var audio in _audios) {
//       int currentDistance =
//           audio.bitrate.bitsPerSecond - videoBitrate.bitsPerSecond;
//       if (currentDistance < distance) {
//         closestAudio = audio;
//       }
//     }
//     return closestAudio;
//   }

//   Future<String> _generateFileName(String title) async {
//     var name = _filesDatasource.makeValidFileName(title);
//     return name;
//   }
// }
