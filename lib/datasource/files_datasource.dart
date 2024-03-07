// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:easy_youtube/models/file_name_model.dart';

class FilesDatasource {
  final Directory parent;
  FilesDatasource({
    required this.parent,
  });

  Future<String> makeValidFileName(String text) async {
    // Replace illegal characters with underscores
    FileNameModel sanitizedText = FileNameModel.fromString(text);

    // Limit length (adjust the limit as needed)
    sanitizedText = await _generateUniqueName(sanitizedText);

    return sanitizedText.toString();
  }

  Future<FileNameModel> _generateUniqueName(FileNameModel fileModel) async {
    if (!parent.existsSync()) {
      return fileModel;
    }
    var children = parent.listSync();
    bool exist = children
        .any((element) => p.basename(element.path) == fileModel.toString());
    if (exist) {
      var newRandom = fileModel.randomize();
      return _generateUniqueName(newRandom);
    } else {
      return fileModel;
    }
  }
}
