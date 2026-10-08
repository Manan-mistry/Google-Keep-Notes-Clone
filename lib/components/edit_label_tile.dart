import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:flutter/material.dart';

class EditableLabelTile extends StatefulWidget {
  final Label label;
  final Function(dynamic) onEdit;
  final Function(dynamic) onDelete;
  final bool isEditing;
  final Function(bool) onEditingChanged;

  const EditableLabelTile({
    super.key,
    required this.label,
    required this.onEdit,
    required this.onDelete,
    required this.isEditing,
    required this.onEditingChanged,

  });

  @override
  State<EditableLabelTile> createState() => _EditableLabelTileState();
}

class _EditableLabelTileState extends State<EditableLabelTile> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController(text: widget.label.title);
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EditableLabelTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.label.title != oldWidget.label.title) {
      textEditingController.text = widget.label.title;
      textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length),
      );
    }
    if (widget.isEditing && !oldWidget.isEditing) {
      focusNode.requestFocus();
    }
  }

  void _toggleEdit() {
    if (widget.isEditing) {
      widget.onEdit(Label(
        id: widget.label.id,
        title: textEditingController.text,
        createdDate: widget.label.createdDate,
      ));
    }
    widget.onEditingChanged(!widget.isEditing);
  }

  void _onDelete() {
    setState(() {
      widget.onDelete(widget.label);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children:[
          Divider(thickness: 0.5, color: widget.isEditing ? AppColor.white : Colors.transparent, height: 1),
          ListTile(
            key: ValueKey(widget.label),
            leading: IconButton(
              iconSize: 20,
              icon: Icon(
                widget.isEditing ? Icons.delete_forever : Icons.label_outline_rounded,
                color: AppColor.white,
                size: 20,
              ),
              onPressed: widget.isEditing ? _onDelete : null,
            ),
            title: SizedBox(
                height: 50,
                child: TextField(
                  cursorColor: AppColor.white,
                  onTap: _toggleEdit,
                  focusNode: focusNode,
                  readOnly: !widget.isEditing,
                  maxLines: 1,
                  controller: textEditingController,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1,
                    color: AppColor.white,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Create new label', // Customize this as needed
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 1.4,
                      color: AppColor.white.withOpacity(0.8),
                    ),
                  ),
                )
            ),
            minTileHeight: 50,
            trailing: IconButton(
              iconSize: 20,
              icon: Icon(
                widget.isEditing ? Icons.check : Icons.edit,
                color: AppColor.white,
                size: 20
              ),
              onPressed: _toggleEdit,
            ),
          ),
          Divider(thickness: 0.5, color: widget.isEditing ? AppColor.white : Colors.transparent, height: 1)
        ]
    );
  }
}
