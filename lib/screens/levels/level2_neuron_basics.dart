import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level2NeuronBasics extends StatefulWidget {
  const Level2NeuronBasics({super.key});

  @override
  State<Level2NeuronBasics> createState() => _Level2NeuronBasicsState();
}

class _Level2NeuronBasicsState extends State<Level2NeuronBasics> {
  int currentStage = 0; // 0: Learning, 1: Neuron Structure, 2: Signal Processing, 3: Activation
  double input1 = 0.5;
  double input2 = 0.5;
  double weight1 = 0.5;
  double weight2 = 0.5;
  double bias = 0.0;
  double threshold = 0.5;
  bool neuronFired = false;
  bool showLearningSection = true;
  int score = 0;
  int currentQuestionIndex = 0;
  bool showResult = false;
  String? selectedAnswer;
  bool isCorrect = false;

  // Matching game variables for stage 3
  List<String> leftItems = [];
  List<String> rightItems = [];
  List<String> matchedPairs = [];
  String? selectedLeftItem;
  String? selectedRightItem;
  bool matchingComplete = false;

  final List<NeuronQuestion> stage1Questions = [
    NeuronQuestion(
      'What is the main function of a neuron?',
      'Process and transmit information',
      'Neurons are the basic building blocks that process and transmit information in the brain and neural networks.',
      ['Process and transmit information', 'Store energy', 'Produce oxygen', 'Generate heat'],
    ),
    NeuronQuestion(
      'What are the three main parts of a neuron?',
      'Dendrites, Cell Body, Axon',
      'Dendrites receive signals, the cell body processes them, and the axon transmits the output.',
      ['Dendrites, Cell Body, Axon', 'Brain, Heart, Lungs', 'Input, Output, Memory', 'CPU, RAM, Hard Drive'],
    ),
    NeuronQuestion(
      'What do dendrites do?',
      'Receive input signals',
      'Dendrites are like antennas that receive signals from other neurons or external inputs.',
      ['Receive input signals', 'Send output signals', 'Store memories', 'Generate energy'],
    ),
  ];

  final List<NeuronQuestion> stage2Questions = [
    NeuronQuestion(
      'What happens when a neuron receives multiple inputs?',
      'It sums all the weighted inputs',
      'The neuron adds up all the incoming signals, each multiplied by its corresponding weight.',
      ['It sums all the weighted inputs', 'It ignores weak signals', 'It only uses the strongest input', 'It randomly chooses one'],
    ),
    NeuronQuestion(
      'What is the purpose of weights in a neuron?',
      'To control the importance of each input',
      'Weights determine how much influence each input has on the neuron\'s decision.',
      ['To control the importance of each input', 'To store memories', 'To generate energy', 'To connect neurons'],
    ),
    NeuronQuestion(
      'What does the bias do in a neuron?',
      'Shifts the activation threshold',
      'Bias allows the neuron to fire even when inputs are weak, making it more flexible.',
      ['Shifts the activation threshold', 'Stores information', 'Connects to other neurons', 'Generates signals'],
    ),
  ];

  // Stage 3 will be a matching game instead of quiz questions
  final List<NeuronQuestion> stage3Questions = [];

  // Matching game data for stage 3
  final Map<String, String> matchingPairs = {
    'Dendrites': 'Receive signals',
    'Cell Body': 'Process information',
    'Axon': 'Transmit signals',
    'Synapse': 'Connection point',
    'Myelin': 'Speed up signals',
    'Nucleus': 'Control center',
  };

  List<NeuronQuestion> get currentQuestions {
    switch (currentStage) {
      case 1:
        return stage1Questions;
      case 2:
        return stage2Questions;
      case 3:
        return stage3Questions;
      default:
        return stage1Questions;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 2: Neuron Basics'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green, Colors.teal],
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
                      if (currentStage == 0) ...[
                        _buildLearningSection(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 1) ...[
                        _buildStageHeader(),
                        const SizedBox(height: 20),
                        _buildQuestionCard(),
                        const SizedBox(height: 20),
                        _buildAnswerOptions(),
                        const SizedBox(height: 20),
                        if (showResult) _buildResultCard(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 2) ...[
                        _buildStageHeader(),
                        const SizedBox(height: 20),
                        _buildQuestionCard(),
                        const SizedBox(height: 20),
                        _buildAnswerOptions(),
                        const SizedBox(height: 20),
                        if (showResult) _buildResultCard(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 3) ...[
                        _buildStageHeader(),
                        const SizedBox(height: 20),
                        _buildMatchingGame(),
                        const SizedBox(height: 20),
                      ] else ...[
                        _buildNeuronVisualization(),
                        const SizedBox(height: 20),
                        _buildControls(),
                        const SizedBox(height: 20),
                        _buildCalculation(),
                        const SizedBox(height: 20),
                        if (neuronFired) _buildNeuronResultCard(),
                        const SizedBox(height: 20),
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
                showLearningSection ? 'Learning Section' : 'Interactive Neuron',
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
            value: showLearningSection ? 0.0 : 1.0,
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
            '🧠 Understanding Neurons',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          _buildConceptCard(
            'What is a Neuron?',
            'A neuron is the basic building block of neural networks, inspired by brain cells.',
            [
              '• Takes multiple inputs (like signals)',
              '• Applies weights to each input',
              '• Adds a bias (threshold adjustment)',
              '• Uses an activation function',
              '• Produces an output (fires or not)',
            ],
            Colors.green,
          ),
          const SizedBox(height: 16),
          
          _buildConceptCard(
            'How Does It Work?',
            'Think of a neuron like a decision maker that weighs different factors.',
            [
              '• Inputs: Information coming in',
              '• Weights: How important each input is',
              '• Bias: A constant that shifts the decision',
              '• Sum: Weighted inputs + bias',
              '• Activation: Decides if neuron "fires"',
            ],
            Colors.teal,
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  '🎯 The Formula:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Text(
                    'Output = Activation(Input₁ × Weight₁ + Input₂ × Weight₂ + Bias)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'If Output > Threshold → Neuron Fires! 💡',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
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

  Widget _buildNeuronVisualization() {
    final weightedSum = input1 * weight1 + input2 * weight2 + bias;
    final output = _sigmoid(weightedSum);
    neuronFired = output > threshold;

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
            '🧠 Interactive Neuron',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                // Input 1
                Positioned(
                  left: 20,
                  top: 80,
                  child: _buildInputNode('Input 1', input1.toStringAsFixed(2), Colors.blue),
                ),
                // Input 2
                Positioned(
                  left: 20,
                  top: 140,
                  child: _buildInputNode('Input 2', input2.toStringAsFixed(2), Colors.blue),
                ),
                // Neuron
                Positioned(
                  left: 150,
                  top: 110,
                  child: _buildNeuronNode(output.toStringAsFixed(3), neuronFired),
                ),
                // Connection lines
                CustomPaint(
                  size: const Size(200, 200),
                  painter: ConnectionPainter(80, 100, 150, 140, weight1),
                ),
                CustomPaint(
                  size: const Size(200, 200),
                  painter: ConnectionPainter(80, 160, 150, 140, weight2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputNode(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
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
        ),
        const SizedBox(height: 4),
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

  Widget _buildNeuronNode(String value, bool fired) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: fired ? Colors.orange : Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: fired ? [
              BoxShadow(
                color: Colors.orange.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ] : null,
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          fired ? 'FIRED! 💡' : 'Neuron',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: fired ? Colors.orange : Colors.green,
            fontSize: 12,
          ),
        ),
      ],
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
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          _buildSlider('Input 1', input1, (value) => setState(() => input1 = value)),
          _buildSlider('Input 2', input2, (value) => setState(() => input2 = value)),
          _buildSlider('Weight 1', weight1, (value) => setState(() => weight1 = value)),
          _buildSlider('Weight 2', weight2, (value) => setState(() => weight2 = value)),
          _buildSlider('Bias', bias, (value) => setState(() => bias = value)),
          _buildSlider('Threshold', threshold, (value) => setState(() => threshold = value)),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, Function(double) onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              value.toStringAsFixed(2),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: -2.0,
          max: 2.0,
          divisions: 40,
          activeColor: Colors.green,
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCalculation() {
    final weightedSum = input1 * weight1 + input2 * weight2 + bias;
    final output = _sigmoid(weightedSum);
    
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
            '📊 Calculation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  'Weighted Sum = ${input1.toStringAsFixed(2)} × ${weight1.toStringAsFixed(2)} + ${input2.toStringAsFixed(2)} × ${weight2.toStringAsFixed(2)} + ${bias.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Weighted Sum = ${weightedSum.toStringAsFixed(3)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Output = Sigmoid(${weightedSum.toStringAsFixed(3)}) = ${output.toStringAsFixed(3)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Threshold = ${threshold.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeuronResultCard() {
    final output = _sigmoid(input1 * weight1 + input2 * weight2 + bias);
    final fired = output > threshold;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: fired ? Colors.orange : Colors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            fired ? Icons.lightbulb : Icons.lightbulb_outline,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            fired ? 'Neuron Fired! 💡' : 'Neuron Did Not Fire',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fired 
                ? 'The output (${output.toStringAsFixed(3)}) is greater than the threshold (${threshold.toStringAsFixed(2)})'
                : 'The output (${output.toStringAsFixed(3)}) is less than the threshold (${threshold.toStringAsFixed(2)})',
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
          if (currentStage == 0) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _startSimulation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Simulation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else if (currentStage >= 1 && currentStage <= 2) ...[
            if (showResult) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    currentQuestionIndex < currentQuestions.length - 1 ? 'Next Question' : 'Next Stage',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: selectedAnswer != null ? _checkAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Check Answer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ] else if (currentStage == 3) ...[
            if (matchingComplete) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _completeLevel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Level',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: const Center(
                    child: Text(
                      'Match all pairs to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _completeLevel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Complete Level',
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

  void _startSimulation() {
    setState(() {
      currentStage = 1;
      currentQuestionIndex = 0;
      score = 0;
    });
  }

  void _nextStage() {
    if (currentStage < 3) {
      setState(() {
        currentStage++;
        currentQuestionIndex = 0;
        showResult = false;
        selectedAnswer = null;
        isCorrect = false;
      });
      
      // Initialize matching game for stage 3
      if (currentStage == 3) {
        _initializeMatchingGame();
      }
    } else {
      _completeLevel();
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    final question = currentQuestions[currentQuestionIndex];
    final correct = selectedAnswer == question.correctAnswer;
    
    setState(() {
      showResult = true;
      isCorrect = correct;
      if (correct) score += 10;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < currentQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        showResult = false;
        selectedAnswer = null;
        isCorrect = false;
      });
    } else {
      _nextStage();
    }
  }

  Widget _buildStageHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Stage $currentStage',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getStageDescription(currentStage),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getStageDescription(int stage) {
    switch (stage) {
      case 1:
        return 'Neuron Structure and Components';
      case 2:
        return 'Signal Processing and Weights';
      case 3:
        return 'Matching Game: Neuron Parts';
      default:
        return '';
    }
  }

  // Matching game methods
  void _initializeMatchingGame() {
    setState(() {
      leftItems = matchingPairs.keys.toList()..shuffle();
      rightItems = matchingPairs.values.toList()..shuffle();
      matchedPairs.clear();
      selectedLeftItem = null;
      selectedRightItem = null;
      matchingComplete = false;
    });
  }

  void _selectLeftItem(String item) {
    setState(() {
      selectedLeftItem = item;
      selectedRightItem = null;
    });
  }

  void _selectRightItem(String item) {
    if (selectedLeftItem != null) {
      setState(() {
        selectedRightItem = item;
        _checkMatch();
      });
    }
  }

  void _checkMatch() {
    if (selectedLeftItem != null && selectedRightItem != null) {
      final correctMatch = matchingPairs[selectedLeftItem];
      if (correctMatch == selectedRightItem) {
        // Correct match
        setState(() {
          matchedPairs.add('$selectedLeftItem - $selectedRightItem');
          leftItems.remove(selectedLeftItem);
          rightItems.remove(selectedRightItem);
          selectedLeftItem = null;
          selectedRightItem = null;
          
          if (leftItems.isEmpty && rightItems.isEmpty) {
            matchingComplete = true;
            score += 30; // Bonus for completing matching game
          }
        });
      } else {
        // Incorrect match
        setState(() {
          selectedLeftItem = null;
          selectedRightItem = null;
        });
      }
    }
  }

  Widget _buildMatchingGame() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '🎯 Match Neuron Parts with Their Functions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Left column (neuron parts)
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Neuron Parts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...leftItems.map((item) => _buildMatchingItem(
                      item, 
                      selectedLeftItem == item, 
                      Colors.blue,
                      _selectLeftItem,
                    )),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Right column (functions)
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Functions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...rightItems.map((item) => _buildMatchingItem(
                      item, 
                      selectedRightItem == item, 
                      Colors.green,
                      _selectRightItem,
                    )),
                  ],
                ),
              ),
            ],
          ),
          if (matchedPairs.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    '✅ Matched Pairs:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...matchedPairs.map((pair) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      pair,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMatchingItem(String item, bool isSelected, Color color, Function(String) onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onTap(item),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Text(
            item,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = currentQuestions[currentQuestionIndex];
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
            'Question ${currentQuestionIndex + 1}/${currentQuestions.length}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions() {
    final question = currentQuestions[currentQuestionIndex];
    return Column(
      children: question.options.map((option) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: showResult ? null : () => _selectAnswer(option),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getAnswerColor(option),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedAnswer == option ? Colors.green : Colors.grey.withOpacity(0.3),
                width: selectedAnswer == option ? 3 : 1,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                fontSize: 16,
                color: _getAnswerTextColor(option),
                fontWeight: selectedAnswer == option ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  Color _getAnswerColor(String option) {
    if (!showResult) {
      return selectedAnswer == option ? Colors.green.withOpacity(0.3) : Colors.white;
    }
    
    final question = currentQuestions[currentQuestionIndex];
    if (option == question.correctAnswer) {
      return Colors.green;
    } else if (option == selectedAnswer && option != question.correctAnswer) {
      return Colors.red;
    }
    return Colors.white;
  }

  Color _getAnswerTextColor(String option) {
    if (!showResult) {
      return Colors.black;
    }
    
    final question = currentQuestions[currentQuestionIndex];
    if (option == question.correctAnswer || (option == selectedAnswer && option != question.correctAnswer)) {
      return Colors.white;
    }
    return Colors.black;
  }

  Widget _buildResultCard() {
    final question = currentQuestions[currentQuestionIndex];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            isCorrect ? 'Correct!' : 'Incorrect!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question.explanation,
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

  void _completeLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeLevel(1, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 2!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Neuron Master" badge! 🏅'),
            const SizedBox(height: 16),
            const Text('You now understand how individual neurons work!'),
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

class ConnectionPainter extends CustomPainter {
  final double fromX;
  final double fromY;
  final double toX;
  final double toY;
  final double weight;

  ConnectionPainter(this.fromX, this.fromY, this.toX, this.toY, this.weight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = weight > 0 ? Colors.green : Colors.red
      ..strokeWidth = (weight.abs() * 2).clamp(1.0, 4.0)
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NeuronQuestion {
  final String question;
  final String correctAnswer;
  final String explanation;
  final List<String> options;

  NeuronQuestion(this.question, this.correctAnswer, this.explanation, this.options);
} 