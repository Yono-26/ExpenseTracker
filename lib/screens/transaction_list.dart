import 'package:expense_tracker/constants/constants.dart';
import 'package:expense_tracker/screens/add_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../view_models/transaction_list_provider.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  void showFilterDialog(BuildContext context) {
    final transactionList = Provider.of<TransactionListProvider>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.today),
                title: Text("Today"),
                onTap: () => applyFilter(context, transactionList, 1),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text("Yesterday"),
                onTap: () => applyFilter(context, transactionList, 2),
              ),
              ListTile(
                leading: Icon(Icons.event_note),
                title: Text("Last 15 Days"),
                onTap: () => applyFilter(context, transactionList, 15),
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text("Last 30 Days"),
                onTap: () => applyFilter(context, transactionList, 30),
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text("Last 60 Days"),
                onTap: () => applyFilter(context, transactionList, 60),
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text("Last 90 Days"),
                onTap: () => applyFilter(context, transactionList, 90),
              ),
            ],
          );
        });
  }

  void applyFilter(BuildContext context, TransactionListProvider provider, int days) {
    provider.applyDateFilter(days);
    Navigator.pop(context);
  }

  void showSortDialog(BuildContext context) {
    final transactionList = Provider.of<TransactionListProvider>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.arrow_upward),
                title: Text('Ascending (Oldest to Newest)'),
                onTap: () => applySort(context, transactionList, "asc"),
              ),
              ListTile(
                leading: Icon(Icons.arrow_downward),
                title: Text('Descending (Newest to Oldest)'),
                onTap: () => applySort(context, transactionList, "desc"),
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Sort by Income'),
                onTap: () => applySort(context, transactionList, Strings.income),
              ),
              ListTile(
                leading: Icon(Icons.money_off),
                title: Text('Sort by Expense'),
                onTap: () => applySort(context, transactionList, Strings.expense),
              ),
            ],
          );
        });
  }

  void applySort(BuildContext context, TransactionListProvider provider, String type) {
    provider.applySortFilter(type);
    Navigator.pop(context);
  }

  void editTransaction(BuildContext context, Transaction transaction) async {
    final transactionList = Provider.of<TransactionListProvider>(context, listen: false);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TransactionPage(
              transactionType: transaction.type,
              existingTransaction: transaction,
            )));
    transactionList.fetchTransactions();
  }

  void deleteTransaction(BuildContext context, Transaction transactionToDelete) {
    final transactionList = Provider.of<TransactionListProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final box = Hive.box<Transaction>('transactions');
                box.delete(transactionToDelete.key);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Transaction Deleted Successfully")),
                );

                Navigator.pop(context);
                transactionList.fetchTransactions(); // Refresh the list
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransactionListProvider>.reactive(
        viewModelBuilder: () => TransactionListProvider(),
        onViewModelReady: (viewModel) => viewModel.init(),
        builder: (context, transactionListProvider, child) => Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white, size: 28),
            title: const Text(
              "Transactions",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'DMSerifDisplay',
              ),
            ),
            backgroundColor: Colors.purple,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () => showFilterDialog(context),
                        icon: Icon(Icons.filter_list_alt, size: 35)),
                    IconButton(
                        onPressed: () => showSortDialog(context),
                        icon: Icon(Icons.sort, size: 35)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactionListProvider.filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionListProvider.filteredTransactions[index];
                    return ListTile(
                      title: Text(transaction.category),
                      subtitle: Text(transaction.date),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editTransaction(context, transaction),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteTransaction(context, transaction),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
