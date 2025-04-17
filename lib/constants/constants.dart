import 'package:flutter/material.dart';

List<String> incomeDropDownListData = <String>[
  "Salary",
  "Business",
  "Freelance",
  "Investment",
  "Other"
];

List<String> expenseDropDownListData = <String>[
  "Food",
  "Grocery",
  "Fuel",
  "Rent",
  "Others"
];

Map<String, IconData> categoryIcons = {
  "Salary": Icons.attach_money,
  "Business": Icons.add_business,
  "Freelance": Icons.paid,
  "Investment": Icons.account_balance,
  "Other": Icons.other_houses,
  "Food": Icons.restaurant,
  "Grocery": Icons.local_grocery_store,
  "Fuel": Icons.motorcycle,
  "Rent": Icons.home,
};

IconData getCategory(String Category) {
  return categoryIcons[Category] ?? Icons.category;
}

class Strings {
  static const String income = "Income";
  static const String expense = "Expense";
  static const String amount = "Amount";
  static const String description = "Description";
  static const String date = "Date";
  static const String trs = "transactions";
  static const String total_in = "Total Income";
  static const String total_exp = "Total Expense";
  static const String recent_trs = "Recent Transactions";
  static const String see_all = "See All";
  static const String exp_tracker = "Expense Tracker";


}
