import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hadith/features/bottom_nav/bloc/bottom_nav_state.dart';
import 'package:hadith/features/bottom_nav/widget/tab_navigator.dart';
import 'package:hadith/features/premium/bloc/premium_bloc.dart';
import 'package:hadith/features/premium/bloc/premium_event.dart';
import 'package:hadith/utils/ad_util.dart';
import '../../features/premium/bloc/premium_state.dart';
import 'bloc/bottom_nav_bloc.dart';

class BottomNavBar extends StatefulWidget {
  static const id = "BottomNavBarScreen";
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with WidgetsBindingObserver{
  int _selectedIndex = 1;
  AndroidDeviceInfo? androidInfo;

  BannerAd? bannerAd;

  String _currentPage = "Page2";
  List<String> pageKeys = ["Page1", "Page2", "Page3"];
  static final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Page1": GlobalKey<NavigatorState>(),
    "Page2": GlobalKey<NavigatorState>(),
    "Page3": GlobalKey<NavigatorState>(),
  };

  void _selectTab(String tabItem, int index) {

    if (tabItem == _currentPage) {
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }


  void initAdWidget(){

    var releaseStr = androidInfo?.version.release;
    final int? release=int.tryParse(releaseStr??"");
    if(release!=null&&release<=9&&bannerAd!=null) {
      return;
    }
    bannerAd = BannerAd(
      adUnitId: AdUtil.bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad){

      }),
    );
    bannerAd?.load();
  }

  Widget getBottomNavWidget(bool isCollapsed) {
    return isCollapsed
        ? const SizedBox.shrink()
        : BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.search), label: "Arama"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: "Ana Sayfa"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.view_list), label: "Liste")
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              _selectTab(pageKeys[index], index);
            },
          );
  }

  Widget generalBottomView(BuildContext context) {

    return BlocBuilder<PremiumBloc,PremiumState>(
      builder: (context, state) {
        if(!state.isPremium){
          initAdWidget();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<BottomNavBloc, BottomNavState>(
              builder: (context, state) {
                final bottomWidget = getBottomNavWidget(state.isCollapsed);

                return state.withAnimation != true ? bottomWidget
                    : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: bottomWidget,
                );
              },
            ),
            bannerAd!=null&&!state.isPremium? SizedBox(
              child: AdWidget(ad: bannerAd!,),
              width: AdSize.banner.width.toDouble(),
              height: AdSize.banner.height.toDouble(),
            ):const SizedBox(),

          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            await _navigatorKeys[_currentPage]?.currentState?.maybePop();
        if (isFirstRouteInCurrentTab != null&&!isFirstRouteInCurrentTab) {
          if (_currentPage != "Page2") {
            _selectTab("Page2", 1);
            return false;
          }
        }
        return false;
      },
      child: Scaffold(
          bottomNavigationBar: generalBottomView(context),
          body: TabNavigator(
            navigatorKey: _navigatorKeys[_currentPage],
            tabItem: _currentPage,
          ),
      ),
    );
  }
  Future<void>loadAsyncItems()async{
    androidInfo=await DeviceInfoPlugin().androidInfo;
  }

  @override
  void initState() {
    loadAsyncItems();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    context.read<PremiumBloc>().add(PremiumEventRestorePurchase());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    bannerAd?.dispose();
    super.dispose();
  }
}
