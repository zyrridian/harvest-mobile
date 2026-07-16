import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest_app/features/farmers/data/models/route_plan_model.dart';

abstract class RoutePlanLocalDataSource {
  Future<List<RoutePlanModel>> getRoutePlans(String date);
  Future<void> saveRoutePlans(String date, List<RoutePlanModel> routes);
  Future<RoutePlanModel?> getRoutePlanDetail(String routeId);
  Future<void> saveRoutePlanDetail(RoutePlanModel route);
}

class RoutePlanLocalDataSourceImpl implements RoutePlanLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  RoutePlanLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  String _getRoutePlansKey(String date) => 'route_plans_$date';
  String _getRouteDetailKey(String routeId) => 'route_detail_$routeId';

  @override
  Future<List<RoutePlanModel>> getRoutePlans(String date) async {
    final key = _getRoutePlansKey(date);
    final jsonString = sharedPreferences.getString(key);
    
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => RoutePlanModel.fromJson(json)).toList();
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> saveRoutePlans(String date, List<RoutePlanModel> routes) async {
    final key = _getRoutePlansKey(date);
    final jsonList = routes.map((route) => route.toJson()).toList();
    await sharedPreferences.setString(key, json.encode(jsonList));
  }

  @override
  Future<RoutePlanModel?> getRoutePlanDetail(String routeId) async {
    final key = _getRouteDetailKey(routeId);
    final jsonString = sharedPreferences.getString(key);
    
    if (jsonString != null) {
      try {
        final jsonMap = json.decode(jsonString);
        return RoutePlanModel.fromJson(jsonMap);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveRoutePlanDetail(RoutePlanModel route) async {
    final key = _getRouteDetailKey(route.routeId);
    await sharedPreferences.setString(key, json.encode(route.toJson()));
  }
}
