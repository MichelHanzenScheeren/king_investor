import 'package:get/get.dart';
import 'package:king_investor/data/repositories/authentication_repository.dart';
import 'package:king_investor/data/repositories/database_repository.dart';
import 'package:king_investor/data/repositories/finance_repository.dart';
import 'package:king_investor/data/services/parse_authentication_service.dart';
import 'package:king_investor/data/services/parse_database_service.dart';
import 'package:king_investor/data/services/request_service.dart';
import 'package:king_investor/domain/agreements/authentication_repository_agreement.dart';
import 'package:king_investor/domain/agreements/authentication_service_agreement.dart';
import 'package:king_investor/domain/agreements/database_repository_agreement.dart';
import 'package:king_investor/domain/agreements/database_service_agreement.dart';
import 'package:king_investor/domain/agreements/finance_agreement.dart';
import 'package:king_investor/domain/agreements/request_agreement.dart';
import 'package:king_investor/domain/models/app_data.dart';
import 'package:king_investor/domain/use_cases/assets_use_case.dart';
import 'package:king_investor/domain/use_cases/categories_use_case.dart';
import 'package:king_investor/domain/use_cases/finance_use_case.dart';
import 'package:king_investor/domain/use_cases/user_use_case.dart';
import 'package:king_investor/domain/use_cases/wallets_use_case.dart';
import 'package:king_investor/presentation/controllers/app_data_controller.dart';
import 'package:king_investor/resources/development/mocks/client_authentication_mock.dart';
import 'package:king_investor/resources/development/mocks/client_database_mock.dart';
import 'package:king_investor/resources/development/mocks/false_request_service.dart';
import 'package:king_investor/resources/keys.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

enum Environments { development, production }

class DependenciesInjection {
  DependenciesInjection._();

  static Future<void> init(Environments environments) async {
    bool isDevelopment = environments == Environments.development;

    if (isDevelopment) {
      await Parse().initialize('appId', 'test.com', fileDirectory: '', appName: '', appPackageName: '', appVersion: '');
    } else {
      await Parse().initialize(kAppId, kServerUrl, clientKey: kClientKey, autoSendSessionId: true, debug: true);
    }

    /* CLIENTS */
    final authClient = () => isDevelopment ? AppClientAuthenticationMock() : null;
    final databaseClient = () => isDevelopment ? AppClientDatabaseMock() : null;

    /* SERVICES */
    Get.lazyPut<AuthenticationServiceAgreement>(() => ParseAuthenticationService(client: authClient()), fenix: true);
    Get.lazyPut<DatabaseServiceAgreement>(() => ParseDatabaseService(client: databaseClient()), fenix: true);
    Get.lazyPut<RequestAgreement>(() => isDevelopment ? FalseRequestService() : RequestService(), fenix: true);

    /* Repositories */
    Get.lazyPut<AuthenticationRepositoryAgreement>(() => AuthenticationRepository(Get.find()), fenix: true);
    Get.lazyPut<DatabaseRepositoryAgreement>(() => DatabaseRepository(Get.find()), fenix: true);
    Get.lazyPut<FinanceAgreement>(() => FinanceRepository(Get.find()), fenix: true);

    /* APP DATA */
    Get.lazyPut(() => AppData(), fenix: true);

    /* USE CASES */
    Get.lazyPut(() => UserUseCase(Get.find(), Get.find()), fenix: true);
    Get.lazyPut(() => WalletsUseCase(Get.find(), Get.find()), fenix: true);
    Get.lazyPut(() => AssetsUseCase(Get.find(), Get.find()), fenix: true);
    Get.lazyPut(() => CategoriesUseCase(Get.find(), Get.find()), fenix: true);
    Get.lazyPut(() => FinanceUseCase(Get.find(), Get.find()), fenix: true);

    /* CONTROLLERS */
    Get.put(AppDataController(), permanent: true);
  }
}
