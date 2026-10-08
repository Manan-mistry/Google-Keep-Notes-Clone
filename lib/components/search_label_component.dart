import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/device_helper.dart';
import 'package:flutter/material.dart';

class SearchLabelComponent extends StatefulWidget {
  final String labelTitle;
  final Function(dynamic) onClickComponent;
  final bool isReminder;

  const SearchLabelComponent({super.key, required this.labelTitle, required this.onClickComponent, required this.isReminder});

  @override
  State<SearchLabelComponent> createState() => _SearchLabelComponentState();
}

class _SearchLabelComponentState extends State<SearchLabelComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClickComponent(widget.labelTitle);
      },
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: AppColor.selectionColor.withOpacity(0.5),
                minRadius: DeviceHelper.isTablet(context) ? 38 : 20,
                maxRadius: DeviceHelper.isTablet(context) ? 58 : 50,
                child: Icon(
                  widget.isReminder
                      ? Icons.notifications_none_rounded
                      : Icons.label_outline_rounded,
                  size: DeviceHelper.isTablet(context) ? 60 : 40,
                  color: AppColor.white,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                widget.labelTitle,
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: DeviceHelper.isTablet(context) ? 16 : 14,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        )
    );
  }
}

