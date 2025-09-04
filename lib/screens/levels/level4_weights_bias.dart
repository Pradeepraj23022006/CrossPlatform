import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level4WeightsBias extends StatefulWidget {
  const Level4WeightsBias({super.key});

  @override
  State<Level4WeightsBias> createState() => _Level4WeightsBiasState();
}

class _Level4WeightsBiasState extends State<Level4WeightsBias> {
  double weight1 = 0.5;
  double weight2 = 0.5;
  double bias = 0.0;
  double input1 = 1.0;
  double input2 = 1.0;
  double targetOutput = 0.8;
  int score = 0;
  int currentStep = 0;
  bool showResult = false;
  bool showLearningSection = true;

  final List<String> steps = [
    'Adjust weights to influence the output',
    'Add bias to shift the decision boundary',
    'Fine-tune to match the target output',
  ];

  @override
  Widget build(BuildContext context) {
    final weightedSum = (input1 * weight1) + (input2 * weight2) + bias;
    final output = _sigmoid(weightedSum);
    final error = (output - targetOutput).abs();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 4: Weights & Bias'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.red, Colors.redAccent],
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
                        _buildBalanceScale(weightedSum, output),
                        const SizedBox(height: 20),
                        _buildControls(),
                        const SizedBox(height: 20),
                        _buildTargetDisplay(output, error),
                        const SizedBox(height: 20),
                        if (showResult) _buildResultCard(error),
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
            'Understanding Weights & Bias',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Weights Section
          _buildConceptCard(
            '⚖️ Weights',
            'Weights determine how important each input is to the final decision.',
            [
              '• Higher weights = more influence on output',
              '• Lower weights = less influence on output',
              '• Weights are learned during training',
              '• They control the strength of connections',
            ],
            Colors.red,
          ),
          const SizedBox(height: 16),
          
          // Bias Section
          _buildConceptCard(
            '🎯 Bias',
            'Bias shifts the decision boundary and helps the neuron fire more easily.',
            [
              '• Adds a constant value to the calculation',
              '• Helps control when the neuron activates',
              '• Can be positive or negative',
              '• Essential for learning complex patterns',
            ],
            Colors.orange,
          ),
          const SizedBox(height: 16),
          
          // Calculation Section
          _buildConceptCard(
            '🧮 The Formula',
            'Neuron output = σ(weight1 × input1 + weight2 × input2 + bias)',
            [
              '• Multiply each input by its weight',
              '• Add all weighted inputs together',
              '• Add the bias value',
              '• Apply activation function (σ)',
            ],
            Colors.purple,
          ),
          const SizedBox(height: 20),
          
          // Visual Example
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Real-World Example:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.red, size: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Email spam detection: Words like "free" get high weight, while "meeting" gets low weight. Bias helps determine overall spam threshold.',
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
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Learn how weights and bias affect the neuron\'s output!',
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

  Widget _buildBalanceScale(double weightedSum, double output) {
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
            'Balance Scale',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: Stack(
              children: [
                // Balance beam
                Center(
                  child: Container(
                    width: 200,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Pivot point
                Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Left side (Input 1 * Weight 1)
                Positioned(
                  left: 50,
                  top: 50 + (weightedSum * 50),
                  child: _buildWeight('${(input1 * weight1).toStringAsFixed(2)}', Colors.blue),
                ),
                // Right side (Input 2 * Weight 2 + Bias)
                Positioned(
                  right: 50,
                  top: 50 + ((input2 * weight2 + bias) * 50),
                  child: _buildWeight('${(input2 * weight2 + bias).toStringAsFixed(2)}', Colors.green),
                ),
                // Output indicator
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: output > 0.5 ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Output: ${output.toStringAsFixed(3)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeight(String value, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
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
            'Adjust Parameters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          _buildSlider('Weight 1', weight1, (value) => setState(() => weight1 = value), Colors.blue),
          _buildSlider('Weight 2', weight2, (value) => setState(() => weight2 = value), Colors.green),
          _buildSlider('Bias', bias, (value) => setState(() => bias = value), Colors.purple),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkResult,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Check Result',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label: ${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: -1.0,
          max: 1.0,
          divisions: 20,
          activeColor: color,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTargetDisplay(double output, double error) {
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
            'Target vs Output',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTargetIndicator('Target', targetOutput, Colors.orange),
              _buildTargetIndicator('Output', output, Colors.blue),
              _buildTargetIndicator('Error', error, error < 0.1 ? Colors.green : Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetIndicator(String label, double value, Color color) {
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

  Widget _buildResultCard(double error) {
    final isSuccess = error < 0.1;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.info,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            isSuccess ? 'Great Job!' : 'Keep Trying!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isSuccess 
                ? 'You\'ve successfully adjusted the weights and bias to match the target!'
                : 'Try adjusting the weights and bias to get closer to the target output.',
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
                  foregroundColor: Colors.red,
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
                  foregroundColor: Colors.red,
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
                    foregroundColor: Colors.red,
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
                onPressed: _checkResult,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Check Result',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  double _sigmoid(double x) {
    return 1 / (1 + exp(-x));
  }

  double exp(double x) {
    return x < 0 ? 1 / (1 - x + x * x / 2) : 1 + x + x * x / 2;
  }

  void _checkResult() {
    final weightedSum = (input1 * weight1) + (input2 * weight2) + bias;
    final output = _sigmoid(weightedSum);
    final error = (output - targetOutput).abs();
    
    setState(() {
      showResult = true;
      if (error < 0.1) score += 15;
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

  void _startQuiz() {
    setState(() {
      showLearningSection = false;
    });
  }

  void _completeLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeLevel(3, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 4!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Weight Master" badge! 🏅'),
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