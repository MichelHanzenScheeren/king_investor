import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/shared/models/model.dart';

class Asset extends Model {
  final Quantity quantity; // Quantidade deste ativo na carteira (1, 2, 3...)
  final Amount averagePrice; // preço médio do ativo
  final Score score; // "peso" do ativo na carteira
  final Company company; // Dados da empresa em questão
  Price _price; // Valores do ativo (preço atual, variação diária, volume de negociações)

  Asset(
    String objectId,
    DateTime createdAt,
    this.company,
    this.averagePrice,
    this.score,
    this.quantity,
  ) : super(objectId, createdAt) {
    addNotifications(quantity);
    addNotifications(averagePrice);
    addNotifications(score);
  }

  Price get price => _price;

  void registerPrices(Price price) {
    _price = price;
    addNotifications(_price);
  }
}
