import 'dart:io';

import 'package:easy_youtube/constants/runtime.dart';
import 'package:easy_youtube/datasource/files_datasource.dart';
import 'package:easy_youtube/models/file_name_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class FileDownloadDatasource {
  late FilesDatasource _filesDatasource;

  final _yt = YoutubeExplode();
  final Directory _downloadDir;

  FileDownloadDatasource(this._downloadDir) {
    _filesDatasource = FilesDatasource(parent: _downloadDir);
  }

  Future<String> downloadStreamClient(
    StreamInfo info,
    String? title,
  ) async {
    String fileTempTitle = gId.generate();
    String ext = info.codec.subtype;
    String tempFileName = '$fileTempTitle.$ext';
    String finalFileName = '${title ?? fileTempTitle}.$ext';
    var stream = _yt.videos.streamsClient.get(info);
    tempFileName = await _generateFileName(tempFileName);
    String downloadPath = '${_downloadDir.path}/$tempFileName';
    File file = File(downloadPath);
    if (!_downloadDir.existsSync()) {
      _downloadDir.createSync(recursive: true);
    }
    var fileStream = file.openWrite();
    await stream.pipe(fileStream);
    await fileStream.flush();
    await fileStream.close();
    var finalFile = await _rename(file, finalFileName);
    return finalFile.path;
  }

  Future<String> _generateFileName(String title) async {
    var name = _filesDatasource.makeValidFileName(title);
    return name;
  }

  Future<File> _rename(
    File file,
    String newName, {
    bool autoRandomize = true,
  }) async {
    FileNameModel fileNameModel = FileNameModel.fromPath(file.path);
    var uniqueFileName =
        await _filesDatasource.generateUniqueName(fileNameModel);
    String newPath = autoRandomize
        ? uniqueFileName.toString()
        : '${file.parent.path}/$newName';
    return file.rename(newPath);
  }
}
