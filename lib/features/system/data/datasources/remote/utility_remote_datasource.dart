import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../data/models/uploaded_file_model.dart';
import '../../../../../data/models/share_content_model.dart';

abstract class UtilityRemoteDataSource {
  Future<UploadedFileModel> uploadFile(File file);
  
  Future<ShareContentModel> share(
    String type,
    String id,
    String? platform,
  );
}

class UtilityRemoteDataSourceImpl implements UtilityRemoteDataSource {
  final Dio dio;

  UtilityRemoteDataSourceImpl({required this.dio});

  @override
  Future<UploadedFileModel> uploadFile(File file) async {
    try {
      final fileName = file.path.split('/').last;
      
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        '/system/utils/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return UploadedFileModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to upload file');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error occurred');
    } catch (e) {
      throw Exception('An error occurred while uploading');
    }
  }

  @override
  Future<ShareContentModel> share(
    String type,
    String id,
    String? platform,
  ) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock success response
    final Map<String, dynamic> mockResponse = {
      "status": "success",
      "data": {
        "share_url": "https://farmmarket.com/$type/$id",
        "short_url": "https://fmkt.co/abc123",
        "deep_link": "farmmarket://$type/$id",
        "share_text": "Check out this amazing $type on FarmMarket!",
        "platform_specific": {
          "whatsapp":
              "https://wa.me/?text=Check%20out%20this%20$type%20https://fmkt.co/abc123",
          "facebook":
              "https://www.facebook.com/sharer/sharer.php?u=https://fmkt.co/abc123",
          "twitter":
              "https://twitter.com/intent/tweet?url=https://fmkt.co/abc123&text=Check%20out%20this%20$type",
          "instagram": "Copy link to share on Instagram Stories"
        },
        "qr_code": "https://cdn.farmmarket.com/qr/abc123.png",
        "generated_at": DateTime.now().toIso8601String()
      }
    };

    final data = mockResponse['data'] as Map<String, dynamic>;
    return ShareContentModel.fromJson(data);
  }
}
