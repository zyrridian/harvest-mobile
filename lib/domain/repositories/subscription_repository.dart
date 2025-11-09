import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/subscription.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<Subscription>>> getSubscriptions();
  Future<Either<Failure, SubscriptionSummary>> getSubscriptionSummary();
  Future<Either<Failure, Subscription>> pauseSubscription(
      String subscriptionId, Map<String, dynamic> data);
  Future<Either<Failure, Subscription>> resumeSubscription(
      String subscriptionId);
  Future<Either<Failure, Subscription>> skipDelivery(
      String subscriptionId, Map<String, dynamic> data);
  Future<Either<Failure, void>> cancelSubscription(
      String subscriptionId, Map<String, dynamic> data);
}
