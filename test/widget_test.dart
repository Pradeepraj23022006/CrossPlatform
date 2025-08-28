// This is a basic Flutter widget test for the Neural Network Game.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:neural_network_game/main.dart';
import 'package:neural_network_game/providers/game_provider.dart';

void main() {
  testWidgets('Neural Network Game smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => GameProvider(),
        child: const NeuralNetworkGame(),
      ),
    );

    // Verify that the app loads successfully
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify that the login screen is displayed initially
    expect(find.text('Neural Network Game'), findsOneWidget);
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}