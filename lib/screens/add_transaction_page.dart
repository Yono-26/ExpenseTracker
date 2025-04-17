import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:stacked/stacked.dart';
import '../constants/constants.dart';
import '../models/transaction.dart';
import '../view_models/add_transaction_provider.dart';

class TransactionPage extends StatelessWidget {
  final String transactionType;
  final Transaction? existingTransaction;

  const TransactionPage({
    super.key,
    required this.transactionType,
    this.existingTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddTransactionProvider>.reactive(
      viewModelBuilder: () => AddTransactionProvider(),
      onViewModelReady: (viewModel) {
        if (existingTransaction != null) {
          viewModel.amountController.text = existingTransaction!.amount.toString();
          viewModel.descriptionController.text = existingTransaction!.description;
          viewModel.dateController.text = existingTransaction!.date;
          viewModel.selectedCategory = existingTransaction!.category;
        }
      },
      builder: (context, addTransactionProvider, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white, size: 28),
            title: Text(
              "$transactionType Details",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.purple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: addTransactionProvider.selectedCategory,
                    hint: const Text("Select Category"),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        addTransactionProvider.setCategory(newValue);
                      }
                    },
                    items: (transactionType == Strings.income
                        ? incomeDropDownListData
                        : expenseDropDownListData)
                        .map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.category),
                    ),
                    validator: (value) =>
                    value == null ? "Please select a category" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addTransactionProvider.amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: Strings.amount,
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter an amount";
                      }
                      if (double.tryParse(value) == null || double.parse(value) <= 0) {
                        return "Enter a valid amount";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addTransactionProvider.descriptionController,
                    decoration: const InputDecoration(
                      labelText: Strings.description,
                      prefixIcon: Icon(Icons.description),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Please enter a description" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: addTransactionProvider.dateController,
                    decoration: const InputDecoration(
                      labelText: Strings.date,
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, addTransactionProvider),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Please select a date" : null,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveTransaction(context, addTransactionProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectDate(BuildContext context, AddTransactionProvider provider) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      provider.setDate("${picked.year}-${picked.month}-${picked.day}");
    }
  }

  void _saveTransaction(BuildContext context, AddTransactionProvider provider) async {
    if (provider.selectedCategory == null || provider.amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    double? amount = double.tryParse(provider.amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    final box = Hive.box<Transaction>(Strings.trs);
    final newTransaction = Transaction(
      type: transactionType,
      category: provider.selectedCategory!,
      amount: amount,
      description: provider.descriptionController.text,
      date: provider.dateController.text,
    );

    if (existingTransaction != null) {
      existingTransaction!
        ..type = newTransaction.type
        ..category = newTransaction.category
        ..amount = newTransaction.amount
        ..description = newTransaction.description
        ..date = newTransaction.date;

      await existingTransaction!.save();
    } else {
      box.add(newTransaction);
    }

    Navigator.pop(context);
  }
}
