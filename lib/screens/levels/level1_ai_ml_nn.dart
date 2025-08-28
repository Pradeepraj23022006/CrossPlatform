import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/game_provider.dart';
import '../../widgets/common_widgets.dart';

class Level1AIMLNN extends StatefulWidget {
  const Level1AIMLNN({super.key});

  @override
  State<Level1AIMLNN> createState() => _Level1AIMLNNState();
}

class _Level1AIMLNNState extends State<Level1AIMLNN> {
  int currentStage = 0; // 0: Learning, 1: Stage 1 Quiz, 2: Stage 2 Quiz, 3: Stage 3 Quiz
  int currentQuestionIndex = 0;
  int score = 0;
  bool showResult = false;
  String? selectedCharacter;
  bool isCorrect = false;

  // Interactive stage 2 variables
  bool isDragging = false;
  String? draggedTask;
  String? targetTechnology;
  bool showLearningSection = true;

  final List<Question> stage1Questions = [
    Question(
      'Face Recognition',
      'ai',
      'AI - Artificial Intelligence can recognize faces and identify people.',
    ),
    Question(
      'Self-Driving Cars',
      'ai',
      'AI - Artificial Intelligence enables cars to drive autonomously.',
    ),
    Question(
      'Email Spam Filter',
      'ml',
      'ML - Machine Learning learns patterns to filter spam emails.',
    ),
  ];

  final List<Question> stage2Questions = [
    Question(
      'Recommendation Systems',
      'ml',
      'ML - Machine Learning suggests products based on your preferences.',
    ),
    Question(
      'Image Classification',
      'nn',
      'NN - Neural Networks excel at classifying images into categories.',
    ),
    Question(
      'Speech Recognition',
      'nn',
      'NN - Neural Networks can understand and transcribe spoken words.',
    ),
  ];

  final List<Question> stage3Questions = [
    Question(
      'Virtual Assistants',
      'ai',
      'AI - Artificial Intelligence powers virtual assistants like Siri and Alexa.',
    ),
    Question(
      'Fraud Detection',
      'ml',
      'ML - Machine Learning detects unusual patterns to identify fraud.',
    ),
    Question(
      'Language Translation',
      'nn',
      'NN - Neural Networks translate text between different languages.',
    ),
  ];

  List<Question> get currentQuestions {
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
        title: const Text('Level 1: What is AI/ML/NN?'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.lightBlue],
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
                    ] else ...[
                      _buildStageHeader(),
                      const SizedBox(height: 20),
                      _buildQuestionCard(),
                      const SizedBox(height: 20),
                      _buildCharacterCards(),
                      const SizedBox(height: 20),
                      if (showResult) _buildResultCard(),
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
                currentStage == 0 
                    ? 'Learning Section'
                    : 'Stage $currentStage - Question ${currentQuestionIndex + 1}/${currentQuestions.length}',
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
            value: currentStage == 0 
                ? 0.0
                : (currentQuestionIndex + 1) / currentQuestions.length,
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
            'Understanding AI, ML, and Neural Networks',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // AI Section
          _buildConceptCard(
            '🤖 Artificial Intelligence (AI)',
            'AI is the broader field of creating machines that can perform tasks that typically require human intelligence. Think of AI as the "brain" that can think, learn, and solve problems like humans do.',
            [
              '• Problem-solving and decision making',
              '• Understanding natural language',
              '• Recognizing patterns and objects',
              '• Learning from experience',
              '• Playing games and strategic thinking',
            ],
            Colors.blue,
            Icons.psychology,
            [
              '🎮 Gaming: AI opponents in chess, Go, and video games',
              '🗣️ Chatbots: Customer service and virtual assistants',
              '🤖 Robotics: Autonomous robots and self-driving cars',
              '🎯 Expert Systems: Medical diagnosis and financial analysis',
            ],
          ),
          const SizedBox(height: 16),
          
          // ML Section
          _buildConceptCard(
            '📚 Machine Learning (ML)',
            'ML is a subset of AI that focuses on algorithms that can learn and make predictions from data. It\'s like teaching a computer to learn from examples, just like how you learn from experience.',
            [
              '• Learns patterns from data',
              '• Improves performance over time',
              '• Makes predictions and classifications',
              '• Adapts to new information',
              '• Finds hidden patterns in data',
            ],
            Colors.green,
            Icons.school,
            [
              '📧 Email: Spam detection and smart replies',
              '🛒 Shopping: Product recommendations on Amazon',
              '🎵 Music: Spotify\'s personalized playlists',
              '📱 Social Media: Facebook\'s news feed algorithm',
            ],
          ),
          const SizedBox(height: 16),
          
          // NN Section
          _buildConceptCard(
            '🧠 Neural Networks (NN)',
            'Neural Networks are a specific type of ML algorithm inspired by how human brains work. They consist of interconnected nodes (neurons) that process information in layers, similar to how our brain processes information.',
            [
              '• Interconnected nodes (neurons)',
              '• Processes information in layers',
              '• Learns complex patterns',
              '• Excels at image and speech recognition',
              '• Mimics human brain structure',
            ],
            Colors.purple,
            Icons.memory,
            [
              '📸 Image Recognition: Google Photos, facial recognition',
              '🎤 Speech Recognition: Siri, Alexa, Google Assistant',
              '🌐 Language Translation: Google Translate',
              '🎨 Creative AI: DALL-E, Midjourney image generation',
            ],
          ),
          const SizedBox(height: 20),
          
          // Relationship Diagram
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'How They Relate:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRelationshipBox('AI', 'Largest', Colors.blue),
                    const Icon(Icons.arrow_forward, color: Colors.blue),
                    _buildRelationshipBox('ML', 'Subset', Colors.green),
                    const Icon(Icons.arrow_forward, color: Colors.blue),
                    _buildRelationshipBox('NN', 'Tool', Colors.purple),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptCard(String title, String description, List<String> points, Color color, [IconData? icon, List<String>? examples]) {
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
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
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
          if (examples != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Real-World Examples:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...examples.map((example) => Padding(
                    padding: const EdgeInsets.only(left: 4, top: 2),
                    child: Text(
                      example,
                      style: TextStyle(
                        fontSize: 11,
                        color: color.withOpacity(0.8),
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

  Widget _buildRelationshipBox(String label, String subtitle, Color color) {
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

  Widget _buildQuestionCard() {
    final question = currentQuestions[currentQuestionIndex];
    
    // For stage 2, show interactive drag-and-drop interface
    if (currentStage == 2) {
      return _buildInteractiveQuestionCard(question);
    }
    
    // For other stages, show regular question card
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
            'Match this task with the correct technology:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Text(
              question.task,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveQuestionCard(Question question) {
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
            '🎯 Drag the task to the correct technology:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Draggable task
          Draggable<String>(
            data: question.task,
            onDragStarted: () => _startDrag(question.task),
            onDragEnd: (_) => _endDrag(),
            feedback: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question.task,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            childWhenDragging: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: Text(
                question.task,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  const Text(
                    '📋 Task to Match:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.task,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '⬇️ Drag me to the correct technology below',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildCharacterCard('ai', 'AI', '🤖', 'Artificial Intelligence')),
          const SizedBox(width: 12),
          Expanded(child: _buildCharacterCard('ml', 'ML', '📚', 'Machine Learning')),
          const SizedBox(width: 12),
          Expanded(child: _buildCharacterCard('nn', 'NN', '🧠', 'Neural Network')),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(String character, String name, String emoji, String description) {
    final isSelected = selectedCharacter == character;
    final isCorrectAnswer = currentQuestions[currentQuestionIndex].correctAnswer == character;
    final isTarget = targetTechnology == character;
    
    Color backgroundColor = Colors.white;
    if (showResult) {
      if (isCorrectAnswer) {
        backgroundColor = Colors.green;
      } else if (isSelected && !isCorrectAnswer) {
        backgroundColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = Colors.blue.withOpacity(0.3);
    } else if (isTarget && isDragging) {
      backgroundColor = Colors.orange.withOpacity(0.3);
    }

    Widget cardContent = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.blue : 
                 isTarget && isDragging ? Colors.orange : 
                 Colors.grey.withOpacity(0.3),
          width: isSelected || (isTarget && isDragging) ? 3 : 1,
        ),
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
            emoji,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: showResult && isCorrectAnswer ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: showResult && isCorrectAnswer ? Colors.white70 : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    // For stage 2, wrap with drop target
    if (currentStage == 2 && !showResult) {
      return DragTarget<String>(
        onWillAccept: (data) => data != null,
        onAccept: (data) => _onDrop(character),
        onMove: (details) => _onDragOver(character),
        builder: (context, candidateData, rejectedData) {
          return GestureDetector(
            onTap: () => _selectCharacter(character),
            child: cardContent,
          );
        },
      );
    }

    // For other stages, use regular gesture detector
    return GestureDetector(
      onTap: showResult ? null : () => _selectCharacter(character),
      child: cardContent,
    );
  }

  Widget _buildResultCard() {
    final question = currentQuestions[currentQuestionIndex];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (currentStage == 0) ...[
            Expanded(
              child: ElevatedButton(
                onPressed: _startQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
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
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
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
                onPressed: selectedCharacter != null ? _checkAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
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
        ],
      ),
    );
  }

  void _startQuiz() {
    setState(() {
      currentStage = 1;
      currentQuestionIndex = 0;
      score = 0;
    });
  }

  void _selectCharacter(String character) {
    setState(() {
      selectedCharacter = character;
    });
  }

  void _checkAnswer() {
    final question = currentQuestions[currentQuestionIndex];
    final correct = selectedCharacter == question.correctAnswer;
    
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
        selectedCharacter = null;
        isCorrect = false;
        // Reset interactive stage 2 variables
        isDragging = false;
        draggedTask = null;
        targetTechnology = null;
      });
    } else {
      _nextStage();
    }
  }

  // Interactive stage 2 methods
  void _startDrag(String task) {
    setState(() {
      isDragging = true;
      draggedTask = task;
    });
  }

  void _endDrag() {
    setState(() {
      isDragging = false;
      draggedTask = null;
      targetTechnology = null;
    });
  }

  void _onDragOver(String technology) {
    setState(() {
      targetTechnology = technology;
    });
  }

  void _onDrop(String technology) {
    final question = currentQuestions[currentQuestionIndex];
    final correct = technology == question.correctAnswer;
    
    setState(() {
      isDragging = false;
      draggedTask = null;
      targetTechnology = null;
      selectedCharacter = technology;
      showResult = true;
      isCorrect = correct;
      if (correct) score += 15; // Bonus points for interactive stage
    });
  }

  void _nextStage() {
    if (currentStage < 3) {
      setState(() {
        currentStage++;
        currentQuestionIndex = 0;
        showResult = false;
        selectedCharacter = null;
        isCorrect = false;
      });
    } else {
      _completeLevel();
    }
  }

  void _completeLevel() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.completeLevel(0, score);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Congratulations! You\'ve completed Level 1!'),
            const SizedBox(height: 16),
            Text('Your Score: $score points'),
            const SizedBox(height: 16),
            const Text('You\'ve earned the "AI Explorer" badge! 🏅'),
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

  Widget _buildOverviewDiagram() {
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
            '🎯 AI Technology Relationship',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          // Improved Circular Venn Diagram
          SizedBox(
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // AI Circle (largest) - Outer ring
                Positioned(
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🤖', style: TextStyle(fontSize: 28)),
                          SizedBox(height: 4),
                          Text(
                            'AI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Artificial\nIntelligence',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ML Circle (medium) - Middle ring
                Positioned(
                  top: 25,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('📚', style: TextStyle(fontSize: 24)),
                          SizedBox(height: 4),
                          Text(
                            'ML',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Machine\nLearning',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // NN Circle (smallest) - Inner ring
                Positioned(
                  top: 50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.25),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🧠', style: TextStyle(fontSize: 20)),
                          SizedBox(height: 4),
                          Text(
                            'NN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Neural\nNetworks',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: Colors.purple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: const Text(
              'NN ⊂ ML ⊂ AI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Neural Networks are part of Machine Learning,\nwhich is part of Artificial Intelligence',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDiagramBox(String title, String emoji, String description, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 10,
              color: color.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
              color: Colors.blue,
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
        return 'Basic AI and ML Applications';
      case 2:
        return 'Advanced ML and NN Applications';
      case 3:
        return 'Complex AI Systems';
      default:
        return '';
    }
  }
}

class Question {
  final String task;
  final String correctAnswer;
  final String explanation;

  Question(this.task, this.correctAnswer, this.explanation);
} 