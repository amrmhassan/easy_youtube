import 'dart:io';

import 'package:easy_youtube/datasource/stream_info_datasource.dart';

String youtubeLink = 'https://www.youtube.com/watch?v=pxl-tA1tm80';

void main() async {
  Directory directory = Directory(
      'D:/Study And Work/Work/projects/flutter/Easy YouTube/project_core/files');
  StreamInfoDatasource videoDatasource = StreamInfoDatasource(directory);
  await videoDatasource.downloadLink(youtubeLink);
}
