import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level8Backpropagation extends StatefulWidget {
  const Level8Backpropagation({super.key});

  @override
  State<Level8Backpropagation> createState() => _Level8BackpropagationState();
}

class _Level8BackpropagationState extends State<Level8Backpropagation> {
  double weight1 = 0.5;
  double weight2 = 0.3;
  double bias = 0.1;
  double input1 = 1.0;
  double input2 = 0.5;
  double target = 0.8;
  double learningRate = 0.1;
  int score = 0;
  int currentStep = 0;
  bool showGradients = false;
  bool trainingComplete = false;
  bool showLearningSection = true;
  List<TrainingStep> trainingHistory = [];

  final List<String> steps = [
    'Understand gradient descent',
    'Calculate gradients',
    'Update weights to reduce loss',
  ];

  @override
  Widget build(BuildContext context) {
    final prediction = _forwardPass(input1, input2, weight1, weight2, bias);
    final loss = _calculateLoss(prediction, target);
    final gradients = _calculateGradients(input1, input2, prediction, target);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 8: Backpropagation'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown, Colors.orange],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    children: [
                      if (showLearningSection) ...[
                        _buildLearningSection(),
                        const SizedBox(height: 20),
                      ] else ...[
                        _buildStepCard(),
                        const SizedBox(height: 20),
                        _buildNetworkVisualization(prediction, loss),
                        const SizedBox(height: 20),
                        _buildGradientDisplay(gradients),
                        const SizedBox(height: 20),
                        _buildTrainingControls(),
                        const SizedBox(height: 20),
                        if (trainingHistory.isNotEmpty) _buildTrainingHistory(),
                        const SizedBox(height: 20),
                        if (trainingComplete) _buildResultCard(),
                      ],
                      // Add extra space at bottom to ensure navigation buttons don't overlap
                      const SizedBox(height: 100),
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
            'Understanding Backpropagation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // What is Backpropagation
          _buildConceptCard(
            '🔄 What is Backpropagation?',
            'Backpropagation is the algorithm that allows neural networks to learn by adjusting weights based on prediction errors.',
            [
              '• Calculates how much each weight contributed to the error',
              '• Updates weights to reduce future errors',
              '• Works backwards through the network',
              '• Uses the chain rule from calculus',
            ],
            Colors.brown,
          ),
          const SizedBox(height: 16),
          
          // Gradient Descent
          _buildConceptCard(
            '📉 Gradient Descent',
            'Gradient descent is the optimization algorithm that minimizes the loss function by following the steepest descent.',
            [
              '• Finds the direction of steepest decrease',
              '• Updates weights in small steps',
              '• Learning rate controls step size',
              '• Gradually converges to optimal values',
            ],
            Colors.orange,
          ),
          const SizedBox(height: 16),
          
          // The Process
          _buildConceptCard(
            '⚙️ The Learning Process',
            'Backpropagation follows a systematic approach to improve the network.',
            [
              '• Forward pass: Make prediction',
              '• Calculate loss: Measure error',
              '• Backward pass: Calculate gradients',
              '• Update weights: Reduce error',
            ],
            Colors.green,
          ),
          const SizedBox(height: 20),
          
          // Visual Example
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Learning Example:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.brown, size: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Like learning to ride a bike: You make mistakes, feel the error (falling), adjust your movements (weights), and gradually improve until you can ride smoothly!',
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
              color: Colors.brown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Learn how neural networks learn from their mistakes!',
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

  Widget _buildNetworkVisualization(double prediction, double loss) {
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
            'Neural Network',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNeuron('Input 1', input1, Colors.blue),
              _buildNeuron('Input 2', input2, Colors.blue),
              _buildNeuron('Output', prediction, Colors.red),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeightDisplay('Weight 1', weight1, Colors.orange),
              _buildWeightDisplay('Weight 2', weight2, Colors.orange),
              _buildWeightDisplay('Bias', bias, Colors.purple),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'Target: ${target.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Loss: ${loss.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: loss < 0.01 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeuron(String label, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
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

  Widget _buildWeightDisplay(String label, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
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
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildGradientDisplay(Map<String, double> gradients) {
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
            'Gradients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGradientIndicator('∂L/∂w₁', gradients['weight1'] ?? 0, Colors.orange),
              _buildGradientIndicator('∂L/∂w₂', gradients['weight2'] ?? 0, Colors.orange),
              _buildGradientIndicator('∂L/∂b', gradients['bias'] ?? 0, Colors.purple),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.brown.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Gradient Descent',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Learning Rate: ${learningRate.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientIndicator(String label, double value, Color color) {
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
              value.toStringAsFixed(3),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
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
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingControls() {
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
            'Training Controls',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _singleStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Single Step',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _trainMultipleSteps,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Train 10 Steps',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Slider(
            value: learningRate,
            min: 0.01,
            max: 0.5,
            divisions: 49,
            activeColor: Colors.brown,
            onChanged: (value) => setState(() => learningRate = value),
          ),
          Text(
            'Learning Rate: ${learningRate.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingHistory() {
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
            'Training History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: trainingHistory.length,
              itemBuilder: (context, index) {
                final step = trainingHistory[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Step ${step.step}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Loss: ${step.loss.toStringAsFixed(4)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: step.loss < 0.01 ? Colors.green : Colors.orange,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Pred: ${step.prediction.toStringAsFixed(3)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final finalLoss = trainingHistory.isNotEmpty ? trainingHistory.last.loss : 1.0;
    final isGood = finalLoss < 0.01;
    
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
            isGood ? 'Training Successful!' : 'Keep Training!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isGood 
                ? 'The network has learned! Loss decreased from ${trainingHistory.first.loss.toStringAsFixed(4)} to ${finalLoss.toStringAsFixed(4)}'
                : 'The loss is still high. Try adjusting the learning rate or training more steps.',
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
                  foregroundColor: Colors.brown,
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
          ] else ...[
            if (currentStep > 0)
              Expanded(
                child: ElevatedButton(
                  onPressed: _previousStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.brown,
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
                onPressed: trainingComplete ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.brown,
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
          ],
        ],
      ),
    );
  }

  double _forwardPass(double x1, double x2, double w1, double w2, double b) {
    return _sigmoid(x1 * w1 + x2 * w2 + b);
  }

  double _sigmoid(double x) {
    return 1 / (1 + exp(-x));
  }

  double exp(double x) {
    return x < 0 ? 1 / (1 - x + x * x / 2) : 1 + x + x * x / 2;
  }

  double _calculateLoss(double prediction, double target) {
    return (prediction - target) * (prediction - target);
  }

  Map<String, double> _calculateGradients(double x1, double x2, double prediction, double target) {
    final error = prediction - target;
    final sigmoidDerivative = prediction * (1 - prediction);
    
    return {
      'weight1': 2 * error * sigmoidDerivative * x1,
      'weight2': 2 * error * sigmoidDerivative * x2,
      'bias': 2 * error * sigmoidDerivative,
    };
  }

  void _startQuiz() {
    setState(() {
      showLearningSection = false;
    });
  }

  void _singleStep() {
    final prediction = _forwardPass(input1, input2, weight1, weight2, bias);
    final loss = _calculateLoss(prediction, target);
    final gradients = _calculateGradients(input1, input2, prediction, target);
    
    // Update weights
    weight1 -= learningRate * (gradients['weight1'] ?? 0);
    weight2 -= learningRate * (gradients['weight2'] ?? 0);
    bias -= learningRate * (gradients['bias'] ?? 0);
    
    final newPrediction = _forwardPass(input1, input2, weight1, weight2, bias);
    final newLoss = _calculateLoss(newPrediction, target);
    
    setState(() {
      trainingHistory.add(TrainingStep(
        trainingHistory.length + 1,
        prediction,
        loss,
        weight1,
        weight2,
        bias,
      ));
      score += 5;
      
      if (newLoss < 0.01) {
        trainingComplete = true;
        score += 20;
      }
    });
  }

  void _trainMultipleSteps() {
    for (int i = 0; i < 10; i++) {
      _singleStep();
    }
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
        trainingComplete = false;
      });
    } else {
      _completeLevel();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        trainingComplete = false;
      });
    }
  }

  void _completeLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeLevel(7, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 8!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Backpropagation Master" badge! 🏅'),
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

class TrainingStep {
  final int step;
  final double prediction;
  final double loss;
  final double weight1;
  final double weight2;
  final double bias;

  TrainingStep(this.step, this.prediction, this.loss, this.weight1, this.weight2, this.bias);
} 