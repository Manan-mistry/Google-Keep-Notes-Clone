import 'package:keeps_note_clone/components/edit_label_tile.dart';
import 'package:keeps_note_clone/controllers/labels_controller.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/utils/alert_helper.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:keeps_note_clone/utils/side_menu_helper.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';

class EditLabelPage extends StatefulWidget {
  const EditLabelPage({super.key});

  @override
  StateX<EditLabelPage> createState() => _EditLabelPageState();
}

class _EditLabelPageState extends StateX<EditLabelPage> {
  late List<Label> labels = [];
  late LabelsController _labelsController = LabelsController();
  final TextEditingController _textEditingController = TextEditingController();
  bool showEditLabel = false;
  bool onEditLabel = false;
  final FocusNode _focusNode = FocusNode();
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void init() async {
    var labelArray = await _labelsController.fetchLabelsFromDB();
    setState(() {
      labels = labelArray;
    });
  }

  _EditLabelPageState() : super(controller: LabelsController()) {
    _labelsController = controller as LabelsController;
  }

  @override
  Widget build(BuildContext context) {
    final menuState = MenuState();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          menuState.selectedIndex = 0;
          return;
        }
        Navigator.popUntil(context, ModalRoute.withName(Screens.home));
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.bgColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () async {
          Future.delayed(Duration.zero, () {
            Navigator.popUntil(context, ModalRoute.withName(Screens.home));
          });
        },
        icon: Icon(Icons.arrow_back_rounded, size: 26, color: AppColor.white.withOpacity(0.8)),
      ),
      title: Text(S.of(context).edit_label),
      centerTitle: false,
    );
  }

  Widget _buildBody() {
    return Container(
      color: AppColor.bgColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Divider(thickness: 0.5, color: showEditLabel ? AppColor.white : Colors.transparent, height: 1),
          ListTile(
            leading: IconButton(
              onPressed: () {
                setState(() {
                  showEditLabel = !showEditLabel;
                  if (showEditLabel) {
                    editingIndex = null;
                    FocusScope.of(context).requestFocus(_focusNode);
                  }
                });
              },
              icon: showEditLabel
                  ? const Icon(Icons.cancel_outlined, color: AppColor.white, size: 25)
                  : const Icon(Icons.add, color: AppColor.white, size: 26),
            ),
            title: SizedBox(
              height: 50,
              child: TextField(
                cursorColor: AppColor.white,
                onTap: () {
                  setState(() {
                    showEditLabel = !showEditLabel;
                    if (showEditLabel) {
                      editingIndex = null;
                      FocusScope.of(context).requestFocus(_focusNode);
                    }
                  });
                },
                focusNode: _focusNode,
                readOnly: !showEditLabel,
                maxLines: 1,
                controller: _textEditingController,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1,
                  color: AppColor.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Create new label',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.4,
                    color: AppColor.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            minTileHeight: 50,
            trailing: showEditLabel ?
            IconButton(
              onPressed: () async {
                var labelInserted = await _labelsController.insertLabel(Label(title: _textEditingController.text, createdDate: DateTime.now()));
                var updatedLabels = await _labelsController.fetchLabelsFromDB();
                if(labelInserted != 0) {
                  setState(() {
                    labels = updatedLabels;
                    _textEditingController.text = "";
                    showEditLabel = false;
                  });
                }
              },
              icon: const Icon(Icons.check, color: AppColor.white, size: 25),
            ) : null,
          ),
          Divider(thickness: 0.5, color: showEditLabel ? AppColor.white : Colors.transparent, height: 1),
          _buildLabelList()
        ],
      ),
    );
  }
  Widget _buildLabelList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: labels.length,
      itemBuilder: (context, index) {
        var label = labels[index];
        return EditableLabelTile(
          label: label,
          isEditing: index == editingIndex,
          onEditingChanged: (isEditing) {
            setState(() {
              showEditLabel = false;
              editingIndex = isEditing ? index : null;
            });
          },
          onEdit: (updatedLabel) async {
            var labelUpdated = await _labelsController.updateLabel(updatedLabel);
            setState(() {
              if (labelUpdated != 0) {
                labels[index] = updatedLabel;
                editingIndex = null;
              }
            });
          },
          onDelete: (deletedLabel) async {
            AlertHelper.showAlertDialog(context,
                title: S.of(context).delete_label,
                message: S.of(context).delete_label_message,
                positiveAction: S.of(context).delete_title,
                onPositivePressed: () async {
                  var deleteLabel = await _labelsController.deleteLabel(deletedLabel);
                  setState(() {
                    logPrint('Labels before delete at index: $labels -- index $index');
                    if (deleteLabel != 0) {
                      labels.removeAt(index);
                      editingIndex = null;
                      Navigator.pop(context);
                    }
                    logPrint('Labels after delete: $labels');
                  });
                },
                negativeAction: S.of(context).cancel,
                onNegativePressed: () {
                  Navigator.of(context).pop();
                }
            );
          },
        );
      },
    );
  }
}
