import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level7LossFunction extends StatefulWidget {
  const Level7LossFunction({super.key});

  @override
  State<Level7LossFunction> createState() => _Level7LossFunctionState();
}

class _Level7LossFunctionState extends State<Level7LossFunction> {
  double prediction = 0.5;
  double target = 0.8;
  int score = 0;
  int currentStep = 0;
  bool showResult = false;
  bool showLearningSection = true;
  List<LossExample> examples = [];

  final List<String> steps = [
    'Understand prediction vs target',
    'Calculate Mean Squared Error',
    'Minimize the loss function',
  ];

  @override
  void initState() {
    super.initState();
    _generateExamples();
  }

  void _generateExamples() {
    examples = [
      LossExample(0.2, 0.0, 'Binary Classification'),
      LossExample(0.7, 1.0, 'Binary Classification'),
      LossExample(0.3, 0.5, 'Regression'),
      LossExample(0.9, 0.8, 'Regression'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loss = _calculateMSE(prediction, target);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 7: Loss Function'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal, Colors.cyan],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (showLearningSection) ...[
                        _buildLearningSection(),
                        const SizedBox(height: 20),
                      ] else ...[
                        _buildStepCard(),
                        const SizedBox(height: 20),
                        _buildTargetShootingGame(),
                        const SizedBox(height: 20),
                        _buildLossCalculation(loss),
                        const SizedBox(height: 20),
                        _buildExamples(),
                        const SizedBox(height: 20),
                        if (showResult) _buildResultCard(loss),
                      ],
                    ],
                  ),
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                showLearningSection ? 'Learning Section' : 'Step ${currentStep + 1}/${steps.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Score: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: showLearningSection ? 0.0 : (currentStep + 1) / steps.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Understanding Loss Functions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // What is Loss Function
          _buildConceptCard(
            '🎯 What is a Loss Function?',
            'A loss function measures how well a neural network\'s predictions match the actual target values.',
            [
              '• Measures prediction accuracy',
              '• Provides feedback for learning',
              '• Guides weight updates',
              '• Lower loss = better performance',
            ],
            Colors.teal,
          ),
          const SizedBox(height: 16),
          
          // Mean Squared Error
          _buildConceptCard(
            '📊 Mean Squared Error (MSE)',
            'MSE is a common loss function that measures the average squared difference between predictions and targets.',
            [
              '• Formula: MSE = (prediction - target)²',
              '• Always positive',
              '• Penalizes large errors more',
              '• Good for regression problems',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 16),
          
          // Why Loss Matters
          _buildConceptCard(
            '🎯 Why Loss Functions Matter',
            'Loss functions are essential for training neural networks effectively.',
            [
              '• Guides the learning process',
              '• Helps optimize network parameters',
              '• Measures training progress',
              '• Determines when to stop training',
            ],
            Colors.green,
          ),
          const SizedBox(height: 20),
          
          // Visual Example
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Real-World Example:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.teal, size: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Stock price prediction: If you predict \$100 but the actual price is \$95, your loss is (100-95)² = 25. The goal is to minimize this loss!',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptCard(String title, String description, List<String> points, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          ...points.map((point) => Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              point,
              style: const TextStyle(fontSize: 13),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStepCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            steps[currentStep],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Learn how neural networks measure and minimize errors!',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetShootingGame() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Target Shooting Game',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: Stack(
              children: [
                // Target
                Positioned(
                  left: 50,
                  top: 50,
                  child: _buildTarget(),
                ),
                // Prediction arrow
                Positioned(
                  left: 50 + (prediction * 200),
                  top: 80,
                  child: _buildPredictionArrow(),
                ),
                // Target marker
                Positioned(
                  left: 50 + (target * 200),
                  top: 120,
                  child: _buildTargetMarker(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Adjust the prediction to hit the target!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTarget() {
    return Container(
      width: 200,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Row(
        children: List.generate(10, (index) {
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: index < 9 ? BorderSide(color: Colors.grey, width: 1) : BorderSide.none,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPredictionArrow() {
    return Column(
      children: [
        Icon(
          Icons.keyboard_arrow_down,
          color: Colors.red,
          size: 30,
        ),
        Text(
          'Prediction: ${prediction.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetMarker() {
    return Column(
      children: [
        Icon(
          Icons.flag,
          color: Colors.green,
          size: 30,
        ),
        Text(
          'Target: ${target.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLossCalculation(double loss) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Loss Calculation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLossIndicator('Prediction', prediction, Colors.red),
              _buildLossIndicator('Target', target, Colors.green),
              _buildLossIndicator('Loss (MSE)', loss, loss < 0.01 ? Colors.green : Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.teal.withOpacity(0.3)),
            ),
            child: Text(
              'MSE = (${prediction.toStringAsFixed(2)} - ${target.toStringAsFixed(2)})² = ${loss.toStringAsFixed(4)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Slider(
            value: prediction,
            min: 0.0,
            max: 1.0,
            divisions: 100,
            activeColor: Colors.teal,
            onChanged: (value) => setState(() => prediction = value),
          ),
          Text(
            'Adjust Prediction: ${prediction.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLossIndicator(String label, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildExamples() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Loss Examples',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 20),
          ...examples.map((example) => _buildExampleCard(example)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkLoss,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Calculate Loss',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(LossExample example) {
    final loss = _calculateMSE(example.prediction, example.target);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              example.type,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Pred: ${example.prediction.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              'Target: ${example.target.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              'Loss: ${loss.toStringAsFixed(3)}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: loss < 0.01 ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(double loss) {
    final isGood = loss < 0.01;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isGood ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            isGood ? Icons.check_circle : Icons.info,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            isGood ? 'Excellent Accuracy!' : 'Keep Improving!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isGood 
                ? 'Your prediction is very close to the target! Low loss means good performance.'
                : 'Try adjusting the prediction to get closer to the target and reduce the loss.',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (showLearningSection) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else if (showResult) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentStep < steps.length - 1 ? 'Next Step' : 'Complete Level',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            if (currentStep > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: _previousStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Previous',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _checkLoss,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Check Loss',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _calculateMSE(double prediction, double target) {
    return (prediction - target) * (prediction - target);
  }

  void _startQuiz() {
    setState(() {
      showLearningSection = false;
    });
  }

  void _checkLoss() {
    final loss = _calculateMSE(prediction, target);
    setState(() {
      showResult = true;
      if (loss < 0.01) score += 15;
    });
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
        showResult = false;
      });
    } else {
      _completeLevel();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        showResult = false;
      });
    }
  }

  void _completeLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeLevel(6, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 7!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Loss Function Expert" badge! 🏅'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}

class LossExample {
  final double prediction;
  final double target;
  final String type;

  LossExample(this.prediction, this.target, this.type);
} 