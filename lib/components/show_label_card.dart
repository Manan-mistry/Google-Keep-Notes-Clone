import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:flutter/material.dart';

class ShowLabelCard extends StatefulWidget {

  final Label label;
  final Function(dynamic) onTapLabel;
  const ShowLabelCard({super.key, required this.label, required this.onTapLabel});

  @override
  State<ShowLabelCard> createState() => _ShowLabelCardState();
}

class _ShowLabelCardState extends State<ShowLabelCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapLabel(widget.label),
      child: Wrap(
          // decoration: BoxDecoration(
          //   color: AppColor.selectionColor.withOpacity(0.3),
          //   borderRadius: BorderRadius.circular(16)
          // ),
          children:[
            DecoratedBox(
              decoration: BoxDecoration(
                  color: AppColor.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
                child: Text(
                  widget.label.title,
                  style: const TextStyle(
                    color: AppColor.white,
                    fontSize: 14
                  ),
                ),
              ),
            ),
        ]
      ),
    );
  }
}
