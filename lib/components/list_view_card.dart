import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:flutter/material.dart';

class ListViewCard extends StatefulWidget {
  final Note note;

  const ListViewCard({super.key, required this.note});

  @override
  State<ListViewCard> createState() => _ListViewCardState();
}

class _ListViewCardState extends State<ListViewCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        width: size.width - 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.bgColor,
            border: Border.all(color: AppColor.white.withOpacity(0.2))),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 12, left: 8, right: 8, bottom: 12),
          child: Align(
            alignment: Alignment.centerLeft,
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
                          fontSize: 14,
                          color: AppColor.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500
                      )
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
