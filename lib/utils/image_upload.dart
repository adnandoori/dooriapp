import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ImageUpload {
  final ImagePicker _imagePicker = ImagePicker();

  Future<Uint8List?> pickImage(ImageSource source) async {
    final XFile? file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    print('No image selected');
    return null;
  }
}
