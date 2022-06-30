

import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_extended_enum.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumState extends Equatable{
  final DataStatusExtended status;
  final bool isPremium;
  final List<ProductDetails>subscriptionItems;
  final String error;

  const PremiumState({required this.status,required this.isPremium,required this.subscriptionItems,
      this.error=""});


  PremiumState copyWith({DataStatusExtended? status,bool? isPremium,
    List<ProductDetails>?subscriptionItems,String? error}){
    return PremiumState(status: status??this.status, isPremium: isPremium??this.isPremium,
        subscriptionItems: subscriptionItems??this.subscriptionItems,error: error??this.error);
  }

  @override
  List<Object?> get props => [status,isPremium,subscriptionItems,error];
  
  String _getItemText(ProductDetails productDetails){
    return "title:${productDetails.title}, price:${productDetails.price}, ${productDetails.description}";
  }
  
  @override
  String toString() {
    return """<State(status:$status, isPremium:$isPremium, error:$error, items: ${subscriptionItems.isEmpty?'':_getItemText(subscriptionItems.first)})>""";
  }

}