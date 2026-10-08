import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:flutter/material.dart';

class SelectLabelTile extends StatefulWidget {
  final Label label;
  final bool isSelected; // Add this property to accept initial selection state
  final Function(dynamic) onLabelSelection;

  const SelectLabelTile({
    super.key,
    required this.label,
    required this.isSelected, // Add this to the constructor
    required this.onLabelSelection,
  });

  @override
  State<SelectLabelTile> createState() => _SelectLabelTileState();
}

class _SelectLabelTileState extends State<SelectLabelTile> {
  late bool isCheckedLabel;

  @override
  void initState() {
    super.initState();
    // Set the initial state based on the passed isSelected value
    isCheckedLabel = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.label_outline_rounded, color: AppColor.white),
      title: Text(widget.label.title, style: CustomTheme.primaryTextStyle),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            isCheckedLabel = !isCheckedLabel;
            widget.onLabelSelection(widget.label);
          });
        },
        child: Icon(
          isCheckedLabel ? Icons.check_box : Icons.check_box_outline_blank_outlined,
          color: AppColor.white,
        ),
      ),
    );
  }
}
