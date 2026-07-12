import 'package:dio/dio.dart';
import 'package:harvest_app/core/constants/app_constants.dart';
import 'package:harvest_app/core/error/exceptions.dart';
import 'package:harvest_app/features/users/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> addAddress(Map<String, dynamic> addressData);
  Future<void> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  );
  Future<void> deleteAddress(String addressId);
  Future<AddressModel> setPrimaryAddress(String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final Dio dio;

  AddressRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await dio.get(AppConstants.addressesEndpoint);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['addresses'];
        return data.map((json) => AddressModel.fromJson(json)).toList();
      } else {
        throw ServerException("Failed to get addresses");
      }
    } on DioException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> addAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await dio.post(
        AppConstants.addressesEndpoint,
        data: addressData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        throw ServerException("Failed to add address");
      }
    } on DioException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    try {
      final response = await dio.put(
        '${AppConstants.addressesEndpoint}/$addressId',
        data: addressData,
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException("Failed to update address");
      }
    } on DioException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      final response =
          await dio.delete('${AppConstants.addressesEndpoint}/$addressId');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException("Failed to delete address");
      }
    } on DioException catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AddressModel> setPrimaryAddress(String addressId) async {
    try {
      final response = await dio
          .patch('${AppConstants.addressesEndpoint}/$addressId/primary');
      if (response.statusCode == 200) {
        return AddressModel.fromJson(response.data['data']);
      } else {
        throw ServerException("Failed to set primary address");
      }
    } on DioException catch (e) {
      throw ServerException(e.toString());
    }
  }
}
