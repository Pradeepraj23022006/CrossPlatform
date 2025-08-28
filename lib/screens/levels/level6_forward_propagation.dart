import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';

class Level6ForwardPropagation extends StatefulWidget {
  const Level6ForwardPropagation({super.key});

  @override
  State<Level6ForwardPropagation> createState() => _Level6ForwardPropagationState();
}

class _Level6ForwardPropagationState extends State<Level6ForwardPropagation> with TickerProviderStateMixin {
  double input1 = 0.5;
  double input2 = 0.3;
  double weight1 = 0.8;
  double weight2 = 0.6;
  double bias = 0.2;
  int score = 0;
  int currentStep = 0;
  bool showAnimation = false;
  bool animationComplete = false;
  bool showLearningSection = true;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<String> steps = [
    'Set input values',
    'Apply weights and bias',
    'Watch data flow through the network',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weightedSum = (input1 * weight1) + (input2 * weight2) + bias;
    final output = _sigmoid(weightedSum);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 6: Forward Propagation'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo, Colors.blue],
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
                        _buildNetworkVisualization(weightedSum, output),
                        const SizedBox(height: 20),
                        _buildControls(),
                        const SizedBox(height: 20),
                        if (animationComplete) _buildResultCard(output),
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
            'Understanding Forward Propagation',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // What is Forward Propagation
          _buildConceptCard(
            '➡️ What is Forward Propagation?',
            'Forward propagation is the process of passing input data through a neural network to get an output prediction.',
            [
              '• Data flows from input to output',
              '• Each layer processes the data',
              '• Weights and biases are applied',
              '• Final output is the prediction',
            ],
            Colors.indigo,
          ),
          const SizedBox(height: 16),
          
          // The Process
          _buildConceptCard(
            '🔄 The Process',
            'Forward propagation follows a step-by-step process through the network layers.',
            [
              '• Start with input values',
              '• Multiply by weights',
              '• Add bias values',
              '• Apply activation function',
              '• Pass to next layer',
            ],
            Colors.blue,
          ),
          const SizedBox(height: 16),
          
          // Why It Matters
          _buildConceptCard(
            '🎯 Why Forward Propagation Matters',
            'Forward propagation is how neural networks make predictions and decisions.',
            [
              '• Enables real-time predictions',
              '• Processes new data quickly',
              '• Foundation for learning',
              '• Used in inference phase',
            ],
            Colors.green,
          ),
          const SizedBox(height: 20),
          
          // Visual Flow
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Data Flow Example:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFlowStep('Input', '0.5, 0.3', Colors.blue),
                    Icon(Icons.arrow_forward, color: Colors.indigo),
                    _buildFlowStep('Weights', '0.8, 0.6', Colors.green),
                    Icon(Icons.arrow_forward, color: Colors.indigo),
                    _buildFlowStep('Output', '0.73', Colors.orange),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Input × Weights + Bias = Output',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
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

  Widget _buildFlowStep(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
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
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
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
              color: Colors.indigo,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Watch how data flows forward through the neural network!',
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

  Widget _buildNetworkVisualization(double weightedSum, double output) {
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
            'Forward Propagation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
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
                  child: _buildNeuron('Input 1', input1, Colors.blue),
                ),
                Positioned(
                  left: 20,
                  top: 150,
                  child: _buildNeuron('Input 2', input2, Colors.blue),
                ),
                
                // Hidden Layer
                Positioned(
                  left: 150,
                  top: 100,
                  child: _buildNeuron('Hidden', weightedSum, Colors.green),
                ),
                
                // Output Layer
                Positioned(
                  left: 280,
                  top: 100,
                  child: _buildNeuron('Output', output, Colors.red),
                ),
                
                // Connection lines with animation
                if (showAnimation) ...[
                  _buildAnimatedConnection(20, 80, 150, 130, weight1 * input1),
                  _buildAnimatedConnection(20, 180, 150, 130, weight2 * input2),
                  _buildAnimatedConnection(150, 130, 280, 130, output),
                ],
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

  Widget _buildAnimatedConnection(double fromX, double fromY, double toX, double toY, double value) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = _animation.value;
        final currentX = fromX + (toX - fromX) * progress;
        final currentY = fromY + (toY - fromY) * progress;
        
        return Stack(
          children: [
                         // Static line
             CustomPaint(
               size: const Size(300, 300),
               painter: ForwardConnectionLinePainter(fromX, fromY, toX, toY),
             ),
            // Animated dot
            Positioned(
              left: currentX - 5,
              top: currentY - 5,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Value label
            if (progress > 0.5)
              Positioned(
                left: currentX + 10,
                top: currentY - 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
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
            'Network Parameters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 20),
          _buildSlider('Input 1', input1, (value) => setState(() => input1 = value), Colors.blue),
          _buildSlider('Input 2', input2, (value) => setState(() => input2 = value), Colors.blue),
          _buildSlider('Weight 1', weight1, (value) => setState(() => weight1 = value), Colors.orange),
          _buildSlider('Weight 2', weight2, (value) => setState(() => weight2 = value), Colors.orange),
          _buildSlider('Bias', bias, (value) => setState(() => bias = value), Colors.purple),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: showAnimation ? null : _startAnimation,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              showAnimation ? 'Animation Running...' : 'Start Forward Pass',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildResultCard(double output) {
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
            'Forward Pass Complete!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Final Output: ${output.toStringAsFixed(3)}',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Data has successfully flowed through the network from input to output!',
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
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
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
                    foregroundColor: Colors.indigo,
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
                onPressed: animationComplete ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
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

  void _startAnimation() {
    setState(() {
      showAnimation = true;
      animationComplete = false;
      score += 10;
    });
    _animationController.reset();
    _animationController.forward();
  }

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
        showAnimation = false;
        animationComplete = false;
      });
      _animationController.reset();
    } else {
      _completeLevel();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
        showAnimation = false;
        animationComplete = false;
      });
      _animationController.reset();
    }
  }

  void _completeLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeLevel(5, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 6!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "Forward Pass Master" badge! 🏅'),
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

class ForwardConnectionLinePainter extends CustomPainter {
  final double fromX;
  final double fromY;
  final double toX;
  final double toY;

  ForwardConnectionLinePainter(this.fromX, this.fromY, this.toX, this.toY);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(fromX, fromY), Offset(toX, toY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 