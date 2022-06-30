import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_extended_enum.dart';
import 'package:hadith/features/premium/bloc/premium_event.dart';
import 'package:hadith/features/premium/bloc/premium_state.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/material.dart';
import 'package:hadith/features/premium/bloc/premium_bloc.dart';
import 'package:hadith/features/premium/widgets/premium_feature_item.dart';
import 'package:hadith/features/premium/widgets/premium_subscription_item.dart';
import '../../screens/setting_screen.dart';

void showPremiumDia(BuildContext context){

  final ScrollController scrollController=ScrollController();

  final featureItems=[
    const PremiumFeatureItem(featureName: "Reklamsız")
  ];

  final premiumBloc=context.read<PremiumBloc>();
  premiumBloc.add(PremiumEventLoadProducts());

  showModalBottomSheet(context: context,
      isScrollControlled: true,
      builder: (context){
        return DraggableScrollableSheet(
          minChildSize: 0.4,
          initialChildSize: 0.7,
          expand: false,
            builder: (context, scrollControllerDraggable) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(alignment: Alignment.centerRight,
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close,size: 30,
                  color: Theme.of(context).textTheme.headline5?.color,)),),
                Expanded(
                  child: CustomScrollView(
                    shrinkWrap: true,
                    controller: scrollControllerDraggable,
                    slivers: [
                      SliverList(delegate: SliverChildListDelegate(
                        [
                          Text("Premium",textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,),
                          const SizedBox(height: 19,),
                          Text("Özellikler",
                          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.w700
                          )),
                          const SizedBox(height: 5,),
                          ListView.builder(
                            controller: scrollController,
                            itemBuilder: (context, index) {
                            return featureItems[index];
                          },itemCount: featureItems.length,shrinkWrap: true,),
                          const SizedBox(height: 29,),

                          BlocBuilder<PremiumBloc,PremiumState>(
                              buildWhen: (oldState,newState){
                                if(newState.isPremium){
                                  Navigator.popAndPushNamed(context, SettingScreen.id);
                                  return false;
                                }
                                return true;
                              },
                              builder: (context,state){

                            if(state.status==DataStatusExtended.loading){
                              return const  Center(child: CircularProgressIndicator(),);
                            }
                            if(state.status==DataStatusExtended.error){
                              return Center(child: Column(
                                children: [
                                  const Icon(Icons.error_outline,size: 50,),
                                  const SizedBox(height: 5,),
                                  Text(state.error!=""?state.error:"Bazı hatalar oluştu",style: Theme.of(context).textTheme.subtitle1,)
                                ],
                              ),);
                            }

                            final items=state.subscriptionItems;
                            return  ListView.builder(
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item=items[index];
                                String? trialContent;
                                if(item is GooglePlayProductDetails){
                                  final daysPattern=RegExp("\\d+D");
                                  final match=daysPattern.firstMatch(item.skuDetails.freeTrialPeriod);
                                  final result=item.skuDetails.freeTrialPeriod.substring(match?.start??0,match?.end);
                                  trialContent=result!=''?result.split("D")[0]:null;

                                }
                                return PremiumSubscriptionItem(
                                    title: item.title.split("(")[0], price: item.price,trialContent: trialContent, onClick: (){
                                      premiumBloc.add(PremiumEventMakePurchase(productDetails: item));

                                });
                              },itemCount: items.length,);
                          }),
                          const SizedBox(height: 37,),
                          ListView(
                            controller: scrollController,
                            shrinkWrap: true,
                            children:const [
                              Text("* Ücretsiz denemeye katıldıysanız,tekrardan ücretsiz denemeye katılamazsınız. Aboneliği satın alırken fatura döneminin başlama tarihine bakınız"),
                              Text("* Abonelikler iptal edilmediği takdirde; aylık abonelik için aylık, yıllık abonelik için yıllık olarak yenilenir"),
                              Text("* Aboneliği iptal ederseniz,geçerli fatura döneminde geri ödeme yapılmaz ve bu süre boyunca  abonelik devam eder. Fatura dönemi sonunda,üyelik sona erer ve ödeme tekrar alınmaz"),
                              Text("* Google Play'de abonelikler bölümünden aboneliğinizi iptal edebilir veya tekrardan devam ettirebilirsiniz"),
                            ],
                          )
                        ]
                      ))
                    ],
                  ),
                )
              ],
            ),
          );
        });
      }
  );
}