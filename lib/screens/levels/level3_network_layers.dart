import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level3NetworkLayers extends StatefulWidget {
  const Level3NetworkLayers({super.key});

  @override
  State<Level3NetworkLayers> createState() => _Level3NetworkLayersState();
}

class _Level3NetworkLayersState extends State<Level3NetworkLayers> {
  List<String> inputLayer = [];
  List<String> hiddenLayer = [];
  List<String> outputLayer = [];
  List<String> availableNeurons = ['N1', 'N2', 'N3', 'N4', 'N5', 'N6'];
  bool showLearningSection = true;
  bool networkComplete = false;
  int score = 0;

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
                      if (showLearningSection) ...[
                        _buildLearningSection(),
                        const SizedBox(height: 20),
                      ] else ...[
                        _buildNetworkBuilder(),
                        const SizedBox(height: 20),
                        _buildAvailableNeurons(),
                        const SizedBox(height: 20),
                        if (networkComplete) _buildSuccessCard(),
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
                showLearningSection ? 'Learning Section' : 'Build Network',
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
            value: showLearningSection ? 0.0 : (networkComplete ? 1.0 : 0.5),
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
          if (showLearningSection) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _startBuilding,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Building',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: ElevatedButton(
                onPressed: networkComplete ? _completeLevel : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  networkComplete ? 'Complete Level' : 'Build Network',
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

  void _startBuilding() {
    setState(() {
      showLearningSection = false;
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