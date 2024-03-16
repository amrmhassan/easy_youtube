import 'dart:io';

import 'package:easy_youtube/constants/runtime.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:easy_youtube/core/models/file_name_model.dart';

class MediaMergeDatasource {
  Future<String> mergeVideoAudio({
    required String videoPath,
    required String audioPath,
    required FileNameModel outputPath,
  }) async {
    File audioFile = File(audioPath);
    if (!audioFile.existsSync()) {
      throw Exception('Audio file doesn\'t exits at the path: $audioPath');
    }

    File videoFile = File(videoPath);
    // Directory fakeFolder = Directory('${videoFile.parent.path}/Fake');
    // if (!fakeFolder.existsSync()) {
    //   fakeFolder.createSync();
    // }
    if (!videoFile.existsSync()) {
      throw Exception('Video file doesn\'t exits at the path: $videoPath');
    }

    String command2 =
        '-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -strict experimental "$outputPath"';

    var session = await FFmpegKit.execute(command2);
    var returnCode = await session.getReturnCode();
    // Console output generated for this execution

    if (!ReturnCode.isSuccess(returnCode)) {
      final output = await session.getOutput();
      logger.e(output);
      logger.e(returnCode.toString());
      throw Exception('not succeeded');
    }
    audioFile.deleteSync();
    videoFile.deleteSync();
    logger.i('Done');
    return outputPath.toString();
  }

  Future<String> mergeInPlace({
    required String videoPath,
    required String audioPath,
    required String outputPath,
  }) async {
    FileNameModel fileNameModel = FileNameModel.fromPath(outputPath);

    return mergeVideoAudio(
      videoPath: videoPath,
      audioPath: audioPath,
      outputPath: fileNameModel,
    );
  }
}
