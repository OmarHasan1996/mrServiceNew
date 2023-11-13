import 'package:hive/hive.dart';

import '../boxes.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late List service = [];

  @HiveField(1)
  late List subService = [];

  @HiveField(2)
  late List subServiceDec = [];

  @HiveField(3)
  late Map<String, dynamic> userData = {"":"  "} as Map<String, dynamic>;

  @HiveField(4)
  late Map<String, dynamic> myOrders = new Map<String, dynamic>();

  @HiveField(5)
  late List userInfo = [];

  @HiveField(6)
  late List Address = [];

  @HiveField(7)
  late List order = [];

}
