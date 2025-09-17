// lib/app/services/image_upload_service.dart
import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:image_picker/image_picker.dart';
import 'package:payoo/app/services/api_call_status.dart';
import 'package:payoo/app/services/base_client.dart';
import 'package:payoo/config/utils/constant.dart';
import 'package:payoo/config/utils/storage_manager.dart';
import '../data/models/image_file.dart';

class ImageUploadService extends GetxService {
  final ImagePicker _picker = ImagePicker();
  var uploadStatus = ApiCallStatus.holding.obs;
  var pickStatus = ApiCallStatus.holding.obs;
  var image = Rx<ImageFile?>(null);
  var pickedFile = Rx<File?>(null);
  var uploadError = ''.obs;

  // Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    pickStatus.value = ApiCallStatus.loading;
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        pickedFile.value = File(pickedImage.path);
        pickStatus.value = ApiCallStatus.success;
        return pickedFile.value;
      } else {
        pickStatus.value = ApiCallStatus.error;
        return null;
      }
    } catch (e) {
      pickStatus.value = ApiCallStatus.error;
      uploadError.value = 'Error picking image: $e';
      return null;
    }
  }

  // Pick image from camera
  Future<File?> pickImageFromCamera() async {
    pickStatus.value = ApiCallStatus.loading;
    try {
      final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        pickedFile.value = File(pickedImage.path);
        pickStatus.value = ApiCallStatus.success;
        return pickedFile.value;
      } else {
        pickStatus.value = ApiCallStatus.error;
        return null;
      }
    } catch (e) {
      pickStatus.value = ApiCallStatus.error;
      uploadError.value = 'Error taking photo: $e';
      return null;
    }
  }

  // Pick and upload in one step
  Future<bool> pickAndUploadImage(ImageSource source, String folder) async {
    File? file;
    if (source == ImageSource.gallery) {
      file = await pickImageFromGallery();
    } else {
      file = await pickImageFromCamera();
    }
   
    if (file != null) {
      return await createImage(file, folder);
    }
    return false;
  }

  Future<bool> createImage(File imageFile, String folder) async {
    uploadStatus.value = ApiCallStatus.loading;
    uploadError.value = '';
    
    final url = "${Constants.baseUrl}${Constants.UPLOAD}?folder=$folder";
    final token = StorageManager().read<String>('token');
    
    final formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(
        imageFile.path,
      ),
      'folder': folder,
    });

    bool success = false;
    
    await BaseClient.safeApiCall(
      url,
      RequestType.post,
      headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      data: formData,
      onSuccess: (response) {
        try {
          print('Raw response: ${response.data}');
          
          // Check if response has the expected structure
          if (response.data != null && response.data is Map<String, dynamic>) {
            final responseMap = response.data as Map<String, dynamic>;
            
            // Check if it's a successful response
            if (responseMap['status'] == 'success' && responseMap['data'] != null) {
              // Parse the data part of the response
              image.value = ImageFile.fromJson(responseMap['data']);
              uploadStatus.value = ApiCallStatus.success;
              success = true;
              print('Image upload success: $success');
            } else {
              uploadError.value = 'Server returned unsuccessful status: ${responseMap['status']}';
              uploadStatus.value = ApiCallStatus.error;
              print('Upload failed: ${uploadError.value}');
            }
          } else {
            uploadError.value = 'Received invalid response format from server.';
            uploadStatus.value = ApiCallStatus.error;
            print('Upload failed: Invalid response format');
          }
        } catch (e) {
          uploadError.value = 'Error parsing server response: $e';
          uploadStatus.value = ApiCallStatus.error;
          print('Upload failed: Parsing error - $e');
          print('Stack trace: ${StackTrace.current}');
        }
      },
      onError: (e) {
        uploadError.value = "Upload failed: ${e.toString()}";
        uploadStatus.value = ApiCallStatus.error;
        success = false;
        print('Upload failed: ${uploadError.value}');
      },
    );
    
    
    return success;
  }

  
  // Dispose resources when service is no longer needed
  @override
  void onClose() {
    // Clear reactive variables
    image.value = null;
    pickedFile.value = null;
    uploadStatus.value = ApiCallStatus.holding;
    pickStatus.value = ApiCallStatus.holding;
    uploadError.value = '';
    
    super.onClose();
  }

}