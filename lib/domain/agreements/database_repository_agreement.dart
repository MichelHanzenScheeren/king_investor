import 'package:dartz/dartz.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class DatabaseRepositoryAgreement {
  Future<Either<Notification, String>> create(Object appObject);
  Future<Either<Notification, Notification>> update(Object appObject);
  Future<Either<Notification, Notification>> delete(Object appObject);
  Future<Either<Notification, List>> getAll(Type appClass);
}