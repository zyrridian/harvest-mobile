import 'package:dio/dio.dart';
import '../../models/farmer_model.dart';

abstract class FarmerRemoteDataSource {
  Future<List<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  });

  Future<FarmerModel> getFarmerById(String id);

  Future<List<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  });
}

class FarmerRemoteDataSourceImpl implements FarmerRemoteDataSource {
  final Dio dio;

  FarmerRemoteDataSourceImpl({required this.dio});

  // Mock data - simulating API response
  final List<Map<String, dynamic>> _mockFarmers = [
    {
      "id": "1",
      "name": "Green Valley Organic Farm",
      "description":
          "Certified organic farm specializing in fresh vegetables and seasonal fruits. We practice sustainable farming methods and deliver farm-fresh produce daily.",
      "profile_image":
          "https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800",
      "latitude": 40.7128,
      "longitude": -74.0060,
      "address": "123 Farm Road",
      "city": "Springfield",
      "state": "California",
      "rating": 4.8,
      "total_reviews": 156,
      "total_products": 45,
      "specialties": ["Vegetables", "Fruits", "Herbs"],
      "is_verified": true,
      "has_map_feature": true,
      "phone_number": "+1-555-0101",
      "email": "contact@greenvalley.farm",
      "joined_date": "2023-01-15T00:00:00Z",
      "is_online": true,
      "distance": 1.2
    },
    {
      "id": "2",
      "name": "Sunrise Poultry Farm",
      "description":
          "Family-owned poultry farm providing fresh eggs and free-range chicken. Our birds are raised humanely with natural feed and plenty of outdoor space.",
      "profile_image":
          "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=800",
      "latitude": 40.7589,
      "longitude": -73.9851,
      "address": "456 Meadow Lane",
      "city": "Riverside",
      "state": "California",
      "rating": 4.9,
      "total_reviews": 203,
      "total_products": 12,
      "specialties": ["Eggs", "Livestock"],
      "is_verified": true,
      "has_map_feature": true,
      "phone_number": "+1-555-0102",
      "email": "info@sunrisepoultry.com",
      "joined_date": "2022-08-20T00:00:00Z",
      "is_online": true,
      "distance": 2.5
    },
    {
      "id": "3",
      "name": "Ocean Fresh Fishery",
      "description":
          "Sustainable fishery offering fresh-caught seafood daily. We work directly with local fishermen to bring you the freshest catch of the day.",
      "profile_image":
          "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1535231540604-72e8fbaf8cdb?w=800",
      "latitude": 40.6782,
      "longitude": -73.9442,
      "address": "789 Harbor Drive",
      "city": "Oceanside",
      "state": "California",
      "rating": 4.7,
      "total_reviews": 89,
      "total_products": 28,
      "specialties": ["Fish"],
      "is_verified": true,
      "has_map_feature": true,
      "phone_number": "+1-555-0103",
      "email": "sales@oceanfresh.fish",
      "joined_date": "2023-03-10T00:00:00Z",
      "is_online": false,
      "distance": 3.1
    },
    {
      "id": "4",
      "name": "Mountain View Dairy",
      "description":
          "Traditional dairy farm producing fresh milk, cheese, and yogurt. Our cows graze on mountain pastures for the highest quality dairy products.",
      "profile_image":
          "https://images.unsplash.com/photo-1628088062854-d1870b4553da?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1616951849649-74dd2dd7e662?w=800",
      "latitude": 40.8206,
      "longitude": -74.1524,
      "address": "321 Highland Road",
      "city": "Mountainview",
      "state": "California",
      "rating": 4.6,
      "total_reviews": 124,
      "total_products": 18,
      "specialties": ["Dairy"],
      "is_verified": true,
      "has_map_feature": false,
      "phone_number": "+1-555-0104",
      "email": "hello@mountaindairy.com",
      "joined_date": "2022-11-05T00:00:00Z",
      "is_online": true,
      "distance": 4.3
    },
    {
      "id": "5",
      "name": "Heritage Grain Co-op",
      "description":
          "Cooperative of local farmers growing heritage grains and ancient wheat varieties. We mill our own flour and offer fresh bread weekly.",
      "profile_image":
          "https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1558418047-6f82f8073be8?w=800",
      "latitude": 40.6413,
      "longitude": -74.0787,
      "address": "654 Wheat Field Avenue",
      "city": "Grainville",
      "state": "California",
      "rating": 4.5,
      "total_reviews": 67,
      "total_products": 22,
      "specialties": ["Grains"],
      "is_verified": false,
      "has_map_feature": true,
      "phone_number": "+1-555-0105",
      "email": "contact@heritagegrain.coop",
      "joined_date": "2023-05-22T00:00:00Z",
      "is_online": true,
      "distance": 5.7
    },
    {
      "id": "6",
      "name": "Berry Fields Farm",
      "description":
          "U-pick berry farm with strawberries, blueberries, and raspberries. Visit us for fresh-picked berries or buy pre-picked from our farm stand.",
      "profile_image":
          "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1488459716781-31db52582fe9?w=800",
      "latitude": 40.7489,
      "longitude": -73.9680,
      "address": "987 Berry Lane",
      "city": "Fruitdale",
      "state": "California",
      "rating": 4.9,
      "total_reviews": 234,
      "total_products": 15,
      "specialties": ["Fruits"],
      "is_verified": true,
      "has_map_feature": true,
      "phone_number": "+1-555-0106",
      "email": "info@berryfields.farm",
      "joined_date": "2022-04-12T00:00:00Z",
      "is_online": true,
      "distance": 1.8
    },
    {
      "id": "7",
      "name": "Herb Garden Collective",
      "description":
          "Artisan herb garden growing culinary and medicinal herbs. We offer fresh-cut herbs, dried herb blends, and herb-infused products.",
      "profile_image":
          "https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1519336555923-59661f41bb0b?w=800",
      "latitude": 40.6892,
      "longitude": -74.0445,
      "address": "147 Garden Path",
      "city": "Herbville",
      "state": "California",
      "rating": 4.7,
      "total_reviews": 98,
      "total_products": 56,
      "specialties": ["Herbs", "Vegetables"],
      "is_verified": true,
      "has_map_feature": true,
      "phone_number": "+1-555-0107",
      "email": "herbs@gardencollective.com",
      "joined_date": "2023-02-28T00:00:00Z",
      "is_online": false,
      "distance": 2.9
    },
    {
      "id": "8",
      "name": "Maple Ridge Ranch",
      "description":
          "Grass-fed beef and lamb ranch with sustainable grazing practices. We process our own meat and offer farm tours by appointment.",
      "profile_image":
          "https://images.unsplash.com/photo-1560493676-04071c5f467b?w=400",
      "cover_image":
          "https://images.unsplash.com/photo-1500595046743-cd271d694d30?w=800",
      "latitude": 40.7308,
      "longitude": -74.1724,
      "address": "258 Ranch Road",
      "city": "Ranchlands",
      "state": "California",
      "rating": 4.8,
      "total_reviews": 145,
      "total_products": 24,
      "specialties": ["Livestock"],
      "is_verified": true,
      "has_map_feature": false,
      "phone_number": "+1-555-0108",
      "email": "contact@mapleridge.ranch",
      "joined_date": "2022-09-15T00:00:00Z",
      "is_online": true,
      "distance": 6.2
    }
  ];

  @override
  Future<List<FarmerModel>> getFarmers({
    String? query,
    List<String>? specialties,
    bool? hasMapFeature,
    double? maxDistance,
    double? minRating,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate API call
    // In production: final response = await dio.get('/api/farmers', queryParameters: {...});

    var farmers =
        _mockFarmers.map((json) => FarmerModel.fromJson(json)).toList();

    // Apply filters
    if (query != null && query.isNotEmpty) {
      farmers = farmers.where((farmer) {
        return farmer.name.toLowerCase().contains(query.toLowerCase()) ||
            farmer.description.toLowerCase().contains(query.toLowerCase()) ||
            farmer.city.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    if (specialties != null && specialties.isNotEmpty) {
      farmers = farmers.where((farmer) {
        return farmer.specialties.any((s) => specialties.contains(s));
      }).toList();
    }

    if (hasMapFeature != null) {
      farmers = farmers
          .where((farmer) => farmer.hasMapFeature == hasMapFeature)
          .toList();
    }

    if (maxDistance != null) {
      farmers = farmers
          .where((farmer) => (farmer.distance ?? 0) <= maxDistance)
          .toList();
    }

    if (minRating != null) {
      farmers = farmers.where((farmer) => farmer.rating >= minRating).toList();
    }

    return farmers;
  }

  @override
  Future<FarmerModel> getFarmerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final farmerJson = _mockFarmers.firstWhere(
      (f) => f['id'] == id,
      orElse: () => throw Exception('Farmer not found'),
    );

    return FarmerModel.fromJson(farmerJson);
  }

  @override
  Future<List<FarmerModel>> getNearbyFarmers({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // In production, calculate actual distance or let backend handle it
    var farmers =
        _mockFarmers.map((json) => FarmerModel.fromJson(json)).toList();

    // Filter by radius
    farmers =
        farmers.where((farmer) => (farmer.distance ?? 0) <= radius).toList();

    // Sort by distance
    farmers.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));

    return farmers;
  }
}
