import 'package:hive/hive.dart';

part 'productmodel.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject{

  @HiveField(0)
  late String name;

  @HiveField(1)
  late int amount;

  @HiveField(2)
  late int quantity;

  @HiveField(3)
  late List images;

}