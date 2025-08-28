import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level3NetworkLayers extends StatefulWidget {
  const Level3NetworkLayers({super.key});

  @override
  State<Level3NetworkLayers> createState() => _Level3NetworkLayersState();
}

class _Level3NetworkLayersState extends State<Level3NetworkLayers> {
  // Stage management: 0 Learning, 1 Build Layers, 2 Match Functions, 3 Order Flow
  int currentStage = 0;
  int currentQuestionIndex = 0;
  int score = 0;

  // Stage 1: drag neurons into layers
  List<String> inputLayer = [];
  List<String> hiddenLayer = [];
  List<String> outputLayer = [];
  List<String> availableNeurons = ['N1', 'N2', 'N3', 'N4', 'N5', 'N6'];
  bool showLearningSection = true;
  bool networkComplete = false;

  // Stage 2: matching game (layer -> function)
  final Map<String, String> matchingPairs = const {
    'Input Layer': 'Receives data',
    'Hidden Layer': 'Processes patterns',
    'Output Layer': 'Produces result',
  };
  List<String> leftItems = [];
  List<String> rightItems = [];
  List<String> matchedPairs = [];
  String? selectedLeftItem;
  String? selectedRightItem;
  bool matchingComplete = false;

  // Stage 3: word puzzle
  String puzzleWord = 'NEURAL';
  List<String> scrambledLetters = [];
  List<String> userAnswer = [];
  List<String> availableLetters = [];
  bool puzzleComplete = false;
  String hint = 'Think about what processes information in layers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 3: Network Layers'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.deepOrange],
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
                        _buildNetworkBuilder(),
                        const SizedBox(height: 20),
                        _buildAvailableNeurons(),
                        const SizedBox(height: 20),
                        if (networkComplete) _buildSuccessCard(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 2) ...[
                        _buildStageHeader(),
                        const SizedBox(height: 20),
                        _buildMatchingGame(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 3) ...[
                        _buildStageHeader(),
                        const SizedBox(height: 20),
                        _buildOrderingGame(),
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
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentStage == 1
                ? 'Build the three-layer network'
                : currentStage == 2
                    ? 'Match layers with their functions'
                    : 'Arrange the flow: Input → Hidden → Output',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
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
                currentStage == 0 ? 'Learning Section' : 'Stage $currentStage',
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
            value: currentStage == 0 ? 0.0 : (currentStage / 3).clamp(0.0, 1.0),
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
            '🏗️ Neural Network Layers',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          _buildConceptCard(
            'What are Layers?',
            'Neural networks are organized in layers, like floors in a building. Each layer has a specific job.',
            [
              '• Input Layer: Receives the data',
              '• Hidden Layers: Process the information',
              '• Output Layer: Gives the final result',
            ],
            Colors.orange,
          ),
          const SizedBox(height: 16),
          
          _buildConceptCard(
            'Input Layer',
            'This is where your data enters the network. Think of it as the "front door".',
            [
              '• Receives raw data (images, text, numbers)',
              '• Each input is like a sensor',
              '• Example: Image pixels, text words, sensor readings',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 16),
          
          _buildConceptCard(
            'Hidden Layers',
            'These are the "thinking" layers where the network learns patterns.',
            [
              '• Process information from previous layers',
              '• Find patterns and relationships',
              '• Can have multiple hidden layers',
              '• The "brain" of the network',
            ],
            Colors.green,
          ),
          const SizedBox(height: 16),
          
          _buildConceptCard(
            'Output Layer',
            'This gives you the final answer or prediction.',
            [
              '• Provides the network\'s decision',
              '• Could be a yes/no answer',
              '• Could be a number (like a price)',
              '• Could be a category (like "cat" or "dog")',
            ],
            Colors.red,
          ),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  '🔄 How Data Flows:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFlowBox('Input', 'Data In', Colors.blue),
                    const Icon(Icons.arrow_forward, color: Colors.orange),
                    _buildFlowBox('Hidden', 'Process', Colors.green),
                    const Icon(Icons.arrow_forward, color: Colors.orange),
                    _buildFlowBox('Output', 'Result', Colors.red),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Information flows from left to right, getting processed at each step!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
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

  Widget _buildFlowBox(String label, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkBuilder() {
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
            '🏗️ Build Your Neural Network',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildLayer('Input Layer', inputLayer, Colors.blue, (neuron) {
                  setState(() {
                    inputLayer.remove(neuron);
                    availableNeurons.add(neuron);
                  });
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLayer('Hidden Layer', hiddenLayer, Colors.green, (neuron) {
                  setState(() {
                    hiddenLayer.remove(neuron);
                    availableNeurons.add(neuron);
                  });
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLayer('Output Layer', outputLayer, Colors.red, (neuron) {
                  setState(() {
                    outputLayer.remove(neuron);
                    availableNeurons.add(neuron);
                  });
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (inputLayer.isNotEmpty && hiddenLayer.isNotEmpty && outputLayer.isNotEmpty)
            _buildConnectionLines(),
        ],
      ),
    );
  }

  Widget _buildLayer(String title, List<String> neurons, Color color, Function(String) onRemove) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.5)),
            ),
            child: DragTarget<String>(
              onWillAccept: (data) => true,
              onAccept: (neuron) {
                setState(() {
                  neurons.add(neuron);
                  availableNeurons.remove(neuron);
                  _checkNetworkComplete();
                });
              },
              builder: (context, candidateData, rejectedData) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: neurons.length,
                  itemBuilder: (context, index) {
                    return Draggable<String>(
                      data: neurons[index],
                      feedback: _buildNeuronWidget(neurons[index], color),
                      childWhenDragging: Container(),
                      child: GestureDetector(
                        onTap: () => onRemove(neurons[index]),
                        child: _buildNeuronWidget(neurons[index], color),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeuronWidget(String neuron, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        neuron,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAvailableNeurons() {
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
            '📦 Available Neurons',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableNeurons.map((neuron) {
              return Draggable<String>(
                data: neuron,
                feedback: _buildNeuronWidget(neuron, Colors.grey),
                child: _buildNeuronWidget(neuron, Colors.grey),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Stage 2 matching UI
  Widget _buildMatchingGame() {
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
            'Match Layers to Their Functions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('Layers', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    const SizedBox(height: 8),
                    ...leftItems.map((item) => _buildSelectable(item, selectedLeftItem == item, Colors.blue, _selectLeft)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    const Text('Functions', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 8),
                    ...rightItems.map((item) => _buildSelectable(item, selectedRightItem == item, Colors.green, _selectRight)),
                  ],
                ),
              ),
            ],
          ),
          if (matchedPairs.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: matchedPairs.map((p) => Text('✓ $p', style: const TextStyle(color: Colors.orange))).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectable(String text, bool selected, Color color, Function(String) onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onTap(text),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selected ? color : Colors.grey.withOpacity(0.3), width: selected ? 2 : 1),
          ),
          child: Text(
            text,
            style: TextStyle(color: selected ? color : Colors.black87, fontWeight: selected ? FontWeight.bold : FontWeight.normal),
          ),
        ),
      ),
    );
  }

  void _selectLeft(String item) {
    setState(() {
      selectedLeftItem = item;
      selectedRightItem = null;
    });
  }

  void _selectRight(String item) {
    if (selectedLeftItem == null) return;
    final correct = matchingPairs[selectedLeftItem] == item;
    setState(() {
      if (correct) {
        matchedPairs.add('$selectedLeftItem - $item');
        leftItems.remove(selectedLeftItem);
        rightItems.remove(item);
        score += 10;
        if (leftItems.isEmpty) matchingComplete = true;
      }
      selectedLeftItem = null;
      selectedRightItem = null;
    });
  }

  // Stage 3 word puzzle UI
  Widget _buildOrderingGame() {
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
            'Unscramble the Word Puzzle',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 20),
          Text(
            'Hint: $hint',
            style: const TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Answer slots
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Your Answer:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(puzzleWord.length, (index) {
                    return _buildAnswerSlot(index);
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Available letters
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Available Letters:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableLetters.map((letter) => _buildLetterTile(letter)).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _canCheckAnswer() ? _checkPuzzleAnswer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Check Answer'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _resetPuzzle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
          if (puzzleComplete) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 32),
                  SizedBox(height: 8),
                  Text(
                    'Correct! NEURAL networks process information in layers!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnswerSlot(int index) {
    final letter = userAnswer[index];
    return GestureDetector(
      onTap: () => _removeLetterFromSlot(index),
      child: Container(
        width: 40,
        height: 50,
        decoration: BoxDecoration(
          color: letter.isEmpty ? Colors.white : Colors.orange,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange, width: 2),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: letter.isEmpty ? Colors.grey : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLetterTile(String letter) {
    return GestureDetector(
      onTap: () => _addLetterToNextSlot(letter),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _addLetterToNextSlot(String letter) {
    final emptyIndex = userAnswer.indexWhere((slot) => slot.isEmpty);
    if (emptyIndex != -1) {
      setState(() {
        userAnswer[emptyIndex] = letter;
        availableLetters.remove(letter);
      });
    }
  }

  void _removeLetterFromSlot(int index) {
    final letter = userAnswer[index];
    if (letter.isNotEmpty) {
      setState(() {
        userAnswer[index] = '';
        availableLetters.add(letter);
      });
    }
  }

  bool _canCheckAnswer() {
    return !userAnswer.contains('');
  }

  void _checkPuzzleAnswer() {
    final answer = userAnswer.join('');
    setState(() {
      if (answer == puzzleWord) {
        puzzleComplete = true;
        score += 20;
      }
    });
  }

  void _resetPuzzle() {
    setState(() {
      userAnswer = List.filled(puzzleWord.length, '');
      availableLetters = List.from(scrambledLetters);
      puzzleComplete = false;
    });
  }

  bool _checkOrder() {
    // This method is no longer used but kept for compatibility
    return true;
  }
  Widget _buildConnectionLines() {
    return Container(
      height: 100,
      child: CustomPaint(
        size: const Size(double.infinity, 100),
        painter: ConnectionLinePainter(),
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          const Text(
            'Network Complete! 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'You\'ve successfully built a 3-layer neural network! Data can now flow from input through hidden to output.',
            style: TextStyle(
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
                onPressed: _startStage1,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Stage 1',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else if (currentStage == 1) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: networkComplete ? _goToStage2 : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  networkComplete ? 'Go to Stage 2' : 'Build Network',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else if (currentStage == 2) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: matchingComplete ? _goToStage3 : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  matchingComplete ? 'Go to Stage 3' : 'Match Pairs',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else if (currentStage == 3) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: puzzleComplete ? _completeLevel : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  puzzleComplete ? 'Complete Level' : 'Solve the puzzle',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _checkNetworkComplete() {
    if (inputLayer.length >= 2 && hiddenLayer.length >= 2 && outputLayer.length >= 1) {
      setState(() {
        networkComplete = true;
        score += 50;
      });
    }
  }

  void _startStage1() {
    setState(() {
      currentStage = 1;
      // reset stage 1 state
      inputLayer.clear();
      hiddenLayer.clear();
      outputLayer.clear();
      availableNeurons = ['N1', 'N2', 'N3', 'N4', 'N5', 'N6'];
      networkComplete = false;
    });
  }

  void _initializeMatchingGame() {
    leftItems = matchingPairs.keys.toList()..shuffle();
    rightItems = matchingPairs.values.toList()..shuffle();
    matchedPairs.clear();
    selectedLeftItem = null;
    selectedRightItem = null;
    matchingComplete = false;
  }

  void _goToStage2() {
    setState(() {
      currentStage = 2;
      _initializeMatchingGame();
      score += 10;
    });
  }

  void _goToStage3() {
    setState(() {
      currentStage = 3;
      // Initialize word puzzle
      scrambledLetters = puzzleWord.split('')..shuffle();
      userAnswer = List.filled(puzzleWord.length, '');
      availableLetters = List.from(scrambledLetters);
      score += 10;
    });
  }

  void _completeLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeLevel(2, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 3!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Network Architect" badge! 🏅'),
            const SizedBox(height: 16),
            const Text('You now understand how neural networks are structured in layers!'),
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

class ConnectionLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw connection lines between layers
    canvas.drawLine(const Offset(50, 50), Offset(size.width - 50, 50), paint);
    canvas.drawLine(const Offset(50, 50), Offset(size.width - 50, 50), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}