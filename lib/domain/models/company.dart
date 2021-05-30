import 'package:king_investor/shared/models/model.dart';
import 'package:king_investor/shared/notifications/contract.dart';

class Company extends Model {
  late String _symbol; // ITUB3, XPML11, AAPL, AMT
  late String _ticker; // pssa3:bz, xpml11:bz, aapl:us, eqix:us
  late String _currency; // BRL, USD
  late String _region; // Americas,
  late String _name; // Porto Seguro S.A., XP MALLS FDO INV IMOB FII
  late String _securityType; // Common Stock, Closed-End Fund, REIT
  late String _exchange; // B3, NASDAQ
  late String _country; // Brazil, United States

  Company(
    String? objectId,
    DateTime? createdAt,
    String? symbol,
    String? ticker,
    String? currency,
    String? region,
    String? name,
    String? securityType,
    String? exchange,
    String? country,
  ) : super(objectId, createdAt) {
    _symbol = symbol ?? 'NULL_COMPANY';
    _ticker = ticker ?? 'NULL_COMPANY';
    _currency = currency ?? '?';
    _region = region ?? 'Desconhecido';
    _name = name ?? 'Indisponível';
    _securityType = securityType ?? 'Common Stock';
    _exchange = _formatExchange(exchange);
    _country = _formatCountry(country);

    _applyContracts(symbol, ticker, currency);
  }

  String _formatExchange(String? exchange) {
    if (exchange == null || exchange == '') return 'Desconhecido';
    if (exchange.toLowerCase().contains('b3')) return 'B3';
    if (exchange.toLowerCase().contains('nasdaq')) return 'Nasdaq';
    return exchange;
  }

  String _formatCountry(String? country) {
    if (country == null || country == '') return 'Desconhecido';
    if (country.toLowerCase().contains('brazil')) return 'Brasil';
    if (country.toLowerCase().contains('united states')) return 'Estados Unidos';
    return country;
  }

  void _applyContracts(String? symbol, String? ticker, String? currency) {
    addNotifications(Contract()
        .requires()
        .isNotNullOrEmpty(symbol, 'Company.symbol', 'O símbolo de uma companhia não pode ser vazio')
        .isNotNullOrEmpty(ticker, 'Company.ticker', 'O ticker de uma companhia não pode ser vazio')
        .isNotNullOrEmpty(currency, 'Company.currency', 'A unidade monetária de uma companhia não pode ser vazia'));
  }

  String get symbol => _symbol;
  String get ticker => _ticker;
  String get currency => _currency;
  String get region => _region;
  String get name => _name;
  String get securityType => _securityType;
  String get exchange => _exchange;
  String get country => _country;
}
