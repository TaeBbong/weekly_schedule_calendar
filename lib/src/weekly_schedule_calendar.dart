import 'dart:async';

import 'package:flutter/material.dart';

import 'package:weekly_schedule_calendar/src/utils/utils.dart';
import 'package:weekly_schedule_calendar/src/widgets/defaults/schedule_indicator.dart';
import 'package:weekly_schedule_calendar/src/widgets/defaults/selected_cell_builder.dart';
import 'package:weekly_schedule_calendar/src/widgets/defaults/title_builder.dart';
import 'package:weekly_schedule_calendar/src/widgets/defaults/unselected_cell_builder.dart';

typedef TitleBuilder = Widget Function(BuildContext context, DateTime selected);

typedef UnselectedCellBuilder =
    Widget Function(BuildContext context, DateTime day);
typedef SelectedCellBuilder =
    Widget Function(BuildContext context, DateTime day);
typedef IndicatorBuilder<T> =
    Widget Function(BuildContext context, List<T> schedules);
typedef ScheduleListBuilder<T> =
    Widget Function(BuildContext context, List<T> schedules);

/// WeeklyCalendar widget
///
/// inspired by @levitopiary, https://www.threads.com/@levitopiary/post/DNKe6viJ1lS/media
///
/// 1. Swipe left, right to change week.
///
/// 2. Show indicator if event exists.
class WeeklyScheduleCalendar<T> extends StatefulWidget {
  final DateTime? startDate;
  final List<String> weekdayLabels;
  final FutureOr<List<List<T>>> Function(DateTime sunday) scheduleLoader;
  final TitleBuilder? titleBuilder;
  final Widget Function(BuildContext context)? loadingBuilder;
  final UnselectedCellBuilder? unselectedCellBuilder;
  final SelectedCellBuilder? selectedCellBuilder;
  final IndicatorBuilder? indicatorBuilder;
  final ScheduleListBuilder? scheduleListBuilder;
  final Widget Function(BuildContext context)? emptyScheduleListBuilder;
  final String Function(T schedule)? titleOf;
  final String Function(T schedule)? subtitleOf;

  final Function? onScheduleSelected;

  final double? weekStripHeight;
  final double? eventListHeight;

  final bool showDefaultEventDot;

  const WeeklyScheduleCalendar({
    super.key,
    this.startDate,
    required this.scheduleLoader,
    this.weekdayLabels = Constants.weekdayLabels,
    this.titleBuilder,
    this.loadingBuilder,
    this.unselectedCellBuilder,
    this.selectedCellBuilder,
    this.indicatorBuilder,
    this.scheduleListBuilder,
    this.emptyScheduleListBuilder,
    this.titleOf,
    this.subtitleOf,
    this.onScheduleSelected,
    this.weekStripHeight,
    this.eventListHeight,
    this.showDefaultEventDot = true,
  });

  @override
  State<WeeklyScheduleCalendar<T>> createState() =>
      _WeeklyScheduleCalendar<T>();
}

class _WeeklyScheduleCalendar<T> extends State<WeeklyScheduleCalendar<T>> {
  late DateTime _today;
  late DateTime _selected;
  late DateTime _sunday;

  bool _loading = true;
  List<List<T>> _schedules = List.generate(7, (_) => <T>[]);

  int get _selectedWeekday => _selected.weekday % 7;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final DateTime now = (widget.startDate ?? DateTime.now()).date();
    _today = now;
    _selected = now;
    _sunday = now.subtract(Duration(days: _today.weekday));
    _pageController = PageController(initialPage: 1);
    _loadWeek();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadWeek() async {
    setState(() {
      _loading = true;
      _schedules = List.generate(7, (_) => <T>[]);
    });

    try {
      final List<List> buckets = await widget.scheduleLoader(_sunday);
      if (buckets.length != 7) {
        throw StateError(
          'scheduleLoader must return 7 buckets (Sun..Sat). '
          'Got: ${buckets.length}',
        );
      }

      setState(() {
        _schedules = List.generate(7, (i) => List<T>.from(buckets[i]));
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  DateTime _sundayWithPage(int page) {
    switch (page) {
      case 0:
        return _sunday.subtract(Duration(days: 7));
      case 1:
        return _sunday;
      case 2:
        return _sunday.add(Duration(days: 7));
      default:
        return _sunday;
    }
  }

  void _animateToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  void _goPrevWeek() => _animateToPage(0);
  void _goNextWeek() => _animateToPage(2);

  void _handlePageChanged(int page) {
    if (page == 1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _pageController.jumpToPage(1);

      setState(() {
        _sunday = _sundayWithPage(page);
        _selected = _sunday.add(Duration(days: _selectedWeekday));
        _loadWeek();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child:
                            widget.titleBuilder?.call(context, _selected) ??
                            DefaultTitleBuilder(selected: _selected),
                      ),
                      IconButton(
                        onPressed: _goPrevWeek,
                        icon: Icon(
                          Icons.chevron_left,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      IconButton(
                        onPressed: _goNextWeek,
                        icon: Icon(
                          Icons.chevron_right,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: constraints.maxWidth * 0.3,
                    child: NotificationListener<ScrollEndNotification>(
                      onNotification: (n) {
                        if (n.metrics is PageMetrics) {
                          final double page =
                              _pageController.page ??
                              _pageController.initialPage.toDouble();
                          final int itemCount = 3;
                          final int settled = page.round().clamp(
                            0,
                            itemCount - 1,
                          );
                          _handlePageChanged(settled);
                        }
                        return false;
                      },
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const PageScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, page) {
                          final currentSunday = _sundayWithPage(page);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(7, (int index) {
                              final DateTime day = currentSunday.add(
                                Duration(days: index),
                              );
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  /* Weekday Label */
                                  Text(
                                    widget.weekdayLabels[index],
                                    style: TextStyles.weekdayLabel(context),
                                  ),
                                  SizedBox(height: 15),
                                  /* Date Cell */
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selected = day;
                                      });
                                    },
                                    child:
                                        day == _selected
                                            ? widget.selectedCellBuilder?.call(
                                                  context,
                                                  day,
                                                ) ??
                                                DefaultSelectedCellBuilder(
                                                  day: day,
                                                )
                                            : widget.unselectedCellBuilder
                                                    ?.call(context, day) ??
                                                DefaultUnselectedCellBuilder(
                                                  day: day,
                                                ),
                                  ),
                                  SizedBox(height: 15),
                                  /* Indicator */
                                  _schedules[index].isNotEmpty
                                      ? widget.indicatorBuilder?.call(
                                            context,
                                            _schedules[index],
                                          ) ??
                                          DefaultScheduleIndicator()
                                      : Container(),
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _loading
                      ? Center(child: const CircularProgressIndicator())
                      : _schedules[_selected.weekday % 7].isNotEmpty
                      ? SizedBox(
                        height: constraints.maxWidth * 0.48,
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.separated(
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {},
                                title: Text(
                                  widget.titleOf!(
                                    _schedules[_selected.weekday % 7][index],
                                  ),
                                ),
                                subtitle: Text(
                                  widget.subtitleOf!(
                                    _schedules[_selected.weekday % 7][index],
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 14,
                                ),
                                titleTextStyle: TextStyles.listTitle(context),
                                subtitleTextStyle: TextStyles.listSubtitle(
                                  context,
                                ),
                              );
                            },
                            separatorBuilder:
                                (context, index) =>
                                    const Divider(thickness: 0.3),
                          ),
                        ),
                      )
                      : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
