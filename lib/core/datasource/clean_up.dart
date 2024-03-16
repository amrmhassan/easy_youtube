import 'dart:io';

class CleanUp {
  /// actual downloaded temp file
  final String tempPath;

  /// final containing folder path
  final String? trueParentPath;

  /// final file name
  final String? title;

  CleanUp({
    required this.tempPath,
    required this.trueParentPath,
    required this.title,
  });

  Future<String?> clean() async {
    File tempFile = File(tempPath);
    if (trueParentPath == null) {
      await tempFile.delete();
      return null;
    }
    String finalFilePath = '$trueParentPath/$title';
    File finalFile = File(finalFilePath);
    if (finalFile.existsSync()) {
      throw Exception('Final File already exists');
    }
    await tempFile.copy(finalFilePath);
    return finalFilePath;
  }
}
