
import 'package:equatable/equatable.dart';

class ItemLabelModel<T extends Enum> extends Equatable{
  final String label;
  final T item;
  const ItemLabelModel({required this.item,required this.label});

  @override
  List<Object?> get props => [item];
}