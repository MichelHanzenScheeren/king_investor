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
    if (asset == null || asset?.company == null) addNotification('Wallet.assets', 'O item não pode ser nulo');
    if (_assets.any((item) => item.objectId == asset?.objectId || item.company.symbol == asset?.company?.symbol))
      addNotification('Wallet.assets', 'Não é possivel adicionar itens duplicados');
    if (isValid) {
      _assets.add(asset);
      addNotifications(asset);
    }
  }

  void removeAsset(String assetId) {
    clearNotifications();
    if (!_assets.any((item) => item.objectId == assetId))
      addNotification('Wallet.assets', 'O item não existe na lista');
    if (isValid) _assets.removeWhere((item) => item.objectId == assetId);
  }

  bool hasAsset(String objectId) => _assets.any((asset) => asset.objectId == objectId);

  void updateAsset(Asset asset) {
    clearNotifications();
    int index = _assets.indexWhere((item) => item.objectId == asset.objectId);
    if (index == -1) addNotification('Wallet.assets', 'Ativo não encontrado na carteira');
    if (isValid) _assets[index] = asset;
  }

  Asset getAsset(String id) => _assets.firstWhere((item) => item.objectId == id, orElse: () => null);
}
