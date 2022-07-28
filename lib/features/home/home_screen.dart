import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/common_menu_items.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/features/bottom_nav/bloc/bottom_nav_bloc.dart';
import 'package:hadith/features/bottom_nav/bloc/bottom_nav_event.dart';
import 'package:hadith/features/home/widget/home_book_item.dart';
import 'package:hadith/features/home/widget/home_sub_title_item.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:hadith/features/bottom_nav/widget/bottom_nav_widget_state.dart';
import 'get_home_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BottomNavWidgetState<HomePage>
    with WidgetsBindingObserver {
  final ItemScrollController titleNavItemScrollController =
      ItemScrollController();
  final ItemScrollController homeItemScrollController = ItemScrollController();
  final ItemPositionsListener homeItemPositionListener =
      ItemPositionsListener.create();
  final VisibilityDetectorController visibilityDetectorController =
      VisibilityDetectorController();
  final ValueNotifier<int> titleNavNotifier = ValueNotifier(0);

  final OriginTag originTag = OriginTag.all;
  var visibilityRatio = 80;
  var prevMin = 0;
  var isScrolledTop = false;

  ScrollController nestedViewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  void setVisibilityRatio() {
    visibilityRatio =
        MediaQuery.of(context).orientation == Orientation.portrait ? 80 : 40;
  }

  @override
  Widget buildPage(BuildContext context) {
    setVisibilityRatio();

    final List<HomeBookItem> homeItems =
        getHomeItems(context, originTag: originTag);

    return Scaffold(
      body: SafeArea(
          child: CustomSliverNestedView(context, headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
        return [
          CustomSliverAppBar(
            title: const Text("Hadis ve Ayet"),
            actions: [
              getSettingIcon(context),
            ],
          ),
        ];
      },
              isBottomNavAffected: false,
              scrollController: nestedViewScrollController,
              child: Column(
                children: [
                  ValueListenableBuilder<Iterable<ItemPosition>>(
                      valueListenable: homeItemPositionListener.itemPositions,
                      builder: (context, positions, child) {
                        if (positions.isNotEmpty) {
                          ItemPosition minPos;
                          if (positions.last.index > positions.first.index) {
                            minPos = positions.first;
                          } else {
                            minPos = positions.last;
                          }

                          if (prevMin > minPos.index) {//scroll up
                            context.read<BottomNavBloc>().add(
                                BottomNavChangeVisibility(isCollapsed: false));

                          } else if (prevMin < minPos.index) {//scroll down
                            context.read<BottomNavBloc>().add(BottomNavChangeVisibility(isCollapsed: true));
                            nestedViewScrollController.animateTo(
                              nestedViewScrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500), curve: Curves.decelerate,
                            );
                          }
                          if (minPos.index == 0) {
                            if (minPos.itemLeadingEdge != 0) {
                              isScrolledTop = false;
                            }
                            if (minPos.itemLeadingEdge == 0 &&
                                !isScrolledTop) {
                              isScrolledTop = true;
                              nestedViewScrollController.animateTo(
                                nestedViewScrollController.position.minScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.decelerate,
                              );
                            }
                          }
                          prevMin = minPos.index;
                        }
                        return const SizedBox(
                          height: 0,
                        );
                      }),
                  SizedBox(
                    height: 50,
                    child: ScrollablePositionedList.builder(
                        itemCount: homeItems.length,
                        itemScrollController: titleNavItemScrollController,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ValueListenableBuilder(
                              valueListenable: titleNavNotifier,
                              builder: (context, value, child) {
                                return Center(
                                    child: HomeSubTitleItem(
                                  isSelected: index == value,
                                  title: homeTitles[index],
                                  onTap: () async {
                                    titleNavItemScrollController.scrollTo(index: index,
                                        duration: const Duration(milliseconds: 500));
                                    await homeItemScrollController.scrollTo(index: index,
                                        duration: const Duration(milliseconds: 500));
                                    titleNavNotifier.value = index;
                                  },
                                ));
                              });
                        }),
                  ),
                  Flexible(
                    child: ScrollablePositionedList.builder(
                        itemScrollController: homeItemScrollController,
                        itemPositionsListener: homeItemPositionListener,
                        itemCount: homeItems.length,
                        itemBuilder: (context, index) {
                          return VisibilityDetector(
                              key: Key("my-key-$index"),
                              onVisibilityChanged: (visibilityInfo) async {
                                if (visibilityInfo.visibleFraction * 100 >
                                    visibilityRatio) {
                                  titleNavNotifier.value = index;

                                  await titleNavItemScrollController.scrollTo(
                                      index: index,
                                      duration:
                                          const Duration(milliseconds: 500));
                                }
                              },
                              child: homeItems[index]);
                        }),
                  ),
                ],
              ))),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    setVisibilityRatio();
  }
}
