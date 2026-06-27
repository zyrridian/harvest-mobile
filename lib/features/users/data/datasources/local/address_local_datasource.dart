import '../../../../../data/models/address_model.dart';

/// Simulates API responses with local JSON data
class AddressLocalDataSource {
  // Simulated in-memory storage
  final List<AddressModel> _addresses = [];
  int _idCounter = 1;

  AddressLocalDataSource() {
    // Initialize with some mock data
    _addresses.addAll([
      AddressModel(
        addressId: 'addr_${_idCounter++}',
        label: 'Home',
        recipientName: 'John Doe',
        phone: '+62 812-3456-7890',
        fullAddress: 'Jl. Merdeka No. 123',
        province: 'DKI Jakarta',
        provinceId: 31,
        city: 'Jakarta Pusat',
        cityId: 3171,
        district: 'Menteng',
        districtId: 317101,
        subdistrict: 'Menteng',
        postalCode: '10310',
        latitude: -6.1944,
        longitude: 106.8229,
        notes: 'Red gate, near the corner store',
        isPrimary: true,
        isVerified: true,
        createdAt:
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        updatedAt:
            DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      ),
      AddressModel(
        addressId: 'addr_${_idCounter++}',
        label: 'Office',
        recipientName: 'John Doe',
        phone: '+62 812-3456-7890',
        fullAddress: 'Jl. Sudirman No. 456, Lt. 5',
        province: 'DKI Jakarta',
        provinceId: 31,
        city: 'Jakarta Selatan',
        cityId: 3174,
        district: 'Setiabudi',
        districtId: 317401,
        subdistrict: 'Kuningan',
        postalCode: '12920',
        latitude: -6.2088,
        longitude: 106.8456,
        notes: 'Office building, 5th floor',
        isPrimary: false,
        isVerified: true,
        createdAt:
            DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
        updatedAt:
            DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
      ),
    ]);
  }

  /// Simulates GET /api/v1/addresses
  Future<Map<String, dynamic>> getAddresses() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'success': true,
      'message': 'Addresses retrieved successfully',
      'data': {
        'addresses': _addresses.map((e) => e.toJson()).toList(),
        'total': _addresses.length,
      },
    };
  }

  /// Simulates POST /api/v1/addresses
  Future<Map<String, dynamic>> addAddress(Map<String, dynamic> data) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final newAddress = AddressModel(
      addressId: 'addr_${_idCounter++}',
      label: data['label'],
      recipientName: data['recipientName'],
      phone: data['phone'],
      fullAddress: data['fullAddress'],
      province: data['province'],
      provinceId: data['provinceId'],
      city: data['city'],
      cityId: data['cityId'],
      district: data['district'],
      districtId: data['districtId'],
      subdistrict: data['subdistrict'],
      postalCode: data['postalCode'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      notes: data['notes'],
      isPrimary: _addresses.isEmpty, // First address is primary
      isVerified: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    _addresses.add(newAddress);

    return {
      'success': true,
      'message': 'Address added successfully',
      'data': newAddress.toJson(),
    };
  }

  /// Simulates PUT /api/v1/addresses/:id
  Future<Map<String, dynamic>> updateAddress(
      String addressId, Map<String, dynamic> data) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final index = _addresses.indexWhere((a) => a.addressId == addressId);
    if (index == -1) {
      throw Exception('Address not found');
    }

    final updatedAddress = AddressModel(
      addressId: addressId,
      label: data['label'],
      recipientName: data['recipientName'],
      phone: data['phone'],
      fullAddress: data['fullAddress'],
      province: data['province'],
      provinceId: data['provinceId'],
      city: data['city'],
      cityId: data['cityId'],
      district: data['district'],
      districtId: data['districtId'],
      subdistrict: data['subdistrict'],
      postalCode: data['postalCode'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      notes: data['notes'],
      isPrimary: _addresses[index].isPrimary,
      isVerified: _addresses[index].isVerified,
      createdAt: _addresses[index].createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    _addresses[index] = updatedAddress;

    return {
      'success': true,
      'message': 'Address updated successfully',
      'data': updatedAddress.toJson(),
    };
  }

  /// Simulates DELETE /api/v1/addresses/:id
  Future<Map<String, dynamic>> deleteAddress(String addressId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _addresses.indexWhere((a) => a.addressId == addressId);
    if (index == -1) {
      throw Exception('Address not found');
    }

    // Don't allow deleting primary address
    if (_addresses[index].isPrimary) {
      throw Exception('Cannot delete primary address');
    }

    _addresses.removeAt(index);

    return {
      'success': true,
      'message': 'Address deleted successfully',
    };
  }

  /// Simulates PUT /api/v1/addresses/:id/set-primary
  Future<Map<String, dynamic>> setPrimaryAddress(String addressId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final index = _addresses.indexWhere((a) => a.addressId == addressId);
    if (index == -1) {
      throw Exception('Address not found');
    }

    // Remove primary from all addresses
    for (int i = 0; i < _addresses.length; i++) {
      _addresses[i] = AddressModel(
        addressId: _addresses[i].addressId,
        label: _addresses[i].label,
        recipientName: _addresses[i].recipientName,
        phone: _addresses[i].phone,
        fullAddress: _addresses[i].fullAddress,
        province: _addresses[i].province,
        provinceId: _addresses[i].provinceId,
        city: _addresses[i].city,
        cityId: _addresses[i].cityId,
        district: _addresses[i].district,
        districtId: _addresses[i].districtId,
        subdistrict: _addresses[i].subdistrict,
        postalCode: _addresses[i].postalCode,
        latitude: _addresses[i].latitude,
        longitude: _addresses[i].longitude,
        notes: _addresses[i].notes,
        isPrimary: false,
        isVerified: _addresses[i].isVerified,
        createdAt: _addresses[i].createdAt,
        updatedAt: _addresses[i].updatedAt,
      );
    }

    // Set new primary
    _addresses[index] = AddressModel(
      addressId: _addresses[index].addressId,
      label: _addresses[index].label,
      recipientName: _addresses[index].recipientName,
      phone: _addresses[index].phone,
      fullAddress: _addresses[index].fullAddress,
      province: _addresses[index].province,
      provinceId: _addresses[index].provinceId,
      city: _addresses[index].city,
      cityId: _addresses[index].cityId,
      district: _addresses[index].district,
      districtId: _addresses[index].districtId,
      subdistrict: _addresses[index].subdistrict,
      postalCode: _addresses[index].postalCode,
      latitude: _addresses[index].latitude,
      longitude: _addresses[index].longitude,
      notes: _addresses[index].notes,
      isPrimary: true,
      isVerified: _addresses[index].isVerified,
      createdAt: _addresses[index].createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    return {
      'success': true,
      'message': 'Primary address updated successfully',
      'data': _addresses[index].toJson(),
    };
  }
}
