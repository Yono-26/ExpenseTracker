import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddTransactionProvider extends BaseViewModel {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? selectedCategory;

  void setCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setDate(String date) {
    dateController.text = date;
    notifyListeners();
  }

  void clearFields() {
    selectedCategory = null;
    amountController.clear();
    descriptionController.clear();
    dateController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

}

