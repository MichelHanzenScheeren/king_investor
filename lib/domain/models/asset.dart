import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/shared/models/model.dart';
import 'package:king_investor/shared/notifications/contract.dart';

class Asset extends Model {
  final Company company; // Dados da empresa em questão
  final Category category; // ação, fii, stock, reit ("securityType")
  final Amount averagePrice; // preço médio do ativo
  final Score score; // "peso" do ativo na carteira
  final Quantity quantity; // Quantidade deste ativo na carteira (1, 2, 3...)
  String _walletForeignKey;

  Price _price; // Valores do ativo (preço atual, variação diária, volume de negociações)

  Asset(
    String objectId,
    DateTime createdAt,
    this.company,
    this.category,
    this.averagePrice,
    this.score,
    this.quantity,
    String walletForeignKey,
  ) : super(objectId, createdAt) {
    _walletForeignKey = walletForeignKey;
    _applyContracts();
    addNotifications(quantity);
    addNotifications(averagePrice);
    addNotifications(score);
  }

  String get walletForeignKey => _walletForeignKey;
  Price get price => _price;

  void setWalletForeignKey(String walletForeignKey) {
    _walletForeignKey = walletForeignKey;
    _applyContracts();
  }

  void registerPrices(Price price) {
    _price = price;
    addNotifications(_price);
  }

  void _applyContracts() {
    addNotifications(Contract()
        .requires()
        .isNotNull(company, 'Asset.company', 'A companhianão pode ser nula')
        .isNotNull(category, 'Asset.category', 'A categoria não pode ser nula')
        .isNotNullOrEmpty(_walletForeignKey, 'Asset.walletForeignKey', 'Valor inválido para relação com carteira'));
  }
}
