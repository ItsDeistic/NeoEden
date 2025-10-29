import 'package:flutter/material.dart';
import 'package:neoeden/models/quest_model.dart';
import 'package:neoeden/services/quest_service.dart';
import 'package:neoeden/theme.dart';

class QuestLogScreen extends StatefulWidget {
  const QuestLogScreen({super.key});

  @override
  State<QuestLogScreen> createState() => _QuestLogScreenState();
}

class _QuestLogScreenState extends State<QuestLogScreen> {
  List<QuestModel> _quests = [];
  bool _isLoading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadQuests();
  }

  Future<void> _loadQuests() async {
    final quests = await QuestService().getAllQuests();
    setState(() {
      _quests = quests;
      _isLoading = false;
    });
  }

  List<QuestModel> get _filteredQuests {
    if (_filter == 'all') return _quests;
    if (_filter == 'active') return _quests.where((q) => q.status == 'active').toList();
    if (_filter == 'available') return _quests.where((q) => q.status == 'available').toList();
    if (_filter == 'completed') return _quests.where((q) => q.status == 'completed').toList();
    return _quests;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QUEST LOG', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: GameColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator(color: GameColors.neonCyan))
        : Column(
            children: [
              _buildFilterChips(),
              Expanded(
                child: _filteredQuests.isEmpty
                  ? Center(child: Text('No quests found', style: Theme.of(context).textTheme.bodyMedium))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredQuests.length,
                      itemBuilder: (context, index) => _buildQuestCard(_filteredQuests[index]),
                    ),
              ),
            ],
          ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Available', 'available'),
            const SizedBox(width: 8),
            _buildFilterChip('Active', 'active'),
            const SizedBox(width: 8),
            _buildFilterChip('Completed', 'completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return InkWell(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? GameColors.electricPurple : GameColors.slateGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? GameColors.electricPurple : GameColors.darkSteel, width: 2),
        ),
        child: Text(
          label,
          style: TextStyle(color: GameColors.pureWhite, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildQuestCard(QuestModel quest) {
    Color statusColor;
    switch (quest.status) {
      case 'active': statusColor = GameColors.acidGreen;
      case 'completed': statusColor = GameColors.neonCyan;
      default: statusColor = GameColors.lightGray;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: GameColors.slateGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(quest.title, style: Theme.of(context).textTheme.titleMedium),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quest.status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(quest.description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.stars, color: GameColors.neonOrange, size: 16),
              const SizedBox(width: 6),
              Text('Level ${quest.level}', style: TextStyle(color: GameColors.neonOrange, fontSize: 14)),
              const SizedBox(width: 16),
              Icon(Icons.category, color: GameColors.electricPurple, size: 16),
              const SizedBox(width: 6),
              Text(quest.type, style: TextStyle(color: GameColors.electricPurple, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Text('REWARDS', style: TextStyle(color: GameColors.acidGreen, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: quest.rewards.entries.map((e) => Text('${e.key}: ${e.value}', style: Theme.of(context).textTheme.bodySmall)).toList(),
          ),
        ],
      ),
    );
  }
}
