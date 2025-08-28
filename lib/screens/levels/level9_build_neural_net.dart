import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level9BuildNeuralNet extends StatefulWidget {
  const Level9BuildNeuralNet({super.key});

  @override
  State<Level9BuildNeuralNet> createState() => _Level9BuildNeuralNetState();
}

class _Level9BuildNeuralNetState extends State<Level9BuildNeuralNet> {
  // Network parameters
  double weight1 = 0.5;
  double weight2 = 0.5;
  double weight3 = 0.5;
  double weight4 = 0.5;
  double weight5 = 0.5;
  double weight6 = 0.5;
  double bias1 = 0.0;
  double bias2 = 0.0;
  double bias3 = 0.0;
  
  // Training parameters
  double learningRate = 0.1;
  int epochs = 0;
  int maxEpochs = 1000;
  bool isTraining = false;
  bool trainingComplete = false;
  bool showLearningSection = true;
  
  // Performance tracking
  int score = 0;
  int currentStep = 0;
  List<TrainingEpoch> trainingHistory = [];
  List<XORTest> testCases = [];
  double accuracy = 0.0;

  final List<String> steps = [
    'Build XOR Neural Network',
    'Train the network',
    'Test performance',
  ];

  @override
  void initState() {
    super.initState();
    _initializeTestCases();
  }

  void _initializeTestCases() {
    testCases = [
      XORTest(0, 0, 0),
      XORTest(0, 1, 1),
      XORTest(1, 0, 1),
      XORTest(1, 1, 0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 9: Build Neural Net'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink, Colors.purple],
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
                        _buildNetworkArchitecture(),
                        const SizedBox(height: 20),
                        _buildTrainingSection(),
                        const SizedBox(height: 20),
                        _buildTestResults(),
                        const SizedBox(height: 20),
                        if (trainingComplete) _buildFinalResult(),
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
            'Building a Complete Neural Network',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // What We'll Build
          _buildConceptCard(
            '🧠 What We\'ll Build',
            'In this final level, you\'ll build a complete neural network that can solve the XOR problem.',
            [
              '• Multi-layer neural network',
              '• XOR logic gate implementation',
              '• Complete training process',
              '• Performance evaluation',
            ],
            Colors.pink,
          ),
          const SizedBox(height: 16),
          
          // XOR Problem
          _buildConceptCard(
            '🔀 The XOR Problem',
            'XOR (Exclusive OR) is a classic problem that simple linear models cannot solve.',
            [
              '• Input: Two binary values (0 or 1)',
              '• Output: 1 if inputs are different, 0 if same',
              '• Requires non-linear decision boundary',
              '• Perfect test for neural networks',
            ],
            Colors.purple,
          ),
          const SizedBox(height: 16),
          
          // Network Architecture
          _buildConceptCard(
            '🏗️ Network Architecture',
            'Our network will have multiple layers to learn complex patterns.',
            [
              '• Input layer: 2 neurons',
              '• Hidden layer: 2 neurons',
              '• Output layer: 1 neuron',
              '• Weights and biases for connections',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 20),
          
          // XOR Truth Table
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'XOR Truth Table:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTruthTableHeader('Input A', 'Input B', 'Output'),
                    _buildTruthTableRow(0, 0, 0),
                    _buildTruthTableRow(0, 1, 1),
                    _buildTruthTableRow(1, 0, 1),
                    _buildTruthTableRow(1, 1, 0),
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

  Widget _buildTruthTableHeader(String col1, String col2, String col3) {
    return Column(
      children: [
        Text(
          col1,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          col2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          col3,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTruthTableRow(int a, int b, int output) {
    return Column(
      children: [
        Text('$a', style: const TextStyle(fontSize: 12)),
        Text('$b', style: const TextStyle(fontSize: 12)),
        Text('$output', style: const TextStyle(fontSize: 12)),
      ],
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
              color: Colors.pink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Build a neural network to solve the XOR problem!',
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

  Widget _buildNetworkArchitecture() {
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
            'XOR Neural Network',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                // Input Layer
                Positioned(
                  left: 20,
                  top: 50,
                  child: _buildNeuron('Input 1', 'X₁', Colors.blue),
                ),
                Positioned(
                  left: 20,
                  top: 150,
                  child: _buildNeuron('Input 2', 'X₂', Colors.blue),
                ),
                
                // Hidden Layer
                Positioned(
                  left: 150,
                  top: 80,
                  child: _buildNeuron('Hidden 1', 'H₁', Colors.green),
                ),
                Positioned(
                  left: 150,
                  top: 180,
                  child: _buildNeuron('Hidden 2', 'H₂', Colors.green),
                ),
                
                // Output Layer
                Positioned(
                  left: 280,
                  top: 130,
                  child: _buildNeuron('Output', 'Y', Colors.red),
                ),
                
                // Connection lines
                _buildConnectionLine(80, 80, 150, 110, weight1),
                _buildConnectionLine(80, 180, 150, 110, weight2),
                _buildConnectionLine(80, 80, 150, 210, weight3),
                _buildConnectionLine(80, 180, 150, 210, weight4),
                _buildConnectionLine(200, 110, 280, 160, weight5),
                _buildConnectionLine(200, 210, 280, 160, weight6),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeightDisplay('W₁₁', weight1),
              _buildWeightDisplay('W₁₂', weight2),
              _buildWeightDisplay('W₂₁', weight3),
              _buildWeightDisplay('W₂₂', weight4),
              _buildWeightDisplay('W₃₁', weight5),
              _buildWeightDisplay('W₃₂', weight6),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNeuron(String label, String symbol, Color color) {
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
              symbol,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
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

  Widget _buildConnectionLine(double fromX, double fromY, double toX, double toY, double weight) {
    return CustomPaint(
      size: const Size(300, 300),
      painter: XORConnectionLinePainter(fromX, fromY, toX, toY, weight),
    );
  }

  Widget _buildWeightDisplay(String label, double value) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingSection() {
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
            'Training Configuration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Learning Rate',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Slider(
                      value: learningRate,
                      min: 0.01,
                      max: 0.5,
                      divisions: 49,
                      activeColor: Colors.pink,
                      onChanged: (value) => setState(() => learningRate = value),
                    ),
                    Text(
                      learningRate.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Max Epochs',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Slider(
                      value: maxEpochs.toDouble(),
                      min: 100,
                      max: 2000,
                      divisions: 19,
                      activeColor: Colors.pink,
                      onChanged: (value) => setState(() => maxEpochs = value.toInt()),
                    ),
                    Text(
                      maxEpochs.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: isTraining ? null : _startTraining,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isTraining ? 'Training...' : 'Start Training',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetNetwork,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          if (epochs > 0) ...[
            const SizedBox(height: 20),
            Text(
              'Epochs: $epochs',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTestResults() {
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
            'XOR Test Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
          const SizedBox(height: 20),
          ...testCases.map((testCase) => _buildTestCaseResult(testCase)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Accuracy:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                Text(
                  '${(accuracy * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accuracy > 0.9 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestCaseResult(XORTest testCase) {
    final prediction = _forwardPass(testCase.input1.toDouble(), testCase.input2.toDouble());
    final isCorrect = (prediction > 0.5) == (testCase.expected == 1);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'X₁=${testCase.input1}, X₂=${testCase.input2}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Expected: ${testCase.expected}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              'Predicted: ${prediction.toStringAsFixed(3)}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFinalResult() {
    final isSuccess = accuracy > 0.9;
    
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
            isSuccess ? 'XOR Problem Solved!' : 'Keep Training!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isSuccess 
                ? 'Your neural network successfully learned the XOR logic! Accuracy: ${(accuracy * 100).toStringAsFixed(1)}%'
                : 'The network needs more training to achieve high accuracy.',
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
                  foregroundColor: Colors.pink,
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
                    foregroundColor: Colors.pink,
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
                  foregroundColor: Colors.pink,
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

  double _forwardPass(double x1, double x2) {
    // Hidden layer
    final h1 = _sigmoid(x1 * weight1 + x2 * weight2 + bias1);
    final h2 = _sigmoid(x1 * weight3 + x2 * weight4 + bias2);
    
    // Output layer
    return _sigmoid(h1 * weight5 + h2 * weight6 + bias3);
  }

  double _sigmoid(double x) {
    return 1 / (1 + exp(-x));
  }

  double exp(double x) {
    return x < 0 ? 1 / (1 - x + x * x / 2) : 1 + x + x * x / 2;
  }

  void _startQuiz() {
    setState(() {
      showLearningSection = false;
    });
  }

  void _startTraining() async {
    setState(() {
      isTraining = true;
      epochs = 0;
      trainingHistory.clear();
    });

    for (int epoch = 0; epoch < maxEpochs; epoch++) {
      double totalLoss = 0.0;
      
      // Train on all XOR cases
      for (final testCase in testCases) {
        final prediction = _forwardPass(testCase.input1.toDouble(), testCase.input2.toDouble());
        final target = testCase.expected.toDouble();
        final loss = _calculateLoss(prediction, target);
        totalLoss += loss;
        
        // Backpropagation
        _backpropagate(testCase.input1.toDouble(), testCase.input2.toDouble(), prediction, target);
      }
      
      setState(() {
        epochs = epoch + 1;
        trainingHistory.add(TrainingEpoch(epoch + 1, totalLoss / testCases.length));
      });
      
      // Check if training is complete
      if (totalLoss / testCases.length < 0.01) {
        break;
      }
      
      // Add small delay to show progress
      await Future.delayed(const Duration(milliseconds: 10));
    }
    
    _evaluatePerformance();
    
    setState(() {
      isTraining = false;
      trainingComplete = true;
      score += 50;
    });
  }

  double _calculateLoss(double prediction, double target) {
    return (prediction - target) * (prediction - target);
  }

  void _backpropagate(double x1, double x2, double prediction, double target) {
    final error = prediction - target;
    final sigmoidDerivative = prediction * (1 - prediction);
    
    // Calculate gradients for output layer
    final gradWeight5 = error * sigmoidDerivative * _sigmoid(x1 * weight1 + x2 * weight2 + bias1);
    final gradWeight6 = error * sigmoidDerivative * _sigmoid(x1 * weight3 + x2 * weight4 + bias2);
    final gradBias3 = error * sigmoidDerivative;
    
    // Update output layer weights
    weight5 -= learningRate * gradWeight5;
    weight6 -= learningRate * gradWeight6;
    bias3 -= learningRate * gradBias3;
    
    // Calculate gradients for hidden layer (simplified)
    final h1 = _sigmoid(x1 * weight1 + x2 * weight2 + bias1);
    final h2 = _sigmoid(x1 * weight3 + x2 * weight4 + bias2);
    
    final gradWeight1 = error * sigmoidDerivative * weight5 * h1 * (1 - h1) * x1;
    final gradWeight2 = error * sigmoidDerivative * weight5 * h1 * (1 - h1) * x2;
    final gradBias1 = error * sigmoidDerivative * weight5 * h1 * (1 - h1);
    
    final gradWeight3 = error * sigmoidDerivative * weight6 * h2 * (1 - h2) * x1;
    final gradWeight4 = error * sigmoidDerivative * weight6 * h2 * (1 - h2) * x2;
    final gradBias2 = error * sigmoidDerivative * weight6 * h2 * (1 - h2);
    
    // Update hidden layer weights
    weight1 -= learningRate * gradWeight1;
    weight2 -= learningRate * gradWeight2;
    bias1 -= learningRate * gradBias1;
    
    weight3 -= learningRate * gradWeight3;
    weight4 -= learningRate * gradWeight4;
    bias2 -= learningRate * gradBias2;
  }

  void _evaluatePerformance() {
    int correct = 0;
    for (final testCase in testCases) {
      final prediction = _forwardPass(testCase.input1.toDouble(), testCase.input2.toDouble());
      if ((prediction > 0.5) == (testCase.expected == 1)) {
        correct++;
      }
    }
    accuracy = correct / testCases.length;
  }

  void _resetNetwork() {
    setState(() {
      weight1 = 0.5;
      weight2 = 0.5;
      weight3 = 0.5;
      weight4 = 0.5;
      weight5 = 0.5;
      weight6 = 0.5;
      bias1 = 0.0;
      bias2 = 0.0;
      bias3 = 0.0;
      epochs = 0;
      trainingHistory.clear();
      trainingComplete = false;
      accuracy = 0.0;
    });
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
    gameProvider.completeLevel(8, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 9!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Neural Network Architect" badge! 🏅'),
            const SizedBox(height: 16),
            const Text('You\'ve successfully built and trained a neural network to solve the XOR problem!'),
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

class XORTest {
  final int input1;
  final int input2;
  final int expected;

  XORTest(this.input1, this.input2, this.expected);
}

class TrainingEpoch {
  final int epoch;
  final double loss;

  TrainingEpoch(this.epoch, this.loss);
}

class XORConnectionLinePainter extends CustomPainter {
  final double fromX;
  final double fromY;
  final double toX;
  final double toY;
  final double weight;

  XORConnectionLinePainter(this.fromX, this.fromY, this.toX, this.toY, this.weight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = weight > 0 ? Colors.green : Colors.red
      ..strokeWidth = (weight.abs() * 3).clamp(1.0, 5.0)
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 