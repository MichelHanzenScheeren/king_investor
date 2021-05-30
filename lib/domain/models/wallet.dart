import 'dart:collection';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/shared/models/model.dart';

class Wallet extends Model {
  late bool _isMainWallet;
  late String _name;
  final String userForeignKey;

  late List<Asset> _assets;

  Wallet(
    String? objectId,
    DateTime? createdAt,
    bool? isMainWallet,
    String? name,
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

  void setName(String? name) {
    if (name != null && name.trim().isNotEmpty) _name = name;
  }

  void setMainWallet(bool? isMainWallet) {
    if (isMainWallet != null) _isMainWallet = isMainWallet;
  }

  bool isValidAssetToAdd(Asset? asset) {
    clearNotifications();
    if (asset == null) {
      addNotification('Wallet.assets', 'O item não pode ser nulo');
      return false;
    } else if (!asset.isValid) {
      addNotification('Wallet.assets', 'Não é possível adicionar um item inválido');
      return false;
    }
    if (_assets.any((item) => item.objectId == asset.objectId || item.company.symbol == asset.company.symbol)) {
      addNotification('Wallet.assets', 'Não é possivel adicionar itens duplicados');
      return false;
    }
    return true;
  }

  void addAsset(Asset asset) {
    if (!isValidAssetToAdd(asset)) throw Exception('Tentativa de adicionar um item inválido a uma carteira');
    _assets.add(asset);
    addNotifications(asset);
  }

  bool isValidAssetToManipulate(String assetId) {
    if (hasAsset(assetId)) return true;
    clearNotifications();
    addNotification('Wallet.assets', 'O item não existe na lista');
    return false;
  }

  void removeAsset(String assetId) {
    if (!isValidAssetToManipulate(assetId)) throw Exception('Tentativa de remoção de item que não existe na carteira');
    _assets.removeWhere((item) => item.objectId == assetId);
  }

  bool hasAsset(String objectId) => _assets.any((asset) => asset.objectId == objectId);

  void updateAsset(Asset asset) {
    if (!isValidAssetToManipulate(asset.objectId))
      throw Exception('Tentativa de edição de item que não existe na carteira');
    int index = _assets.indexWhere((item) => item.objectId == asset.objectId);
    _assets[index] = asset;
  }

  Asset getAsset(String id) => _assets.firstWhere((item) => item.objectId == id);
}
