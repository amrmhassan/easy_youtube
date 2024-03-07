// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'dart:math';

import 'package:dart_id/dart_id.dart';
import 'package:path/path.dart' as path;

String _randomSeparator = '._';

class FileNameModel {
  final String name;
  final String random;
  String ext;

  FileNameModel({
    required this.name,
    required this.random,
    required this.ext,
  });

  @override
  String toString() {
    if (random.isEmpty) {
      return '$name$ext';
    } else {
      return '$name$_randomSeparator$random$ext';
    }
  }

  static FileNameModel fromPath(String filePath) {
    File file = File(filePath);
    String parentPath = file.parent.path;
    String basenameString = path.basename(filePath);
    FileNameModel fileNameModel = FileNameModel.fromString(basenameString);

    String name = '$parentPath/${fileNameModel.name}';
    return FileNameModel(
      name: name,
      random: fileNameModel.random,
      ext: fileNameModel.ext,
    );
  }

  static FileNameModel fromString(String text) {
    String fileName = text.replaceAll(RegExp(r'[\/:*?"<>|]'), '_');
    fileName = fileName.substring(0, min(fileName.length, 200));

    String basenameOnly = path.basenameWithoutExtension(fileName);
    var parts = basenameOnly.split(_randomSeparator);
    String name;
    String random;
    String ext = path.extension(fileName);

    if (parts.length > 1) {
      name = parts.sublist(0, parts.length - 1).join('');
      random = parts.last;
    } else {
      random = '';
      name = fileName;
    }
    return FileNameModel(name: name, random: random, ext: ext);
  }

  FileNameModel randomize() {
    DartID dartID = const DartID(
      idLength: 5,
      allowDateTime: false,
    );

    String newRandom = dartID.generate();
    return FileNameModel(name: name, random: newRandom, ext: ext);
  }
}
