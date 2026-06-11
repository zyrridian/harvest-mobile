import 'package:harvest_app/data/models/product_detail_model.dart';

abstract class ProductLocalDataSource {
  Future<ProductDetailModel?> getCachedProductDetail(String slug);
  Future<void> cacheProductDetail(ProductDetailModel productToCache);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<ProductDetailModel?> getCachedProductDetail(String slug) async {
    // Basic local cache skeleton
    return null;
  }

  @override
  Future<void> cacheProductDetail(ProductDetailModel productToCache) async {
    // Basic local cache skeleton
  }
}
