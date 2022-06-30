import 'package:flutter/material.dart';

import '../../../features/home/home_screen.dart';
import '../../../features/list/list_screen.dart';
import '../../../features/search/search_page.dart';
import '../routes.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({Key? key,required this.navigatorKey, required this.tabItem}):super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {

    Widget child ;
    if(tabItem == "Page1") {
      child = const SearchPage();
    } else if(tabItem == "Page3") {
      child = const ListScreen();
    } else {
      child = const HomePage();
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {

        if(kRouters.containsKey(routeSettings.name)){
          return MaterialPageRoute(
              settings: RouteSettings(
                  name: routeSettings.name,
                  arguments: routeSettings.arguments
              ),
              builder: (context) => kRouters[routeSettings.name]!.call(context)
          );
        }
        return MaterialPageRoute(
            settings: RouteSettings(
              name: routeSettings.name,
            ),
            builder: (context) => child
        );
      },
    );
  }
}