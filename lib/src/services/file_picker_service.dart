import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static final FilePickerService _instance = FilePickerService._internal();
  static final FilePickerService instance = FilePickerService();

  FilePickerService._internal();

  factory FilePickerService() {
    return _instance;
  }

  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    dynamic Function(FilePickerStatus)? onFileLoading,

    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    List<PlatformFile>? results = await FilePicker.pickFiles(
      allowedExtensions: allowedExtensions,
      compressionQuality: compressionQuality,
      dialogTitle: dialogTitle,
      initialDirectory: initialDirectory,

      onFileLoading: onFileLoading,
      type: type,
    );

    return results;
  }
}
