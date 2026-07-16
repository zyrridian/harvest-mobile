import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harvest_app/features/farmers/presentation/providers/farmer_dashboard_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:harvest_app/domain/entities/drop_point.dart';
import 'package:harvest_app/features/farmers/domain/usecases/get_drop_points_usecase.dart';
import 'package:harvest_app/features/farmers/domain/usecases/create_drop_point_usecase.dart';
import 'package:harvest_app/features/farmers/domain/usecases/update_drop_point_usecase.dart';
import 'package:harvest_app/features/farmers/domain/usecases/delete_drop_point_usecase.dart';

part 'drop_points_controller.g.dart';

@riverpod
GetDropPointsUseCase getDropPointsUseCase(Ref ref) {
  return GetDropPointsUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
CreateDropPointUseCase createDropPointUseCase(Ref ref) {
  return CreateDropPointUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
UpdateDropPointUseCase updateDropPointUseCase(Ref ref) {
  return UpdateDropPointUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
DeleteDropPointUseCase deleteDropPointUseCase(Ref ref) {
  return DeleteDropPointUseCase(ref.watch(producerRepositoryProvider));
}

@riverpod
class DropPointsController extends _$DropPointsController {
  @override
  AsyncValue<List<DropPoint>> build() {
    fetchDropPoints();
    return const AsyncValue.loading();
  }

  Future<void> fetchDropPoints() async {
    state = const AsyncValue.loading();
    final result = await ref.read(getDropPointsUseCaseProvider).call();
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (dropPoints) {
        state = AsyncValue.data(dropPoints);
      },
    );
  }

  Future<bool> createDropPoint(DropPoint dropPoint) async {
    final result = await ref.read(createDropPointUseCaseProvider).call(dropPoint);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        fetchDropPoints();
        return true;
      },
    );
  }

  Future<bool> updateDropPoint(String id, DropPoint dropPoint) async {
    final result = await ref.read(updateDropPointUseCaseProvider).call(id, dropPoint);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        fetchDropPoints();
        return true;
      },
    );
  }

  Future<bool> deleteDropPoint(String id) async {
    final result = await ref.read(deleteDropPointUseCaseProvider).call(id);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return false;
      },
      (_) {
        fetchDropPoints();
        return true;
      },
    );
  }
}
