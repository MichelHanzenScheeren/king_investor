import 'dart:collection';
import 'package:dartz/dartz.dart';
import 'package:king_investor/domain/agreements/finance_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/shared/notifications/notification.dart';

class FinanceUseCase {
  FinanceAgreement _finance;
  AppData _appData;

  FinanceUseCase(FinanceAgreement finance, AppData appData) {
    _finance = finance;
    _appData = appData;
  }

  Future<Either<Notification, List<Company>>> search(String query) async {
    if (query == null || query.isEmpty) return Right(_appData.localSearch);
    final response = await _finance.search(query);
    return response.fold((notification) => Left(notification), (searchResult) {
      _appData.registerLocalSearch(searchResult);
      return Right(_appData.localSearch);
    });
  }

  Future<Either<Notification, List<Price>>> getPrices(List<String> tickers) async {
    if (tickers == null || tickers.isEmpty)
      return Left(Notification('FinanceUseCase.getPrices', 'A lista de ativos não pode ser vazia'));
    List<Price> localPrices = getLocalPrices(tickers);
    if (tickers.isEmpty) return Right(_saveAndReturnPrices(localPrices, []));

    final result = await _finance.getPrices(tickers);
    return result.fold(
      (notification) => Left(notification),
      (apiPrices) => Right(_saveAndReturnPrices(localPrices, apiPrices)),
    );
  }

  Future<Either<Notification, ExchangeRate>> getExchangeRate(String origin, String destiny) async {
    if (origin == null || origin.isEmpty)
      return Left(Notification('FinanceUseCase.getExchangeRate', 'Valor inválido para parâmetro "origem"'));
    if (destiny == null || destiny.isEmpty)
      return Left(Notification('FinanceUseCase.getExchangeRate', 'Valor inválido para parâmetro "destino"'));
    if (_appData.containsExchangeRates(origin, destiny)) return Right(_appData.getCopyOfExchangeRate(origin, destiny));

    final response = await _finance.getExchangeRate(origin, destiny);
    return response.fold((notification) => Left(notification), (exchangeRate) {
      _appData.registerExchangeRate(origin, destiny, exchangeRate);
      return Right(_appData.getCopyOfExchangeRate(origin, destiny));
    });
  }

  List<Price> getLocalPrices(List<String> tickers) {
    List<Price> localPrices = <Price>[];
    List<String> toRemove = <String>[];
    for (int i = 0; i < tickers.length; i++) {
      if (_appData.containsPrice(tickers[i])) {
        localPrices.add(_appData.getPrice(tickers[i]));
        toRemove.add(tickers[i]);
      }
    }
    toRemove.forEach((element) => tickers.remove(element));
    return localPrices;
  }

  List<Price> _saveAndReturnPrices(List<Price> localPrices, List<Price> apiPrices) {
    apiPrices.forEach((price) {
      if (price != null && price.ticker != null && price.ticker.isNotEmpty) {
        _appData.registerPrice(price.ticker, price);
        localPrices.add(price);
      }
    });
    return UnmodifiableListView<Price>(localPrices);
  }
}
