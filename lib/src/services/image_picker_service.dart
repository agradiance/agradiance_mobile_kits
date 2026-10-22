import 'package:agradiance_mobile_kits/src/services/app_navigator_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePickerService _instance = ImagePickerService._internal(
    ImagePicker(),
  );
  final ImagePicker _imagePicker;

  ImagePicker get imagePicker {
    return _instance._imagePicker;
  }

  ImagePickerService._internal(this._imagePicker);

  factory ImagePickerService() {
    return _instance;
  }

  Future<PlatformFile?> pickImageFile({
    int? compressionQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    ImageSource? imageSource = ImageSource.gallery,
    bool requestFullMetadata = true,
    String title = "Pick Image",
  }) async {
    final context =
        AppMainNavigationService.instance.navigatorKey.currentState?.context;
    if (context == null) {
      return null;
    }
    final source =
        imageSource ??
        await showDialog<ImageSource>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 15,
                children: [
                  Text(title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pop(context, ImageSource.camera),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: Main,
                            children: [
                              Icon(Icons.camera_enhance_outlined, size: 60),
                              Text("Camera"),
                            ],
                            //
                          ),
                        ),
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pop(context, ImageSource.gallery),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: Main,
                            children: [
                              Icon(Icons.file_open_outlined, size: 60),
                              Text("Gallery"),
                            ],
                            //
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );

    if (source == null) {
      return null;
    }

    return await FilePicker.pickFile(type: .image);
  }

  Future<XFile?> pickImage({
    ImageSource source = ImageSource.camera,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    return _imagePicker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice: preferredCameraDevice,
      requestFullMetadata: requestFullMetadata,
    );
  }
}
