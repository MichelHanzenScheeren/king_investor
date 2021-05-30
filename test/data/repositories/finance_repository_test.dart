import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/finance_repository.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/domain/models/company.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/price.dart';
import 'package:king_investor/domain/value_objects/amount%20.dart';
import '../../mocks/app_request_service_simulated.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  RequestAgreement requestMock;
  late FinanceRepository financeRepository;

  setUp(() {
    requestMock = AppRequestServiceSimulated();
    financeRepository = FinanceRepository(requestMock);
  });

  test('Should return Right with valid list of Company when mock search()', () async {
    final response = await financeRepository.search('PSSA3');
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(() => <Company>[]), isInstanceOf<List<Company>>());
    expect(response.getOrElse(() => <Company>[]).length, 2);
  });

  test('Should return Right with valid list of Price when mock getPrices()', () async {
    final response = await financeRepository.getPrices(['ITUB3:BZ', 'PSSA3:BZ']);
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(() => <Price>[]), isInstanceOf<List<Price>>());
    expect(response.getOrElse(() => <Price>[]).length, 2);
  });

  test('Should return Right with valid ExchangeRate when mock getExchangeRate', () async {
    final response = await financeRepository.getExchangeRate('USD', 'BRL');
    expect(response.isRight(), isTrue);
    final result = response.getOrElse(() => ExchangeRate(null, null, '', '', Amount(0)));
    expect(result, isInstanceOf<ExchangeRate>());
    expect(result.origin, 'USD');
    expect(result.destiny, 'BRL');
  });
}
