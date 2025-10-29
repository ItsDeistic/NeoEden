import 'package:flutter/material.dart';
import 'package:neoeden/models/inventory_model.dart';
import 'package:neoeden/models/item_model.dart';
import 'package:neoeden/services/game_state_service.dart';
import 'package:neoeden/services/inventory_service.dart';
import 'package:neoeden/services/item_service.dart';
import 'package:neoeden/theme.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  InventoryModel? _inventory;
  List<ItemModel> _allItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    final character = GameStateService().currentCharacter;
    if (character == null) return;

    final inv = await InventoryService().getInventoryByCharacterId(character.id);
    final items = await ItemService().getAllItems();
    
    setState(() {
      _inventory = inv;
      _allItems = items;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INVENTORY', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: GameColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator(color: GameColors.neonCyan))
        : _inventory == null
          ? Center(child: Text('No inventory found', style: Theme.of(context).textTheme.bodyLarge))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCreditsDisplay(),
                  const SizedBox(height: 24),
                  Text('ITEMS', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildItemGrid(),
                ],
              ),
            ),
    );
  }

  Widget _buildCreditsDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GameColors.slateGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GameColors.acidGreen, width: 2),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet, color: GameColors.acidGreen, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Credits', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text('${_inventory!.credits}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: GameColors.acidGreen)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemGrid() {
    if (_inventory!.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text('No items in inventory', style: Theme.of(context).textTheme.bodyMedium),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _inventory!.items.length,
      itemBuilder: (context, index) {
        final invItem = _inventory!.items[index];
        final item = _allItems.where((i) => i.id == invItem.itemId).firstOrNull;
        return item != null ? _buildItemCard(item, invItem.quantity, invItem.isEquipped) : const SizedBox.shrink();
      },
    );
  }

  Widget _buildItemCard(ItemModel item, int quantity, bool isEquipped) {
    Color rarityColor;
    switch (item.rarity) {
      case 'Legendary': rarityColor = GameColors.neonOrange;
      case 'Epic': rarityColor = GameColors.electricPurple;
      case 'Rare': rarityColor = GameColors.neonCyan;
      case 'Uncommon': rarityColor = GameColors.acidGreen;
      default: rarityColor = GameColors.lightGray;
    }

    return Container(
      decoration: BoxDecoration(
        color: GameColors.slateGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: rarityColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getItemIcon(item.type), color: rarityColor, size: 40),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Text('x$quantity', style: TextStyle(color: GameColors.lightGray, fontSize: 12)),
          if (isEquipped)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: GameColors.acidGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('EQUIPPED', style: TextStyle(color: GameColors.deepSpace, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  IconData _getItemIcon(String type) {
    switch (type) {
      case 'Weapon': return Icons.whatshot;
      case 'Armor': return Icons.shield;
      case 'Implant': return Icons.memory;
      case 'Consumable': return Icons.local_pharmacy;
      default: return Icons.inventory;
    }
  }
}
