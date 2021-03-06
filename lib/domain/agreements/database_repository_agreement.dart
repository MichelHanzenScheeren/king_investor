import 'package:dartz/dartz.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class DatabaseRepositoryAgreement {
  Future<Either<Notification, Notification>> create(Object appObject);

  Future<Either<Notification, Notification>> update(Object appObject);

  Future<Either<Notification, Notification>> delete(Object appObject);

  Future<Either<Notification, List>> getAll(Type appClass, {List<Type> include});

  Future<Either<Notification, List>> filterByRelation(
    Type appClass,
    List<Type> relations,
    List<String> keys, {
    List<Type> include,
  });

  Future<Either<Notification, List>> filterByProperties(
    Type appClass,
    List<String> properties,
    List<String> values, {
    List<Type> include,
  });
}
