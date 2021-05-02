import 'package:king_investor/domain/models/category.dart';
import 'package:king_investor/domain/models/exchange_rate.dart';
import 'package:king_investor/domain/models/user.dart';
import 'package:king_investor/domain/models/wallet.dart';
import 'package:king_investor/shared/models/model.dart';

class AppData extends Model {
  User currentUser;
  bool wasUpdated = false;
  final List<Category> categories = <Category>[];
  final List<ExchangeRate> exchangeRates = <ExchangeRate>[];
  final List<Wallet> wallets = <Wallet>[];

  AppData() : super(null, null);
}
