import 'dart:collection';
import 'package:king_investor/shared/models/model.dart';

class Wallet extends Model {
  bool isMainWallet;
  String name;
  List<WalletItem> _items;

  Wallet(String uid, this.isMainWallet, this.name) : super(uid) {
    _items = <WalletItem>[];
  }

  Wallet.createMainWallet() : super(null) {
    this.isMainWallet = true;
    this.name = 'Principal';
    _items = <WalletItem>[];
  }

  UnmodifiableListView<WalletItem> get items => UnmodifiableListView<WalletItem>(_items);
}
