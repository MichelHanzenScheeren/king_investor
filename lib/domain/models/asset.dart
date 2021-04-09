import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/domain/value_objects/quantity.dart';
import 'package:king_investor/domain/value_objects/score.dart';
import 'package:king_investor/shared/models/model.dart';

class Asset extends Model {
  String _symbol; // ITUB3, XPML11, AAPL, AMT
  String _ticker; // pssa3:bz, xpml11:bz, aapl:us, eqix:us
  String _currency; // BRL, USD
  String _region; // Americas,
  String _name; // Porto Seguro S.A., XP MALLS FDO INV IMOB FII
  String _categoryId; // ação, fii, stock, reit ("securityType")
  String _exchange; // B3, NASDAQ
  String _country; // Brazil, United States
  final Quantity quantity; // Quantidade deste ativo na carteira (1, 2, 3...)
  final Amount averagePrice; // preço médio do ativo
  final Score score; // "peso" do ativo na carteira
  Price _price; // Valores do ativo (preço atual, variação diária, volume de negociações)

  Asset(
    String objectId,
    DateTime createdAt,
    String symbol,
    String ticker,
    String currency,
    String region,
    String name,
    String categoryId,
    String exchange,
    String country,
    this.quantity,
    this.averagePrice,
    this.score,
  ) : super(objectId, createdAt) {
    _symbol = symbol ?? 'NULL_ASSET';
    _ticker = ticker ?? 'NULL_ASSET';
    _currency = currency ?? 'BRL';
    _region = region ?? 'Desconhecido';
    _name = name ?? 'Indisponível';
    _categoryId = categoryId ?? '';
    _exchange = _formatExchange(exchange);
    _country = _formatCountry(country);

    addNotifications(quantity);
    addNotifications(averagePrice);
    addNotifications(score);
  }

  String _formatExchange(String exchange) {
    if (exchange == null || exchange == '') return 'Desconhecido';
    if (exchange.toLowerCase().contains('b3')) return 'B3';
    if (exchange.toLowerCase().contains('nasdaq')) return 'Nasdaq';
    return exchange;
  }

  String _formatCountry(String exchange) {
    if (exchange == null || exchange == '') return 'Desconhecido';
    if (exchange.toLowerCase().contains('brazil')) return 'Brasil';
    if (exchange.toLowerCase().contains('united states')) return 'Estados Unidos';
    return exchange;
  }

  String get symbol => _symbol;
  String get ticker => _ticker;
  String get currency => _currency;
  String get region => _region;
  String get name => _name;
  String get categoryId => _categoryId;
  String get exchange => _exchange;
  String get country => _country;
  Price get price => _price;

  void registerPrices(Price price) {
    _price = price;
    addNotifications(_price);
  }
}
