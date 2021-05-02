import 'dart:collection';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/shared/models/model.dart';

class Wallet extends Model {
  bool _isMainWallet;
  String _name;
  final String userForeignKey;

  List<Asset> _assets;

  Wallet(
    String objectId,
    DateTime createdAt,
    bool isMainWallet,
    String name,
    this.userForeignKey,
  ) : super(objectId, createdAt) {
    _name = name == null || name.trim().isEmpty ? 'Nova Carteira' : name;
    _isMainWallet = isMainWallet ?? false;
    _assets = <Asset>[];
  }

  Wallet.createMainWallet(this.userForeignKey) : super(null, null) {
    _isMainWallet = true;
    _name = 'Principal';
    _assets = <Asset>[];
  }

  bool get isMainWallet => _isMainWallet;
  String get name => _name;
  UnmodifiableListView<Asset> get assets => UnmodifiableListView<Asset>(_assets);

  void setName(String name) {
    if (name != null && name.trim().isNotEmpty) _name = name;
  }

  void setMainWallet(bool isMainWallet) {
    if (isMainWallet != null) _isMainWallet = isMainWallet;
  }

  void addAsset(Asset asset) {
    clearNotifications();
    if (asset == null) addNotification('Wallet.assets', 'O item adicionado não pode ser "null"');
    if (_assets.contains(asset)) addNotification('Wallet.assets', 'Não é possivel adicionar itens duplicados');
    if (isValid) {
      _assets.add(asset);
      addNotifications(asset);
    }
  }

  void removeAsset(Asset asset) {
    clearNotifications();
    if (asset == null) addNotification('Wallet.assets', '"Null" não é um valor válido para esta lista');
    if (!_assets.contains(asset)) addNotification('Wallet.assets', 'O item não existe na lista');
    if (isValid) _assets.remove(asset);
  }
}
