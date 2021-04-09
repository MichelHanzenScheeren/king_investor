import 'package:king_investor/domain/value_objects/amount%20.dart';
import 'package:king_investor/shared/models/model.dart';
import 'package:king_investor/shared/notifications/contract.dart';

class Price extends Model {
  String _ticker;
  int _lastUpdate;
  final Amount volume;
  final Amount variation;
  final Amount monthVariation;
  final Amount yearVariation;
  final Amount lastPrice;
  final Amount dayHigh;
  final Amount dayLow;
  final Amount yearHigh;
  final Amount yearLow;

  Price(
    String objectId,
    DateTime createdAt,
    String ticker,
    int lastUpdate,
    this.volume,
    this.variation,
    this.monthVariation,
    this.yearVariation,
    this.lastPrice,
    this.dayHigh,
    this.dayLow,
    this.yearHigh,
    this.yearLow,
  ) : super(objectId, createdAt) {
    _ticker = ticker ?? '';
    _lastUpdate = lastUpdate ?? 0;
    _applyContracts(ticker, lastUpdate);
  }

  String get ticker => _ticker;
  DateTime get lastUpdate => DateTime.fromMillisecondsSinceEpoch(_lastUpdate * 1000);

  void _applyContracts(String ticker, int lastUpdate) {
    addNotifications(
      Contract()
          .requires()
          .isNotNullOrEmpty(ticker, 'Price.ticker', 'O ticker não pode ser nulo ou vazio')
          .isNotNull(lastUpdate, 'Price.lastUpdate', 'Data de atualização inválida'),
    );
    addNotifications(volume);
    addNotifications(variation);
    addNotifications(monthVariation);
    addNotifications(yearVariation);
    addNotifications(dayHigh);
    addNotifications(dayLow);
    addNotifications(yearHigh);
    addNotifications(yearLow);
  }
}
