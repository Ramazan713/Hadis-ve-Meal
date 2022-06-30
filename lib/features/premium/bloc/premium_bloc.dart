import 'dart:async';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_extended_enum.dart';
import 'package:hadith/features/premium/bloc/premium_event.dart';
import 'package:hadith/features/premium/bloc/premium_state.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PremiumBloc extends Bloc<IPremiumEvent, PremiumState> {
  PremiumBloc() :
        super(const PremiumState(status: DataStatusExtended.initial,
          isPremium: false, subscriptionItems: [])) {

    on<PremiumEventInit>(_onInit, transformer: restartable());
    on<PremiumEventLoadProducts>(_onLoadProducts, transformer: restartable());
    on<PremiumEventMakePurchase>(_onMakePurchase, transformer: restartable());
    on<PremiumEventRestorePurchase>(_onRestorePurchase,transformer: restartable());

    add(PremiumEventInit());
  }

  final InAppPurchase _inAppPurchase=InAppPurchase.instance;

  void _checkAndCompletePurchase(PurchaseDetails purchaseDetail)async{
    if (purchaseDetail.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchaseDetail);
    }
  }

  Future<void> _onInit(PremiumEventInit event, Emitter<PremiumState> emit) async {
    await _inAppPurchase.isAvailable();
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;

    try {
      PremiumState resultState;
      await emit.forEach<List<PurchaseDetails>>(purchaseUpdated,
          onData: (purchaseDetails) {
        for (var purchaseDetail in purchaseDetails) {
          switch (purchaseDetail.status) {
            case PurchaseStatus.error:
              resultState = state.copyWith(
                  status: DataStatusExtended.error,
                  error: purchaseDetail.error?.message ?? "");
              break;
            case PurchaseStatus.pending:
              resultState = state.copyWith(status: DataStatusExtended.loading);
              break;
            case PurchaseStatus.purchased:
            case PurchaseStatus.restored:
              resultState = state.copyWith(
                  status: DataStatusExtended.success, isPremium: true);
              break;
            case PurchaseStatus.canceled:
              resultState = state.copyWith(status: DataStatusExtended.success);
              break;
          }
          _checkAndCompletePurchase(purchaseDetail);
          return resultState;
        }
        return state.copyWith(
            status: DataStatusExtended.success, isPremium: false);
      },onError: (e,trace){
        return state.copyWith(status: DataStatusExtended.error, isPremium: false,
            error: e.toString());
          });
    } catch (e) {
      emit(state.copyWith(status: DataStatusExtended.error,
          isPremium: false,
          error: e.toString()));
    }
  }

  void _onLoadProducts(PremiumEventLoadProducts event, Emitter<PremiumState> emit) async {

    emit(state.copyWith(status: DataStatusExtended.loading));
    final bool isAvailable = await _inAppPurchase.isAvailable();

    if(isAvailable){
      const Set<String> _kIds = <String>{'premium_monthly_hadiths'};
      final ProductDetailsResponse response =await _inAppPurchase.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {
        emit(state.copyWith(status: DataStatusExtended.error,
            error: "Bir şeyler yanlış gitti"));
      }
      List<ProductDetails> products = response.productDetails;

      emit(state.copyWith(status: DataStatusExtended.success,subscriptionItems: products));
    }else{
      emit(state.copyWith(status: DataStatusExtended.error,
          error: "Ödeme platformu kullanılabilir değil"));
    }

  }

  void _onMakePurchase(
      PremiumEventMakePurchase event, Emitter<PremiumState> emit) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: event.productDetails);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _onRestorePurchase(
      PremiumEventRestorePurchase event, Emitter<PremiumState> emit) async {
    try{
      if(await _inAppPurchase.isAvailable()){
        await _inAppPurchase.restorePurchases();
      }
    }catch(e){
    }
  }



}
