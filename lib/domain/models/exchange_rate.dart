import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/shared/models/model.dart';

class ExchangeRate extends Model {
  final String origin;
  final String destiny;
  final Amount lastPrice;

  ExchangeRate(
    String objectId,
    DateTime createdAt,
    this.origin,
    this.destiny,
    this.lastPrice,
  ) : super(objectId, createdAt) {
    addNotifications(lastPrice);
  }
}
