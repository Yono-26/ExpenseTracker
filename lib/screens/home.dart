import 'package:expense_tracker/screens/add_transaction_page.dart';
import 'package:expense_tracker/screens/transaction_list.dart';
import 'package:expense_tracker/view_models/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:expense_tracker/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<TransactionProvider>(context, listen: false).init(this);
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransactionProvider>.nonReactive(
      viewModelBuilder: ()=> Provider.of<TransactionProvider>(context),
      onViewModelReady: (viewModel)=> viewModel.init(this),
      builder: (context, transactionProvider, child){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.purple,
            centerTitle: true,
            title: const Text(
              Strings.exp_tracker,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'DMSerifDisplay',
                color: Colors.white,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(Strings.total_in,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('₹${transactionProvider.totalIncome.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.green)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(Strings.total_exp,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('₹${transactionProvider.totalExpense.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      Strings.recent_trs,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListScreen()));
                      },
                      child: const Text(Strings.see_all),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: transactionProvider.recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactionProvider.recentTransactions[index];
                    return ListTile(
                      title: Text(transaction.category),
                      subtitle: Text(transaction.description),
                      trailing: Text('₹${transaction.amount.toString()}'),
                      leading: Icon(
                        getCategory(transaction.category),
                        color: transaction.type == Strings.income
                            ? Colors.green
                            : Colors.red,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionBubble(
            items: <Bubble>[
              Bubble(
                title: Strings.income,
                iconColor: Colors.white,
                bubbleColor: Colors.green,
                icon: Icons.attach_money,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                onPress: () async {
                  transactionProvider.animationController.reverse();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionPage(transactionType: Strings.income),
                    ),
                  );
                  transactionProvider.fetchTransactions(); // Refresh after adding
                },
              ),
              Bubble(
                title: Strings.expense,
                iconColor: Colors.white,
                bubbleColor: Colors.red,
                icon: Icons.money_off,
                titleStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                onPress: () async {
                  transactionProvider.animationController.reverse();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionPage(transactionType: Strings.expense),
                    ),
                  );
                  transactionProvider.fetchTransactions();
                },
              ),
            ],
            animation: transactionProvider.animation,
            onPress: () => transactionProvider.animationController.isCompleted
                ? transactionProvider.animationController.reverse()
                : transactionProvider.animationController.forward(),
            backGroundColor: Colors.purple,
            iconColor: Colors.white,
            iconData: Icons.menu,
          ),
        );
      },
    );
  }
}
