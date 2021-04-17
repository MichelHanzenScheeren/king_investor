import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/repositories/finance_repository.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/domain/models/company.dart';

import '../../mocks/request_service_mock.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  RequestAgreement requetMock;
  FinanceRepository financeRepository;

  setUp(() {
    requetMock = RequestServiceMock();
    financeRepository = FinanceRepository(requetMock);
  });

  test('Should return Right with valid list of Company when mock search', () async {
    final response = await financeRepository.search('PSSA3');
    expect(response.isRight(), isTrue);
    expect(response.getOrElse(null), isInstanceOf<List<Company>>());
    expect(response.getOrElse(null).length, 1);
  });
}
