
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IPremiumEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class PremiumEventInit extends IPremiumEvent{}

class PremiumEventLoadProducts extends IPremiumEvent{}

class PremiumEventRestorePurchase extends IPremiumEvent{}

class PremiumEventMakePurchase extends IPremiumEvent{
  final ProductDetails productDetails;
  PremiumEventMakePurchase({required this.productDetails});
  @override
  List<Object?> get props => [productDetails];
}

