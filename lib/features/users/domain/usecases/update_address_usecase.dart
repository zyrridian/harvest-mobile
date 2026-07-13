import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/address_repository.dart';

class UpdateAddressUseCase {
  final AddressRepository repository;

  UpdateAddressUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String addressId,
    required String label,
    required String recipientName,
    required String phone,
    required String fullAddress,
    required String province,
    required int provinceId,
    required String city,
    required int cityId,
    required String district,
    required int districtId,
    String? subdistrict,
    required String postalCode,
    required double latitude,
    required double longitude,
    String? notes,
    bool isPrimary = false,
  }) async {
    return await repository.updateAddress(
      addressId: addressId,
      label: label,
      recipientName: recipientName,
      phone: phone,
      fullAddress: fullAddress,
      province: province,
      provinceId: provinceId,
      city: city,
      cityId: cityId,
      district: district,
      districtId: districtId,
      subdistrict: subdistrict,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
      isPrimary: isPrimary,
    );
  }
}
