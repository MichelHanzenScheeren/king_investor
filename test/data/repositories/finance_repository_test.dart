import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/finance_repository.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/price.dart';
import '../../mocks/app_request_service_simulated.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  RequestAgreement requestMock;
  FinanceRepository financeRepository;

  setUp(() {
    requestMock = AppRequestServiceSimulated();
    financeRepository = FinanceRepository(requestMock);
  });

  test('Should return Right with valid list of Company when mock search()', () async {
    final response = await financeRepository.search('PSSA3');
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null), isInstanceOf<List<Company>>());
    expect(response.getOrElse(null).length, 2);
  });

  test('Should return Right with valid list of Price when mock getPrices()', () async {
    final response = await financeRepository.getPrices(['ITUB3:BZ', 'PSSA3:BZ']);
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null), isInstanceOf<List<Price>>());
    expect(response.getOrElse(null).length, 2);
  });

  test('Should return Right with valid ExchangeRate when mock getExchangeRate', () async {
    final response = await financeRepository.getExchangeRate('USD', 'BRL');
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null), isInstanceOf<ExchangeRate>());
    expect(response.getOrElse(null).origin, 'USD');
    expect(response.getOrElse(null).destiny, 'BRL');
  });
}
