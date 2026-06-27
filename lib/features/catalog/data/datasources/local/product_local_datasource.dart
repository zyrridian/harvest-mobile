import 'package:harvest_app/features/catalog/data/models/product/product_detail_model.dart';
import 'package:harvest_app/features/catalog/data/models/product/product_list_response_model.dart';

abstract class ProductLocalDataSource {
  Future<ProductDetailModel?> getCachedProductDetail(String slug);
  Future<void> cacheProductDetail(ProductDetailModel productToCache);
  Future<void> cacheProducts(ProductListResponseModel productsToCache);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  @override
  Future<ProductDetailModel?> getCachedProductDetail(String slug) async {
    // Basic local cache skeleton
    return null;
  }

  @override
  Future<void> cacheProducts(ProductListResponseModel productsToCache) async {
    // TODO: implement cacheProducts
  }

  @override
  Future<void> cacheProductDetail(ProductDetailModel productToCache) async {
    // Basic local cache skeleton
  }
}
