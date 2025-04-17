import 'package:flutter/material.dart';

class SaveCardState with ChangeNotifier {
  List<Widget> _saveCard = [];

  List<Widget> get saveCard => _saveCard;

  void addCard(Widget card) {
    saveCard.add(card);
    notifyListeners(); // <- this is important to trigger rebuild
  }

  void removeCard(Widget card) {
    _saveCard.remove(card);
    notifyListeners();
  }
}
