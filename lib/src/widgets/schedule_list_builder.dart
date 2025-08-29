import 'package:flutter/material.dart';

class ScheduleListBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: constraints.maxWidth * 0.48,
      // child: Container(
      //   padding: EdgeInsets.all(6),
      //   decoration: BoxDecoration(
      //     color: colorScheme.surface,
      //     borderRadius: BorderRadius.circular(10),
      //   ),
      //   child: ListView.separated(
      //     itemCount: 2,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         onTap: () {},
      //         title: Text(
      //           widget.titleOf!(_schedules[_selected.weekday % 7][index]),
      //         ),
      //         subtitle: Text(
      //           widget.subtitleOf!(_schedules[_selected.weekday % 7][index]),
      //         ),
      //         trailing: Icon(Icons.arrow_forward_ios, size: 14),
      //         titleTextStyle: TextStyles.listTitle(context),
      //         subtitleTextStyle: TextStyles.listSubtitle(context),
      //       );
      //     },
      //     separatorBuilder: (context, index) => const Divider(thickness: 0.3),
      //   ),
      // ),
    );
  }
}
