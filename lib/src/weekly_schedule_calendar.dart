import 'dart:async';

import 'package:flutter/material.dart';

import 'package:weekly_schedule_calendar/src/utils/utils.dart';

/// WeeklyCalendar widget
///
/// inspired by @levitopiary, https://www.threads.com/@levitopiary/post/DNKe6viJ1lS/media
///
/// 1. Swipe left, right to change week.
///
/// 2. Show indicator if event exists.
class WeeklyScheduleCalendar<T> extends StatefulWidget {
  final DateTime startDate;
  final FutureOr<List<List<T>>> Function(DateTime sunday) scheduleLoader;
  final Widget Function(BuildContext context, List<T> events)? scheduleBuilder;
  final String Function(T schedule)? titleOf;
  final String Function(T schedule)? subtitleOf;

  final double height;
  final double width;

  final TextStyle? weekdayLabelStyle;
  final TextStyle? dayNumberStyle;

  const WeeklyScheduleCalendar({
    super.key,
    required this.startDate,
    required this.scheduleLoader,
    this.scheduleBuilder,
    this.titleOf,
    this.subtitleOf,
    this.height = 0.48,
    this.width = double.infinity,
    this.weekdayLabelStyle,
    this.dayNumberStyle,
  });

  @override
  State<WeeklyScheduleCalendar<T>> createState() =>
      _WeeklyScheduleCalendar<T>();
}

class _WeeklyScheduleCalendar<T> extends State<WeeklyScheduleCalendar<T>> {
  final DateTime _today = DateTime.now().date();
  late DateTime _selected;
  late DateTime _sunday;

  bool _loading = true;
  Object? _error;
  List<List<T>> _schedules = List.generate(7, (_) => <T>[]);

  int get _selectedWeekday => _selected.weekday % 7;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selected = _today;
    _sunday = _today.subtract(Duration(days: _today.weekday));
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
      _error = null;
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
        _error = e;
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
      });

      _loadWeek();
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
                        child: Text(
                          _selected.dateToYearMonth(),
                          style: TextStyles.header(context),
                        ),
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
                                  Text(
                                    Constants.weekdayLabels[index],
                                    style: TextStyles.weekdayLabel(context),
                                  ),
                                  SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selected = day;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            day == _selected
                                                ? colorScheme.primary
                                                : Colors.transparent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        day.day.toString().padLeft(2, '0'),
                                        style:
                                            day == _selected
                                                ? TextStyles.dayNumberSelected(
                                                  context,
                                                )
                                                : TextStyles.dayNumberUnselected(
                                                  context,
                                                ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  _schedules[index].isNotEmpty
                                      ? CircleAvatar(
                                        radius: 4,
                                        backgroundColor: colorScheme.secondary,
                                      )
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
                  _schedules[_selected.weekday % 7].isNotEmpty
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
                              print(widget.titleOf.runtimeType);
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
