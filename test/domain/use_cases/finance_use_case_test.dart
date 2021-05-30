import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/finance_repository.dart';
import 'package:king_investor/domain/agreements/finance_agreement.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/use_cases/finance_use_case.dart';

import '../../mocks/app_request_service_simulated.dart';

main() {
  late AppData appData;
  late FinanceUseCase finance;
  late Company company1;

  setUpAll(() {
    RequestAgreement requestService = AppRequestServiceSimulated();
    FinanceAgreement financeRepository = FinanceRepository(requestService);
    appData = AppData();
    finance = FinanceUseCase(financeRepository, appData);
    company1 = Company('company1_id', null, 'ITUB3', 'ITUB3:BZ', 'BRL', 'A', 'Itaú', 'Ação', 'B3', 'Brasil');
  });

  group('Tests about FinanceUseCase.search', () {
    test('Should return Right([]) when send null to search', () async {
      final response = await finance.search(null);
      expect(response.isRight(), isTrue);
      expect(response.fold((l) => null, (r) => r), <Company>[]);
    });
    test('Should return Right(List) when send empty string to search and has localSearch', () async {
      appData.registerLocalSearch([company1]);
      final response = await finance.search('');
      expect(response.isRight(), isTrue);
      expect(response.fold((l) => null, (list) => list), <Company?>[company1]);
    });
    test('Should return Right(List) when send valid search', () async {
      appData.registerLocalSearch([company1]);
      final response = await finance.search('teste');
      expect(response.isRight(), isTrue);
      expect(response.fold((l) => null, (list) => list.length), 2);
      expect(appData.localSearch.length, 2);
    });
  });

  group('Tests about FinanceUseCase.getPrices', () {
    test('Should return Left when send null to getPrices', () async {
      final response = await finance.getPrices(null);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'A lista de ativos não pode ser vazia');
    });
    test('Should return Left when send empty list to getPrices', () async {
      final response = await finance.getPrices([]);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'A lista de ativos não pode ser vazia');
    });
    test('Should return Right when send valid list of tickets to getPrices', () async {
      final response = await finance.getPrices(['PSSA3:BZ', 'XPML11:BZ']);
      expect(response.isRight(), isTrue);
      expect(response.fold((l) => null, (list) => list.length), 2);
    });
    test('Should conatin data in _prices after success getPrices', () async {
      expect(appData.getPrice('PSSA3:BZ'), isNotNull);
      expect(appData.getPrice('XPML11:BZ'), isNotNull);
    });
    test('Should return List<Price> when send valid list of tickets to getLocalPrices', () async {
      final response = finance.getLocalPrices(['PSSA3:BZ', 'ITUB3:BZ']);
      expect(response.length, 1);
    });
  });

  group('Tests about FinanceUseCase.getExchangeRate', () {
    test('Should return Left when send null to origin parameter of getExchangeRate', () async {
      final response = await finance.getExchangeRate(null, 'BRL');
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Valor inválido para parâmetro "origem"');
    });
    test('Should return Left when send empty string to origin parameter of getExchangeRate', () async {
      final response = await finance.getExchangeRate('', 'BRL');
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Valor inválido para parâmetro "origem"');
    });
    test('Should return Left when send null to destiny parameter of getExchangeRate', () async {
      final response = await finance.getExchangeRate('USD', null);
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Valor inválido para parâmetro "destino"');
    });
    test('Should return Left when send empty string to destiny parameter of getExchangeRate', () async {
      final response = await finance.getExchangeRate('USD', '');
      expect(response.isLeft(), isTrue);
      expect(response.fold((l) => l.message, (r) => null), 'Valor inválido para parâmetro "destino"');
    });
    test('Should return Right(ExchangeRate) when send valid parameters', () async {
      final response = await finance.getExchangeRate('USD', 'BRL');
      expect(response.isRight(), isTrue);
    });
    test('Should has local saves after success request', () async {
      expect(appData.containExchangeRates('USD', 'BRL'), isTrue);
    });
  });
}
