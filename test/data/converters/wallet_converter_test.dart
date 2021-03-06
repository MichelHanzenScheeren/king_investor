import 'package:flutter_test/flutter_test.dart';
import 'package:king_investor/data/converters/wallet_converter.dart';
import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/wallet.dart';

main() async {
  final Map toConvertMap = {
    "objectId": "7jgnYX0BBi",
    "name": "Principal",
    "isMainWallet": true,
    "user": {"__type": "Pointer", "className": "_User", "objectId": "4BwpMWdCnm"},
  };

  test('Should return valid Wallet when use fromMapToModel(map)', () {
    Wallet item = WalletConverter().fromMapToModel(toConvertMap);
    expect(item.isValid, true);
    expect(item.isMainWallet, true);
    expect(item.name, 'Principal');
    expect(item.objectId, '7jgnYX0BBi');
    expect(item.userForeignKey, '4BwpMWdCnm');
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
