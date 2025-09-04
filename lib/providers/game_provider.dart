import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider with ChangeNotifier {
  List<bool> _levelCompletion = List.generate(9, (_) => false);
  List<int> _levelScores = List.generate(9, (_) => 0);
  int _totalScore = 0;
  int _currentLevel = 0;
  

  String? _userEmail;
  String? _userName;
  bool _isLoggedIn = false;

  List<bool> get levelCompletion => _levelCompletion;
  List<int> get levelScores => _levelScores;
  int get totalScore => _totalScore;
  int get currentLevel => _currentLevel;
  

  String? get userEmail => _userEmail;
  String? get userName => _userName;
  bool get isLoggedIn => _isLoggedIn;

  GameProvider() {
    _loadProgress();
    _loadUserData();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    _totalScore = prefs.getInt('totalScore') ?? 0;
    _currentLevel = prefs.getInt('currentLevel') ?? 0;
    
    for (int i = 0; i < 9; i++) {
      _levelCompletion[i] = prefs.getBool('level_${i}_completed') ?? false;
      _levelScores[i] = prefs.getInt('level_${i}_score') ?? 0;
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('userEmail');
    _userName = prefs.getString('userName');
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('totalScore', _totalScore);
    await prefs.setInt('currentLevel', _currentLevel);
    
    for (int i = 0; i < 9; i++) {
      await prefs.setBool('level_${i}_completed', _levelCompletion[i]);
      await prefs.setInt('level_${i}_score', _levelScores[i]);
    }
  }

  void completeLevel(int levelIndex, int score) {
    if (levelIndex >= 0 && levelIndex < 9) {
      _levelCompletion[levelIndex] = true;
      _levelScores[levelIndex] = score;
      _totalScore += score;
      
      if (levelIndex == _currentLevel) {
        _currentLevel = (_currentLevel + 1).clamp(0, 8);
      }
      
      _saveProgress();
      notifyListeners();
    }
  }

  void setCurrentLevel(int level) {
    _currentLevel = level.clamp(0, 8);
    _saveProgress();
    notifyListeners();
  }

  bool isLevelUnlocked(int levelIndex) {
    if (levelIndex == 0) return true;
    return _levelCompletion[levelIndex - 1];
  }

  void resetProgress() async {
    _levelCompletion = List.generate(9, (_) => false);
    _levelScores = List.generate(9, (_) => 0);
    _totalScore = 0;
    _currentLevel = 0;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }


  Future<void> setUser(String email, String name) async {
    _userEmail = email;
    _userName = name;
    _isLoggedIn = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setString('userName', name);
    await prefs.setBool('isLoggedIn', true);
    
    notifyListeners();
  }

  Future<void> logout() async {
    _userEmail = null;
    _userName = null;
    _isLoggedIn = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.setBool('isLoggedIn', false);
    
    notifyListeners();
  }


  Future<void> clearAllData() async {
    _userEmail = null;
    _userName = null;
    _isLoggedIn = false;
    _levelCompletion = List.generate(9, (_) => false);
    _levelScores = List.generate(9, (_) => 0);
    _totalScore = 0;
    _currentLevel = 0;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
} 