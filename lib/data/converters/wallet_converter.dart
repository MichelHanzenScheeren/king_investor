import 'package:king_investor/data/utils/parse_properties.dart';
import 'package:king_investor/domain/models/wallet.dart';

class WalletConverter {
  Wallet fromMapToModel(map) {
    return Wallet(
      map[kObjectId],
      map[kCreatedAt],
      map[kIsMainWallet],
      map[kName],
      map[kUser][kObjectId],
    );
  }

  Map fromModelToMap(Wallet wallet) {
    return {
      kObjectId: wallet.objectId,
      kCreatedAt: wallet.createdAt,
      kIsMainWallet: wallet.isMainWallet,
      kName: wallet.name,
      kUserForeignKey: wallet.userForeignKey,
    };
  }
}
