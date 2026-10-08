import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:flutter/material.dart';

class GridViewCard extends StatefulWidget {
  final Note note;

  const GridViewCard({super.key, required this.note});


  @override
  State<GridViewCard> createState() => _GridViewCardState();
}

class _GridViewCardState extends State<GridViewCard> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        width: (size.width - 40) / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.bgColor,
          border: Border.all(color: AppColor.white.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.note.title.isNotEmpty)
                Text(
                  widget.note.title,
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColor.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500
                  ),
                ),
              if (widget.note.title.isNotEmpty && widget.note.note.isNotEmpty)
                const SizedBox(
                  height: 6,
                ),
              if (widget.note.note.isNotEmpty)
                Text(
                    widget.note.note,
                    style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: AppColor.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500
                    )
                ),
            ],
          ),
        ),
      ),
    );
  }
}
