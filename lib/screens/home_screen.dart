import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'level_screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 Neural Network Learning Game'),
        centerTitle: true,
        actions: [
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${gameProvider.totalScore}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              } else if (value == 'reset') {
                _showResetDialog(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Consumer<GameProvider>(
                  builder: (context, gameProvider, child) {
                    return Text(
                      'Welcome, ${gameProvider.userName ?? 'User'}!',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Reset Login (Test)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Welcome to the Neural Network Adventure!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Learn AI, ML, and Neural Networks through interactive games',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Consumer<GameProvider>(
                  builder: (context, gameProvider, child) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return _buildLevelCard(context, index, gameProvider);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, int index, GameProvider gameProvider) {
    final levelData = _getLevelData(index);
    final isUnlocked = gameProvider.isLevelUnlocked(index);
    final isCompleted = gameProvider.levelCompletion[index];
    final score = gameProvider.levelScores[index];

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: isUnlocked ? () => _navigateToLevel(context, index) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isUnlocked
                  ? [levelData.color.withOpacity(0.8), levelData.color]
                  : [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.5)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      levelData.icon,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      levelData.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      levelData.subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (isCompleted)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '$score pts',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    else if (!isUnlocked)
                      const Icon(Icons.lock, color: Colors.white, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToLevel(BuildContext context, int levelIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => levelScreens[levelIndex],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final gameProvider = Provider.of<GameProvider>(context, listen: false);
              gameProvider.logout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Login'),
        content: const Text('This will clear all data and take you back to the login screen. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              final gameProvider = Provider.of<GameProvider>(context, listen: false);
              gameProvider.clearAllData();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  LevelData _getLevelData(int index) {
    switch (index) {
      case 0:
        return LevelData(
          'What is AI/ML/NN?',
          'Learn the basics',
          Icons.psychology,
          Colors.blue,
        );
      case 1:
        return LevelData(
          'Neuron Basics',
          'How neurons work',
          Icons.circle,
          Colors.green,
        );
      case 2:
        return LevelData(
          'Network Layers',
          'Build connections',
          Icons.layers,
          Colors.orange,
        );
      case 3:
        return LevelData(
          'Weights & Bias',
          'Adjust parameters',
          Icons.tune,
          Colors.red,
        );
      case 4:
        return LevelData(
          'Activation Functions',
          'Visualize functions',
          Icons.show_chart,
          Colors.purple,
        );
      case 5:
        return LevelData(
          'Forward Propagation',
          'Data flow through network',
          Icons.arrow_forward,
          Colors.indigo,
        );
      case 6:
        return LevelData(
          'Loss Function',
          'Calculate errors',
          Icons.track_changes,
          Colors.teal,
        );
      case 7:
        return LevelData(
          'Backpropagation',
          'Learn from mistakes',
          Icons.arrow_back,
          Colors.brown,
        );
      case 8:
        return LevelData(
          'Build Neural Net',
          'Final project',
          Icons.build,
          Colors.pink,
        );
      default:
        return LevelData('Unknown', '', Icons.help, Colors.grey);
    }
  }
}

class LevelData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  LevelData(this.title, this.subtitle, this.icon, this.color);
} 