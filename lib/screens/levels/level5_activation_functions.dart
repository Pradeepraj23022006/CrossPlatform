import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level5ActivationFunctions extends StatefulWidget {
  const Level5ActivationFunctions({super.key});

  @override
  State<Level5ActivationFunctions> createState() => _Level5ActivationFunctionsState();
}

class _Level5ActivationFunctionsState extends State<Level5ActivationFunctions> {
  // 0 Learning, 1 Sandbox, 2 Identify Function, 3 Guess-the-Function
  int currentStage = 0;
  String selectedFunction = 'sigmoid';
  double inputValue = 0.0;
  int score = 0;
  int currentStep = 0;
  bool showResult = false;
  bool showLearningSection = true;

  final List<String> steps = [
    'Explore different activation functions',
    'See how they transform inputs',
    'Understand their characteristics',
  ];

  @override
  Widget build(BuildContext context) {
    final output = _calculateOutput(inputValue, selectedFunction);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 5: Activation Functions'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple, Colors.deepPurple],
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
                      if (currentStage == 0) ...[
                        _buildLearningSection(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 1) ...[
                        _buildStageHeader('Stage 1: Sandbox'),
                        const SizedBox(height: 20),
                        _buildFunctionSelector(),
                        const SizedBox(height: 20),
                        _buildGraphVisualization(),
                        const SizedBox(height: 20),
                        _buildInputSlider(),
                        const SizedBox(height: 20),
                        _buildOutputDisplay(output),
                      ] else if (currentStage == 2) ...[
                        _buildStageHeader('Stage 2: Identify from Graph'),
                        const SizedBox(height: 20),
                        _buildIdentifyFromGraph(),
                        const SizedBox(height: 20),
                      ] else if (currentStage == 3) ...[
                        _buildStageHeader('Stage 3: Guess the Function'),
                        const SizedBox(height: 20),
                        _buildGuessFunctionGame(),
                        const SizedBox(height: 20),
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
            value: currentStage == 0 ? 0.0 : (currentStage / 3),
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
            'Understanding Activation Functions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // What are Activation Functions
          _buildConceptCard(
            '⚡ What are Activation Functions?',
            'Activation functions determine whether a neuron should "fire" or not based on its input.',
            [
              '• Transform the weighted sum of inputs',
              '• Introduce non-linearity to the network',
              '• Help neurons make decisions',
              '• Enable learning complex patterns',
            ],
            Colors.purple,
          ),
          const SizedBox(height: 16),
          
          // Sigmoid Function
          _buildConceptCard(
            '📈 Sigmoid Function',
            'Sigmoid transforms any input to a value between 0 and 1, like a smooth switch.',
            [
              '• Output range: 0 to 1',
              '• Smooth and differentiable',
              '• Good for binary classification',
              '• Can suffer from vanishing gradients',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 16),
          
          // ReLU Function
          _buildConceptCard(
            '🚀 ReLU (Rectified Linear Unit)',
            'ReLU is simple but powerful - it outputs the input if positive, otherwise zero.',
            [
              '• Output: max(0, input)',
              '• Fast computation',
              '• Helps with vanishing gradients',
              '• Most popular in modern networks',
            ],
            Colors.green,
          ),
          const SizedBox(height: 16),
          
          // Tanh Function
          _buildConceptCard(
            '🔄 Tanh (Hyperbolic Tangent)',
            'Tanh transforms inputs to values between -1 and 1, centered around zero.',
            [
              '• Output range: -1 to 1',
              '• Zero-centered output',
              '• Good for hidden layers',
              '• Smoother than sigmoid',
            ],
            Colors.orange,
          ),
          const SizedBox(height: 20),
          
          // Why They Matter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Why Activation Functions Matter:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.purple, size: 24),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Without activation functions, neural networks would only be able to learn linear relationships. Activation functions enable networks to learn complex, non-linear patterns!',
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
              color: Colors.purple,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Learn how different activation functions transform neuron inputs!',
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

  Widget _buildFunctionSelector() {
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
            'Select Activation Function',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildFunctionButton('sigmoid', 'Sigmoid', Colors.blue),
              _buildFunctionButton('relu', 'ReLU', Colors.green),
              _buildFunctionButton('tanh', 'Tanh', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionButton(String function, String name, Color color) {
    final isSelected = selectedFunction == function;
    
    return GestureDetector(
      onTap: () => setState(() => selectedFunction = function),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGraphVisualization() {
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
            'Function Graph',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            child: CustomPaint(
              painter: FunctionGraphPainter(selectedFunction, inputValue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSlider() {
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
            'Input Value',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Input: ${inputValue.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Slider(
            value: inputValue,
            min: -3.0,
            max: 3.0,
            divisions: 60,
            activeColor: Colors.purple,
            onChanged: (value) => setState(() => inputValue = value),
          ),
        ],
      ),
    );
  }

  Widget _buildOutputDisplay(double output) {
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
            'Output',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Text(
                output.toStringAsFixed(3),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _checkResult,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Test Function',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
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
            'Function Applied!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _getFunctionDescription(selectedFunction),
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
                onPressed: () => setState(() { currentStage = 1; score += 5; }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
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
                onPressed: () => setState(() { currentStage = 2; score += 10; }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next: Identify',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else if (currentStage == 2) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _identifyAnswered ? () => setState(() { currentStage = 3; score += 10; }) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _identifyAnswered ? 'Next: Guess Game' : 'Answer first',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ] else if (currentStage == 3) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _guessComplete ? _completeLevel : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
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

  double _calculateOutput(double input, String function) {
    switch (function) {
      case 'sigmoid':
        return 1 / (1 + exp(-input));
      case 'relu':
        return input > 0 ? input : 0;
      case 'tanh':
        return (exp(input) - exp(-input)) / (exp(input) + exp(-input));
      default:
        return input;
    }
  }

  double exp(double x) {
    return x < 0 ? 1 / (1 - x + x * x / 2) : 1 + x + x * x / 2;
  }

  String _getFunctionDescription(String function) {
    switch (function) {
      case 'sigmoid':
        return 'Sigmoid squashes outputs between 0 and 1, great for binary classification!';
      case 'relu':
        return 'ReLU is simple and effective - it outputs the input if positive, 0 otherwise!';
      case 'tanh':
        return 'Tanh outputs values between -1 and 1, useful for centering data!';
      default:
        return '';
    }
  }

  void _startQuiz() {
    setState(() {
      showLearningSection = false;
    });
  }

  void _checkResult() {
    setState(() {
      showResult = true;
      score += 10;
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
    gameProvider.completeLevel(4, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 5!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Function Expert" badge! 🏅'),
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

  // Stage headers for consistency
  Widget _buildStageHeader(String title){
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0,2))]),
      child: Center(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple))),
    );
  }

  // Stage 2: Identify function from graph
  bool _identifyAnswered = false;
  String _identifyCorrect = 'relu';
  String? _identifySelected;

  Widget _buildIdentifyFromGraph(){
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,5))]),
      child: Column(children: [
        const Text('Which function does this graph represent?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
        const SizedBox(height: 12),
        SizedBox(height: 180, child: CustomPaint(painter: FunctionGraphPainter('relu', 0.0))),
        const SizedBox(height: 12),
        Wrap(spacing: 12, children: [
          _idButton('sigmoid'),
          _idButton('relu'),
          _idButton('tanh'),
        ]),
        if (_identifyAnswered)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(_identifySelected==_identifyCorrect? 'Correct!': 'Try again in next stage.', style: TextStyle(color: _identifySelected==_identifyCorrect? Colors.green: Colors.red, fontWeight: FontWeight.bold)),
          ),
      ]),
    );
  }

  Widget _idButton(String value){
    final sel = _identifySelected==value;
    return GestureDetector(
      onTap: (){ setState((){ _identifySelected=value; _identifyAnswered=true; if (value==_identifyCorrect) score+=10; }); },
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: sel? Colors.purple: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: sel? Colors.purple: Colors.grey)), child: Text(value.toUpperCase(), style: TextStyle(color: sel? Colors.white: Colors.grey[800], fontWeight: FontWeight.bold))),
    );
  }

  // Stage 3: Guess-the-function mini game
  bool _guessComplete = false;
  String _mysteryFunction = 'tanh';
  double _mysteryInput = 0.0;

  Widget _buildGuessFunctionGame(){
    final out = _calculateOutput(_mysteryInput, _mysteryFunction);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0,5))]),
      child: Column(children: [
        const Text('Adjust input and guess the hidden function!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
        const SizedBox(height: 12),
        Slider(value: _mysteryInput, min: -2, max: 2, divisions: 40, activeColor: Colors.purple, onChanged: (v)=> setState(()=> _mysteryInput=v)),
        Text('Output: ${out.toStringAsFixed(3)}'),
        const SizedBox(height: 8),
        Wrap(spacing: 12, children: [
          _guessBtn('sigmoid'), _guessBtn('relu'), _guessBtn('tanh')
        ]),
        if (_guessComplete) const Padding(padding: EdgeInsets.only(top:8), child: Text('Well done! Level ready to complete.', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
      ]),
    );
  }

  Widget _guessBtn(String f){
    return ElevatedButton(onPressed: _guessComplete? null: (){ setState(()=> _guessComplete = f==_mysteryFunction); if (f==_mysteryFunction) score+=15; }, style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white), child: Text(f.toUpperCase()));
  }
}

class FunctionGraphPainter extends CustomPainter {
  final String function;
  final double inputValue;

  FunctionGraphPainter(this.function, this.inputValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool firstPoint = true;

    for (double x = -3; x <= 3; x += 0.1) {
      final y = _calculateOutput(x, function);
      final screenX = (x + 3) * size.width / 6;
      final screenY = size.height - (y + 1) * size.height / 2;

      if (firstPoint) {
        path.moveTo(screenX, screenY);
        firstPoint = false;
      } else {
        path.lineTo(screenX, screenY);
      }
    }

    canvas.drawPath(path, paint);

    // Draw input point
    final output = _calculateOutput(inputValue, function);
    final pointX = (inputValue + 3) * size.width / 6;
    final pointY = size.height - (output + 1) * size.height / 2;

    final pointPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(pointX, pointY), 5, pointPaint);
  }

  double _calculateOutput(double input, String function) {
    switch (function) {
      case 'sigmoid':
        return 1 / (1 + exp(-input));
      case 'relu':
        return input > 0 ? input : 0;
      case 'tanh':
        return (exp(input) - exp(-input)) / (exp(input) + exp(-input));
      default:
        return input;
    }
  }

  double exp(double x) {
    return x < 0 ? 1 / (1 - x + x * x / 2) : 1 + x + x * x / 2;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 