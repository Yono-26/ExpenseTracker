import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stacked/stacked.dart';
import '../constants/constants.dart';
import '../models/transaction.dart';

class TransactionProvider extends BaseViewModel {
  late AnimationController _animationController;
  late Animation<double> _animation;

  List<Transaction> _transactions = [];
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;

  List<Transaction> get transactions => _transactions;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  List<Transaction> get recentTransactions =>
      _transactions.reversed.take(5).toList();

  AnimationController get animationController => _animationController;
  Animation<double> get animation => _animation;

  void init(TickerProvider vsync) async {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    fetchTransactions();

    // Automatically update when Hive changes
    Hive.box<Transaction>(Strings.trs).listenable().addListener(() {
      fetchTransactions();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void fetchTransactions() {
    final box = Hive.box<Transaction>(Strings.trs);
    final transactions = box.values.toList();

    double income = 0.0;
    double expense = 0.0;

    for (var transaction in transactions) {
      if (transaction.type == Strings.income) {
        income += transaction.amount;
      } else if (transaction.type == Strings.expense) {
        expense += transaction.amount;
      }
    }

    _transactions = transactions;
    _totalIncome = income;
    _totalExpense = expense;

    notifyListeners();
  }

  void addTransaction(Transaction transaction) async {
    final box = Hive.box<Transaction>(Strings.trs);
    await box.add(transaction);
    fetchTransactions(); // Update UI after adding
  }
}
