import 'package:dartz/dartz.dart';
import 'package:king_investor/shared/notifications/notification.dart';

abstract class ParseAgreement {
  Future<Either<Notification, String>> create(String table, Map map);
  Future<Either<Notification, Notification>> edit(String table, Map map);
  Future<Either<Notification, Notification>> delete(String table, String objectId);
  Future<Either<Notification, List>> getAll(String table, List<String> objectsToInclude);
}
