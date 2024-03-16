// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:easy_youtube/core/datasource/stream_info_datasource.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await Permission.storage.request();
                  await Permission.manageExternalStorage.request();

                  Directory directory = Directory('/sdcard/easy_youtube');
                  StreamInfoDatasource videoDatasource =
                      StreamInfoDatasource(directory);
                  await videoDatasource
                      .downloadLink('https://youtube.com/watch?v=q7REefnce9A');
                },
                child: Text('Convert'))
          ],
        ),
      ),
    );
  }
}
