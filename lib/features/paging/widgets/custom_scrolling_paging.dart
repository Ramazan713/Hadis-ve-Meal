import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_paging_status_enum.dart';
import 'package:hadith/features/paging/bloc/paging_bloc.dart';
import 'package:hadith/features/paging/bloc/paging_event.dart';
import 'package:hadith/features/paging/bloc/paging_state.dart';
import 'package:hadith/features/paging/controller/custom_scrolling_controller.dart';
import 'package:hadith/features/paging/i_paging_loader.dart';
import 'package:hadith/features/paging/my_extractor_glow_behavior.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CustomScrollingPaging<T> extends StatelessWidget {
  final bool Function(CustomPagingState<dynamic>, CustomPagingState<dynamic>)?
      buildWhen;
  final Widget Function(
          BuildContext, int index, dynamic item, CustomPagingState state)
      itemBuilder;
  final void Function(int minPos, int maxPos, CustomPagingState? state)?
      minMaxListener;
  final void Function(bool isScrollUp)? scrollListener;
  late final Widget placeHolderWidget;
  late final Widget itemPlaceHolderWidget;

  final int limitNumber;
  final int forwardValue;
  final int placeHolderCount;
  final int page;
  final bool isPlaceHolderActive;
  final bool isItemLoadingWidgetPlaceHolder;
  final IPagingLoader loader;
  final CustomScrollingController customPagingController;

  CustomScrollingPaging(
      {Key? key,
      this.scrollListener,
      required this.itemBuilder,
      this.buildWhen,
      this.page = 1,
      this.limitNumber = 13,
      this.forwardValue = 1,
      this.placeHolderCount = 1,
      Widget? placeHolderWidget,
      this.isPlaceHolderActive = true,
      required this.loader,
      this.minMaxListener,
      required this.customPagingController,
      this.isItemLoadingWidgetPlaceHolder = false})
      : super(key: key) {
    this.placeHolderWidget = placeHolderWidget ??
        const Center(child: CircularProgressIndicator());
    itemPlaceHolderWidget = isItemLoadingWidgetPlaceHolder
        ? this.placeHolderWidget : const Center(child: CircularProgressIndicator());
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  var min = 0;
  var max = 0;
  var prevMin = 0;
  var prevMax = 0;
  var isScrollUp = true;
  CustomPagingState? lastState;

  Widget getEmptyWidget(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: MyExtractorGlowBehavior(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.post_add,
                size: 150,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Bir şeyler eklemeyi deneyin",
                style: Theme.of(context).textTheme.headline6,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getInitialLoadingWidget() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return placeHolderWidget;
      },
      itemCount: 19,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pagingBloc = context.read<CustomPagingBloc>();
    pagingBloc.setLoader(loader, events: [PagingEventRequestInit()]);
    customPagingController.setBloc(pagingBloc);

    return Stack(
      children: [
        ValueListenableBuilder<Iterable<ItemPosition>>(
            valueListenable: itemPositionsListener.itemPositions,
            builder: (context, positions, child) {
              if (positions.isNotEmpty) {
                if (positions.last.index > positions.first.index) {
                  min = positions.first.index;
                  max = positions.last.index;
                } else {
                  min = positions.last.index;
                  max = positions.first.index;
                }
                if (prevMin != min || prevMax != max) {
                  if ((lastState?.items.length ?? 0) < max) {
                    max = 0;
                  }
                  if (min != -1 && max > 0) {
                    minMaxListener?.call(min, max, lastState);
                  }
                }
                if (min != prevMin) {
                  if (min < forwardValue) {
                    pagingBloc.add(PagingEventAddPrev());
                  } else {
                    if (prevMin > min && !isScrollUp) {
                      //scroll up
                      isScrollUp = true;
                      scrollListener?.call(isScrollUp);
                    }
                    if (prevMin < min && isScrollUp) {
                      // scroll down
                      isScrollUp = false;
                      scrollListener?.call(isScrollUp);
                    }
                  }
                }
                prevMin = min;
                prevMax = max;
              }

              return const SizedBox(
                height: 0,
              );
            }),
        BlocBuilder<CustomPagingBloc, CustomPagingState>(
            buildWhen: (prevState, nextState) {
          if (nextState.items.isNotEmpty &&
              nextState.items.first.runtimeType != T) {
            return false;
          }
          lastState = nextState;
          if (nextState.status == DataPagingStatus.pagingSuccess) {
            if (itemScrollController.isAttached) {
              itemScrollController.jumpTo(index: limitNumber);
            }
          }
          if (nextState.status == DataPagingStatus.setPagingSuccess) {
            if (itemScrollController.isAttached) {
              final pos = (nextState.leftOver ?? 0);
              itemScrollController.jumpTo(
                  index: pos, alignment: nextState.items.length > 10 ? 0.5 : 0);
            }
          }

          return buildWhen?.call(prevState, nextState) ?? true;
        }, builder: (context, state) {

          // for transition between different object type(ex: Hadith=>Verse)
          //otherwise there will be incompatibility between items and give error
          if (state.items.isNotEmpty && state.items.first.runtimeType != T) {
            return getInitialLoadingWidget();
          }

          final items = state.items;
          int itemLen;
          if (isPlaceHolderActive) {
            itemLen = (state.status == DataPagingStatus.prevLoading ||
                    state.status == DataPagingStatus.nextLoading)
                ? items.length + placeHolderCount
                : items.length;
          } else {
            itemLen = items.length;
          }
          if (itemLen == 0) {
            if (state.status == DataPagingStatus.loading) {
              return getInitialLoadingWidget();
            }
            return getEmptyWidget(context);
          }
          return ScrollablePositionedList.builder(
            shrinkWrap: false,
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            itemBuilder: (context, index) {
              if (state.status == DataPagingStatus.loading) {
                return placeHolderWidget;
              }

              if (isPlaceHolderActive) {
                if (state.status == DataPagingStatus.prevLoading) {
                  if (index < placeHolderCount) {
                    return itemPlaceHolderWidget;
                  } else {
                    index = index - placeHolderCount;
                  }
                }

                if (state.status == DataPagingStatus.nextLoading &&
                    itemLen - placeHolderCount <= index) {
                  return itemPlaceHolderWidget;
                }
              }

              if ((index >= items.length - forwardValue) &&
                  state.status != DataPagingStatus.prevLoading &&
                  state.isNext) {
                pagingBloc.add(PagingEventAddNext());
              }
              if (index < 0) {
                return const Text("");
              }
              final item = items[index];

              return itemBuilder.call(context, index, item, state);
            },
            itemCount: itemLen,
          );
        })
      ],
    );
  }
}
