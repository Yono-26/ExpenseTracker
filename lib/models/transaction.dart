import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {

  @HiveField(0)
  String type;

  @HiveField(1)
  String category;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String description;

  @HiveField(4)
  String date;

  Transaction({required this.type, required this.category, required this.amount, required this.description, required this.date});

}