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

  // Interactive quiz variables for stage 2
  bool showInteractiveHint = false;
  bool showVisualExplanation = false;
  int hintCount = 0;
  List<bool> questionCompleted = [];
  Map<int, List<String>> userAnswers = {};
  bool showProgressAnimation = false;

  // Falling letters game variables for stage 1
  String currentWord = '';
  String jumbledWord = '';
  String collectedWord = '';
  int gameScore = 0;
  int lives = 3;
  bool gameActive = false;
  bool gameWon = false;
  bool gameOver = false;
  List<FallingItem> fallingItems = [];
  String lastAction = ''; // For showing feedback messages
  List<String> neuronWords = [
    'NEURON',
    'DENDRITE',
    'AXON',
    'SYNAPSE',
    'WEIGHT',
    'BIAS',
    'SIGMOID',
    'THRESHOLD',
    'ACTIVATION',
    'SIGNAL',
    'IMPULSE',
    'MEMBRANE',
    'RECEPTOR',
    'TRANSMITTER'
  ];

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
    NeuronQuestion(
      'Which activation function is most commonly used in neural networks?',
      'Sigmoid',
      'Sigmoid function maps any input to a value between 0 and 1, making it perfect for binary classification.',
      ['Sigmoid', 'Linear', 'Step function', 'Random function'],
    ),
    NeuronQuestion(
      'What is the role of the threshold in a neuron?',
      'Determines when the neuron fires',
      'The threshold acts as a decision boundary - if the weighted sum exceeds it, the neuron fires.',
      ['Determines when the neuron fires', 'Stores the neuron\'s memory', 'Connects to other neurons', 'Generates energy'],
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
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.purple, Colors.indigo],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.indigo, Colors.blue],
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
                        _buildBallBrickerGame(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 2) ...[
                        _buildStageHeader(),
                        const SizedBox(height: 20),
                        _buildInteractiveQuestionCard(),
                        const SizedBox(height: 20),
                        _buildInteractiveAnswerOptions(),
                        const SizedBox(height: 20),
                        if (showInteractiveHint) _buildInteractiveHint(),
                        const SizedBox(height: 20),
                        if (showResult) _buildInteractiveResultCard(),
                        const SizedBox(height: 20),
                        _buildQuestionProgress(),
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
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
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
                  foregroundColor: Colors.purple,
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
      showInteractiveHint = false;
      hintCount = 0;
      userAnswers.clear();
      questionCompleted.clear();
      // Initialize game for stage 1
      _initializeGame();
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
        showInteractiveHint = false;
        hintCount = 0;
        userAnswers.clear();
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
      
      // Store user answer for progress tracking
      if (!userAnswers.containsKey(currentQuestionIndex)) {
        userAnswers[currentQuestionIndex] = [];
      }
      userAnswers[currentQuestionIndex]!.add(selectedAnswer!);
      
      // Hide hint when showing result
      showInteractiveHint = false;
    });
  }

  void _showHint() {
    if (hintCount < 3) {
      setState(() {
        hintCount++;
        showInteractiveHint = true;
      });
    }
  }

  // Falling letters game methods
  void _initializeGame() {
    // Select a random word
    currentWord = neuronWords[DateTime.now().millisecondsSinceEpoch % neuronWords.length];
    
    // Create jumbled word with proper spacing
    List<String> wordLetters = currentWord.split('')..shuffle();
    jumbledWord = wordLetters.join(' ');
    
    // Reset game state
    gameScore = 0;
    lives = 3;
    gameActive = false;
    gameWon = false;
    gameOver = false;
    collectedWord = '';
    fallingItems.clear();
    lastAction = '';
    
    print('Current word: $currentWord'); // Debug print
    print('Jumbled word: $jumbledWord'); // Debug print
  }

  void _startGame() {
    setState(() {
      gameActive = true;
    });
    _gameLoop();
    _spawnItems();
  }

  void _spawnItems() {
    if (!gameActive) return;
    
    // Spawn a new item every 1-2 seconds
    Future.delayed(Duration(milliseconds: 1000 + (DateTime.now().millisecondsSinceEpoch % 1000)), () {
      if (gameActive) {
        _addFallingItem();
        _spawnItems();
      }
    });
  }

  void _addFallingItem() {
    if (!gameActive) return;
    
    setState(() {
      // 70% chance for letter, 30% chance for bomb
      bool isBomb = DateTime.now().millisecondsSinceEpoch % 10 < 3;
      
      String letter;
      Color color;
      
      if (isBomb) {
        letter = '💣';
        color = Colors.red;
      } else {
        // 60% chance for word letter, 40% chance for random letter
        bool isWordLetter = DateTime.now().millisecondsSinceEpoch % 10 < 6;
        if (isWordLetter && currentWord.isNotEmpty) {
          letter = currentWord[DateTime.now().millisecondsSinceEpoch % currentWord.length];
        } else {
          String alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
          letter = alphabet[DateTime.now().millisecondsSinceEpoch % alphabet.length];
        }
        
        List<Color> colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal];
        color = colors[DateTime.now().millisecondsSinceEpoch % colors.length];
      }
      
      fallingItems.add(FallingItem(
        x: (DateTime.now().millisecondsSinceEpoch % 80) / 100.0 + 0.1, // Random x position
        y: 0.0, // Start from top
        letter: letter,
        isBomb: isBomb,
        color: color,
        speed: 0.015 + (DateTime.now().millisecondsSinceEpoch % 10) / 1000.0, // Random speed
      ));
    });
  }

  void _gameLoop() {
    if (!gameActive) return;
    
    setState(() {
      // Update falling items
      for (int i = fallingItems.length - 1; i >= 0; i--) {
        FallingItem item = fallingItems[i];
        item.y += item.speed;
        
        // Remove items that fall off screen
        if (item.y > 1.0) {
          fallingItems.removeAt(i);
        }
      }
    });
    
    if (gameActive) {
      Future.delayed(const Duration(milliseconds: 50), _gameLoop);
    }
  }

  void _catchItem(FallingItem item) {
    if (item.isBomb) {
      // Bomb caught - lose a life
      lives--;
      gameScore -= 20;
      lastAction = '💣 Bomb caught! -1 life';
      
      if (lives <= 0) {
        gameOver = true;
        gameActive = false;
      }
    } else {
      // Letter caught - check if it's a needed letter from the target word
      if (currentWord.contains(item.letter) && _isLetterNeeded(item.letter)) {
        // Correct letter - add to collected word and increase score
        collectedWord += item.letter;
        gameScore += 10; // Only increase score for correct letters
        lastAction = '✅ Correct letter: ${item.letter} (+10 points)';
        
        // Check if word is complete
        if (_isWordComplete()) {
          gameWon = true;
          gameActive = false;
          score += 50; // Bonus points for completing the word
          
          // Auto-advance to next stage after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              _nextQuestion();
            }
          });
        }
      } else {
        // Wrong letter caught - lose a life
        lives--;
        gameScore -= 5; // Small penalty for wrong letter
        lastAction = '❌ Wrong letter: ${item.letter} (-1 life)';
        
        if (lives <= 0) {
          gameOver = true;
          gameActive = false;
        }
      }
    }
    
    // Clear the action message after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          lastAction = '';
        });
      }
    });
  }

  bool _isLetterNeeded(String letter) {
    // Count how many times this letter appears in the target word
    int targetCount = currentWord.split('').where((l) => l == letter).length;
    
    // Count how many times this letter has been collected
    int collectedCount = collectedWord.split('').where((l) => l == letter).length;
    
    // Return true if we still need more of this letter
    return collectedCount < targetCount;
  }

  String _getRemainingLetters() {
    List<String> remaining = [];
    List<String> targetLetters = currentWord.split('');
    List<String> collectedLetters = collectedWord.split('');
    
    // Count each letter in target word
    Map<String, int> targetCounts = {};
    for (String letter in targetLetters) {
      targetCounts[letter] = (targetCounts[letter] ?? 0) + 1;
    }
    
    // Count each letter in collected word
    Map<String, int> collectedCounts = {};
    for (String letter in collectedLetters) {
      collectedCounts[letter] = (collectedCounts[letter] ?? 0) + 1;
    }
    
    // Find remaining letters
    for (String letter in targetCounts.keys) {
      int needed = targetCounts[letter]!;
      int collected = collectedCounts[letter] ?? 0;
      int stillNeeded = needed - collected;
      
      for (int i = 0; i < stillNeeded; i++) {
        remaining.add(letter);
      }
    }
    
    return remaining.join(' ');
  }

  bool _isWordComplete() {
    if (collectedWord.length != currentWord.length) return false;
    
    // Check if all letters are collected (order doesn't matter)
    List<String> collected = collectedWord.split('')..sort();
    List<String> target = currentWord.split('')..sort();
    
    bool isComplete = collected.join('') == target.join('');
    
    if (isComplete) {
      print('Word completed! Collected: $collectedWord, Target: $currentWord');
    }
    
    return isComplete;
  }

  void _nextQuestion() {
    if (currentStage == 1) {
      // For stage 1 (ball bricker game), move to next stage when game is won
      if (gameWon) {
        _nextStage();
      }
    } else if (currentQuestionIndex < currentQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        showResult = false;
        selectedAnswer = null;
        isCorrect = false;
        showInteractiveHint = false;
        hintCount = 0;
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

  Widget _buildBallBrickerGame() {
    if (!gameActive && !gameWon && !gameOver) {
      _initializeGame();
    }
    
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16),
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
          // Game header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lives: $lives',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              Text(
                'Score: $gameScore',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
                    // Word display
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Collect Letters to Form:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  jumbledWord,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Target Word: $currentWord',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Collected: $collectedWord',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Still needed: ${_getRemainingLetters()}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '💡 Click on the correct letters as they fall!',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Action feedback
          if (lastAction.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: lastAction.contains('✅') 
                    ? Colors.green.withOpacity(0.1)
                    : lastAction.contains('❌') 
                        ? Colors.red.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: lastAction.contains('✅') 
                      ? Colors.green
                      : lastAction.contains('❌') 
                          ? Colors.red
                          : Colors.orange,
                ),
              ),
              child: Text(
                lastAction,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: lastAction.contains('✅') 
                      ? Colors.green.shade700
                      : lastAction.contains('❌') 
                          ? Colors.red.shade700
                          : Colors.orange.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          
          if (lastAction.isNotEmpty) const SizedBox(height: 12),
          
          // Game area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                    Colors.pink.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  // Falling items
                  ...fallingItems.map((item) => _buildFallingItem(item)),
                ],
              ),
            ),
          ),
          
          // Game controls
          const SizedBox(height: 16),
          if (!gameActive && !gameWon && !gameOver)
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Start Game'),
            ),
          
          if (gameWon)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: const Text(
                '🎉 Word Completed! Great job!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          
          if (gameOver)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: const Text(
                'Game Over! Try again!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallingItem(FallingItem item) {
    return Positioned(
      left: item.x * 300,
      top: item.y * 400,
      child: GestureDetector(
        onTap: () {
          if (gameActive) {
            _catchItem(item);
            setState(() {
              fallingItems.remove(item);
            });
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: item.isBomb ? Colors.red : item.color,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: item.isBomb ? Colors.red.withOpacity(0.5) : item.color.withOpacity(0.5),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              item.isBomb ? '💣' : item.letter,
              style: TextStyle(
                color: item.isBomb ? Colors.white : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: item.isBomb ? 18 : 16,
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildInteractiveQuestionCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestionIndex + 1}/${currentQuestions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Hint: ${3 - hintCount}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
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
          const SizedBox(height: 16),
          if (currentQuestionIndex == 0) _buildNeuronVisualHint(),
          if (currentQuestionIndex == 1) _buildWeightVisualHint(),
          if (currentQuestionIndex == 2) _buildBiasVisualHint(),
          if (currentQuestionIndex == 3) _buildActivationVisualHint(),
          if (currentQuestionIndex == 4) _buildThresholdVisualHint(),
        ],
      ),
    );
  }

  Widget _buildNeuronVisualHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '💡 Visual Hint: Look at how multiple inputs flow into the neuron',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightVisualHint() {
    return Container(
      padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.purple, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '💡 Visual Hint: Notice how different line thicknesses represent weights',
              style: TextStyle(
                fontSize: 14,
                color: Colors.purple[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiasVisualHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.teal, size: 20),
          const SizedBox(width: 8),
          Expanded(
          child: Text(
              '💡 Visual Hint: Bias shifts the entire decision boundary',
            style: TextStyle(
              fontSize: 14,
                color: Colors.teal[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivationVisualHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.indigo.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.indigo, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '💡 Visual Hint: Sigmoid creates smooth transitions between 0 and 1',
              style: TextStyle(
                fontSize: 14,
                color: Colors.indigo[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThresholdVisualHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '💡 Visual Hint: Threshold is the "firing line" - cross it and the neuron activates!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
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

  Widget _buildInteractiveAnswerOptions() {
    final question = currentQuestions[currentQuestionIndex];
    return Column(
      children: [
        ...question.options.map((option) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: showResult ? null : () => _selectAnswer(option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getInteractiveAnswerColor(option),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getInteractiveAnswerBorderColor(option),
                  width: selectedAnswer == option ? 3 : 1,
                ),
                boxShadow: selectedAnswer == option ? [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _getInteractiveAnswerIconColor(option),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getInteractiveAnswerIcon(option),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        color: _getInteractiveAnswerTextColor(option),
                        fontWeight: selectedAnswer == option ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (showResult && option == question.correctAnswer)
                    const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  if (showResult && option == selectedAnswer && option != question.correctAnswer)
                    const Icon(Icons.cancel, color: Colors.red, size: 24),
                ],
              ),
            ),
          ),
        )).toList(),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: hintCount < 3 ? _showHint : null,
                icon: const Icon(Icons.lightbulb_outline),
                label: const Text('Get Hint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: selectedAnswer != null ? _checkAnswer : null,
                icon: const Icon(Icons.check),
                label: const Text('Check Answer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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

  // Interactive answer helper methods
  Color _getInteractiveAnswerColor(String option) {
    if (!showResult) {
      return selectedAnswer == option ? Colors.green.withOpacity(0.1) : Colors.white;
    }
    
    final question = currentQuestions[currentQuestionIndex];
    if (option == question.correctAnswer) {
      return Colors.green.withOpacity(0.2);
    } else if (option == selectedAnswer && option != question.correctAnswer) {
      return Colors.red.withOpacity(0.2);
    }
    return Colors.white;
  }

  Color _getInteractiveAnswerBorderColor(String option) {
    if (!showResult) {
      return selectedAnswer == option ? Colors.green : Colors.grey.withOpacity(0.3);
    }
    
    final question = currentQuestions[currentQuestionIndex];
    if (option == question.correctAnswer) {
      return Colors.green;
    } else if (option == selectedAnswer && option != question.correctAnswer) {
      return Colors.red;
    }
    return Colors.grey.withOpacity(0.3);
  }

  Color _getInteractiveAnswerIconColor(String option) {
    if (!showResult) {
      return selectedAnswer == option ? Colors.green : Colors.grey;
    }
    
    final question = currentQuestions[currentQuestionIndex];
    if (option == question.correctAnswer) {
      return Colors.green;
    } else if (option == selectedAnswer && option != question.correctAnswer) {
      return Colors.red;
    }
    return Colors.grey;
  }

  Color _getInteractiveAnswerTextColor(String option) {
    if (!showResult) {
      return Colors.black;
    }
    
    final question = currentQuestions[currentQuestionIndex];
    if (option == question.correctAnswer) {
      return Colors.green.shade700;
    } else if (option == selectedAnswer && option != question.correctAnswer) {
      return Colors.red.shade700;
    }
    return Colors.black;
  }

  IconData _getInteractiveAnswerIcon(String option) {
    if (!showResult) {
      return selectedAnswer == option ? Icons.radio_button_checked : Icons.radio_button_unchecked;
    }
    
    final question = currentQuestions[currentQuestionIndex];
    if (option == question.correctAnswer) {
      return Icons.check_circle;
    } else if (option == selectedAnswer && option != question.correctAnswer) {
      return Icons.cancel;
    }
    return Icons.radio_button_unchecked;
  }

  Widget _buildInteractiveHint() {
    final question = currentQuestions[currentQuestionIndex];
    final hints = _getHintsForQuestion(currentQuestionIndex);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                'Hint ${hintCount + 1}/3',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hints[hintCount],
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange[700],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<String> _getHintsForQuestion(int questionIndex) {
    switch (questionIndex) {
      case 0:
        return [
          'Think about how a neuron processes multiple signals at once.',
          'The neuron doesn\'t ignore any inputs - it considers them all.',
          'The key word is "sum" - it adds everything together!',
        ];
      case 1:
        return [
          'Weights are like importance factors for each input.',
          'Some inputs might be more crucial than others.',
          'Think of weights as multipliers that control influence.',
        ];
      case 2:
        return [
          'Bias helps the neuron make decisions even with weak inputs.',
          'It\'s like a constant that gets added to the calculation.',
          'Bias shifts the entire decision boundary up or down.',
        ];
      case 3:
        return [
          'This function creates smooth transitions between values.',
          'It maps any input to a value between 0 and 1.',
          'The name starts with "S" and is very common in neural networks.',
        ];
      case 4:
        return [
          'This is the decision point for the neuron.',
          'If the output crosses this line, the neuron fires.',
          'Think of it as the "firing line" or activation point.',
        ];
      default:
        return ['Think carefully about the question.', 'Consider all the options.', 'Use the visual hints provided.'];
    }
  }

  Widget _buildInteractiveResultCard() {
    final question = currentQuestions[currentQuestionIndex];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Icon(
              isCorrect ? Icons.celebration : Icons.school,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isCorrect ? '🎉 Excellent!' : '📚 Keep Learning!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isCorrect ? 'You understand this concept well!' : 'Let\'s review the explanation:',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              question.explanation,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (isCorrect) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 20),
                const SizedBox(width: 4),
                Text(
                  '+10 points',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[100],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuestionProgress() {
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
            'Progress: ${currentQuestionIndex + 1}/${currentQuestions.length}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(currentQuestions.length, (index) {
              final isCompleted = index < currentQuestionIndex;
              final isCurrent = index == currentQuestionIndex;
              final isCorrect = userAnswers.containsKey(index) && 
                               userAnswers[index]!.contains(currentQuestions[index].correctAnswer);
              
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 8,
                  decoration: BoxDecoration(
                    color: isCompleted 
                        ? (isCorrect ? Colors.green : Colors.orange)
                        : isCurrent 
                            ? Colors.blue 
                            : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Score: $score',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                'Hints used: $hintCount/3',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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



class FallingItem {
  double x;
  double y;
  final String letter;
  final bool isBomb;
  final Color color;
  double speed;

  FallingItem({
    required this.x,
    required this.y,
    required this.letter,
    this.isBomb = false,
    required this.color,
    this.speed = 0.02,
  });
} 