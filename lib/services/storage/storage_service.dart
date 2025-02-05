import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageService with ChangeNotifier {
  final firebaseStorage = FirebaseStorage.instance;

  List<String> _imageUrls = []; //image stored

  bool _isLoading = false; //loading status

  bool _isUploading = false; //uploading status

  List<String> get imageUrls => _imageUrls;

  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  Future<void> fetchImages() async {
    _isLoading = true;

    final ListResult result =
        await firebaseStorage.ref('uploaded_images/').listAll();

    final urls = await Future.wait(result.items.map(
      (ref) => ref.getDownloadURL(),
    ));

    _imageUrls = urls;

    _isLoading = false;

    notifyListeners();
  }

  // delete Image

  Future<void> deleteImages(String imageUrl) async {
    try {
      _imageUrls.remove(imageUrl);
      final String path = extractPathFromUrl(imageUrl);
      await firebaseStorage.ref(path).delete();
    }

    // handle any errors
    catch (e) {
      print("error deleting image: $e");
    }

    notifyListeners(); //ui gets updated
  }

  String extractPathFromUrl(String url) {
    Uri uri = Uri.parse(url);

    String encodedPath = uri.pathSegments.last;

    return Uri.decodeComponent(encodedPath);
  }

  // upload image

  Future<void> uploadImage() async {
    _isUploading = true;
    notifyListeners();

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    try {
      String filePath = 'uploaded_images/${DateTime.now()}.png';

      await firebaseStorage.ref(filePath).putFile(file);

      String downlaodUrl = await firebaseStorage.ref(filePath).getDownloadURL();

      _imageUrls.add(downlaodUrl);
      notifyListeners();
    } catch (e) {
      print("Error uploading image $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
