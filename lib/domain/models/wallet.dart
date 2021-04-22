import 'dart:collection';
import 'package:king_investor/domain/models/asset.dart';
import 'package:king_investor/shared/models/model.dart';
import 'package:king_investor/shared/notifications/contract.dart';

class Wallet extends Model {
  bool _isMainWallet;
  String _name;
  String _userForeignKey;

  List<Asset> _assets;

  Wallet(
    String objectId,
    DateTime createdAt,
    bool isMainWallet,
    String name,
    String userForeignKey,
  ) : super(objectId, createdAt) {
    _name = name == null || name.trim().isEmpty ? 'Carteira ${DateTime.now().millisecondsSinceEpoch / 1000}' : name;
    _isMainWallet = isMainWallet ?? false;
    _userForeignKey = userForeignKey ?? '';
    _assets = <Asset>[];
    _applyContracts(userForeignKey);
  }

  Wallet.createMainWallet(String userForeignKey) : super(null, null) {
    _isMainWallet = true;
    _name = 'Principal';
    _userForeignKey = userForeignKey ?? '';
    _assets = <Asset>[];
    _applyContracts(userForeignKey);
  }

  void _applyContracts(String userForeignKey) {
    addNotifications(
      Contract().requires().isNotNullOrEmpty(userForeignKey, 'Wallet.userForeignKey.',
          'A chave estrangeira que relaciona uma carteira com um usuário não pode ser nula ou vazia'),
    );
  }

  bool get isMainWallet => _isMainWallet;
  String get name => _name;
  String get userForeignKey => _userForeignKey;
  UnmodifiableListView<Asset> get assets => UnmodifiableListView<Asset>(_assets);

  void setName(String name) {
    if (name != null && name.trim() != '') _name = name;
  }

  void addAsset(Asset asset) {
    clearNotifications();
    if (asset == null) addNotification('Wallet.assets', 'O item adicionado não pode ser "null"');
    if (_assets.contains(asset)) addNotification('Wallet.assets', 'Não é possivel adicionar itens duplicados');
    if (isValid) _assets.add(asset);
  }

  void removeAsset(Asset asset) {
    clearNotifications();
    if (asset == null) addNotification('Wallet.assets', '"Null" não é um valor válido para esta lista');
    if (!_assets.contains(asset)) addNotification('Wallet.assets', 'O item não existe na lista');
    if (isValid) _assets.remove(asset);
  }
}
