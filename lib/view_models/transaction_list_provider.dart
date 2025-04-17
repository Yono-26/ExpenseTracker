import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../constants/constants.dart';
import '../models/transaction.dart';

class TransactionListProvider extends BaseViewModel {
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];

  List<Transaction> get allTransactions => _allTransactions;
  List<Transaction> get filteredTransactions => _filteredTransactions;


  void fetchTransactions() {
    final box = Hive.box<Transaction>('transactions');
    _allTransactions = box.values.toList();
    _filteredTransactions = List.from(_allTransactions);

    notifyListeners();
  }


  void applyDateFilter(int days) {
    DateTime now = DateTime.now();
    DateTime startDate = days == 1
        ? DateTime(now.year, now.month, now.day)
        : DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));

    _filteredTransactions = _allTransactions.where((transaction) {
      DateTime transactionDate = DateFormat('yyyy-MM-dd').parse(transaction.date);
      return transactionDate.isAfter(startDate.subtract(Duration(days: 1)));
    }).toList();

    notifyListeners();
  }

  // Sort transactions based on type
  void applySortFilter(String sortType) {
    if (sortType == "asc") {
      _filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
    } else if (sortType == "desc") {
      _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
    } else if (sortType == Strings.income) {
      _filteredTransactions = _allTransactions.where((t) => t.type == Strings.income).toList();
    } else if (sortType == Strings.expense) {
      _filteredTransactions = _allTransactions.where((t) => t.type == Strings.expense).toList();
    }

    notifyListeners();
  }

  void init() {
    fetchTransactions();
    notifyListeners();
  }
}
