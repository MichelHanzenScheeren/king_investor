import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/wallet_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/wallet.dart';
import '../../static/statics.dart';

final Map expected = {
  'objectId': 'MlZIPMNohV',
  'createdAt': DateTime(2021, 4, 22, 1, 12, 20),
  'isMainWallet': true,
  'name': 'Principal',
  'userForeignKey': '02MdXde5TW',
};

main() async {
  TestWidgetsFlutterBinding.ensureInitialized(); // Para carregar assets
  final Map map = Map.from(json.decode(await rootBundle.loadString(kWalletJsonPath)));

  test('Should return valid Wallet when use fromMapToModel(map)', () {
    Wallet item = WalletConverter().fromMapToModel(map);
    expect(item.isValid, true);
    expect(item.isMainWallet, true);
    expect(item.name, 'Principal');
    expect(item.objectId, 'MlZIPMNohV');
    expect(item.userForeignKey, '02MdXde5TW');
  });

  test('Should return valid Map when use fromModelToLongMap(model)', () {
    Wallet item = Wallet('MlZIPMNohV', DateTime(2021, 4, 22, 1, 12, 20), true, 'Principal', '02MdXde5TW');
    Map converter = WalletConverter().fromModelToMap(item);
    expect(converter, isInstanceOf<Map>());
    expect(converter.length, 5);
    expect(converter[kObjectId], item.objectId);
    expect(converter[kCreatedAt], item.createdAt);
    expect(converter[kIsMainWallet], item.isMainWallet);
    expect(converter[kName], item.name);
    expect(converter[kUserForeignKey], item.userForeignKey);
  });
}
