import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/services/api_service.dart';
import '../../../../domain/entities/nearby_farmer.dart';

abstract class NearbyFarmerRemoteDataSource {
  Future<List<NearbyFarmerData>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 3.0,
    String? search,
    bool? isOrganic,
    bool? isOpenNow,
  });
}

class NearbyFarmerRemoteDataSourceImpl implements NearbyFarmerRemoteDataSource {
  final ApiService apiService;

  NearbyFarmerRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<NearbyFarmerData>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 3.0,
    String? search,
    bool? isOrganic,
    bool? isOpenNow,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'lat': latitude,
        'lng': longitude,
        'radius': radius,
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (isOrganic == true) {
        queryParams['is_organic'] = true;
      }
      if (isOpenNow == true) {
        queryParams['is_open_now'] = true;
      }

      final response = await apiService.get(
        '/farmers/nearby',
        queryParameters: queryParams,
      );

      if (response.data['success'] == true || response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        return data.map((json) => NearbyFarmerData.fromJson(json)).toList();
      } else {
        throw ServerException(response.data['message'] ?? 'Failed to load nearby farmers');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
