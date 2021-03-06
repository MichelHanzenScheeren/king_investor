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
  Category _category; // ação, fii, stock, reit ("securityType")
  final Amount averagePrice; // preço médio do ativo
  final Score score; // "peso" do ativo na carteira
  final Quantity quantity; // Quantidade deste ativo na carteira (1, 2, 3...)
  String _walletForeignKey;
  Amount _sales; // Lucro/prejuízo com vendas
  Amount _incomes; // Rendimentos/provendos (dividendos, jcp)

  Asset(
    String objectId,
    DateTime createdAt,
    this.company,
    Category category,
    this.averagePrice,
    this.score,
    this.quantity,
    String walletForeignKey, {
    Amount sales,
    Amount incomes,
  }) : super(objectId, createdAt) {
    _category = category;
    _walletForeignKey = walletForeignKey;
    _sales = (sales == null ? Amount(0.0) : sales
      ..clearNotifications());
    _incomes = (incomes == null ? Amount(0.0) : incomes
      ..clearNotifications());
    _applyContracts(category, walletForeignKey);
    addNotifications(quantity);
    addNotifications(averagePrice);
    addNotifications(score);
    addNotifications(_sales);
    addNotifications(_incomes);
  }

  Category get category => _category;

  String get walletForeignKey => _walletForeignKey;

  Price get falsePrice => Price.fromDefaultValues(company?.ticker);

  Amount get sales => _sales;

  Amount get incomes => _incomes;

  void setCategory(Category category) {
    clearNotifications();
    _applyContracts(category, _walletForeignKey);
    if (isValid) _category = category;
  }

  void setWalletForeignKey(String walletForeignKey) {
    clearNotifications();
    _applyContracts(_category, walletForeignKey);
    if (isValid) _walletForeignKey = walletForeignKey;
  }

  void _applyContracts(Category category, String walletForeignKey) {
    addNotifications(Contract()
        .requires()
        .isNotNull(company, 'Asset.company', 'A companhianão pode ser nula')
        .isNotNull(category, 'Asset.category', 'A categoria não pode ser nula')
        .isNotNullOrEmpty(walletForeignKey, 'Asset.walletForeignKey', 'Valor inválido para relação com carteira'));
  }

  void registerBuy(Quantity quantity, Amount amount) {
    clearNotifications();
    if (quantity == null || !quantity.isValid)
      addNotification('Asset.registerBuy', 'Tentativa de operação com quantidade inválida');
    if (amount == null || !amount.isValid)
      addNotification('Asset.registerBuy', 'Tentativa de operação com preço inválido');
    if (isValid) {
      double totalValue = (this.quantity.value * this.averagePrice.value) + (quantity.value * amount.value);
      this.averagePrice.setValue(totalValue / (this.quantity.value + quantity.value));
      this.quantity.setValue(this.quantity.value + quantity.value);
    }
  }

  void registerSale(Quantity quantity, Amount amount) {
    clearNotifications();
    if (quantity == null || !quantity.isValid)
      addNotification('Asset.registerSale', 'Tentativa de operação com quantidade inválida');
    if (amount == null || !amount.isValid)
      addNotification('Asset.registerSale', 'Tentativa de operação com preço inválido');
    if (quantity.value > this.quantity.value)
      addNotification('Asset.registerSale', 'Não é possível vender mais itens do que a quantidade registrada');
    if (isValid) {
      double saleResult = (quantity.value * amount.value) - (quantity.value * this.averagePrice.value);
      _sales.setValue(_sales.value + saleResult);
      this.quantity.setValue(this.quantity.value - quantity.value);
    }
  }

  void registerIncome(Amount amount) {
    clearNotifications();
    if (amount == null || !amount.isValid || amount.value <= 0)
      addNotification('Asset.registerIncome', 'Tentativa de operação com preço inválido');
    if (isValid) _incomes.setValue(_incomes.value + amount.value);
  }
}
