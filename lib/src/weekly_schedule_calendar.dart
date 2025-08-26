import 'package:flutter/material.dart';

import 'package:weekly_schedule_calendar/src/utils/utils.dart';

/// WeeklyCalendar widget
///
/// inspired by @levitopiary, https://www.threads.com/@levitopiary/post/DNKe6viJ1lS/media
///
/// 1. Swipe left, right to change week.
///
/// 2. Show indicator if event exists.
class WeeklyScheduleCalendar extends StatefulWidget {
  final List<List<dynamic>> weeklySchedules;
  final ValueChanged<DateTime>? onWeekChanged;

  const WeeklyScheduleCalendar({
    super.key,
    required this.weeklySchedules,
    this.onWeekChanged,
  });

  @override
  State<WeeklyScheduleCalendar> createState() => _WeeklyScheduleCalendar();
}

class _WeeklyScheduleCalendar extends State<WeeklyScheduleCalendar> {
  final DateTime _today = DateTime.now().date();
  late DateTime _selected;
  late DateTime _sunday;

  int get _selectedWeekday => _selected.weekday % 7;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selected = _today;
    _sunday = _today.subtract(Duration(days: _today.weekday));
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

      widget.onWeekChanged?.call(_sunday);
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
                                  widget.weeklySchedules[index].isNotEmpty
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
                  widget.weeklySchedules[_selected.weekday % 7].isNotEmpty
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
                                  widget
                                      .weeklySchedules[_selected.weekday %
                                          7][index]
                                      .subject,
                                ),
                                subtitle: Text(
                                  widget
                                      .weeklySchedules[_selected.weekday %
                                          7][index]
                                      .duration,
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
