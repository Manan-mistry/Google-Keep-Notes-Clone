import 'package:keeps_note_clone/controllers/labels_controller.dart';
import 'package:keeps_note_clone/controllers/notes_controller.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/side_menu.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/search_delegate.dart';
import 'package:keeps_note_clone/utils/side_menu_helper.dart';
import 'package:flutter/material.dart';

class LabelNotesPage extends StatefulWidget {
  final Label? label;
  const LabelNotesPage({super.key, this.label});

  @override
  State<LabelNotesPage> createState() => _LabelNotesPageState();
}

class _LabelNotesPageState extends State<LabelNotesPage> {

  String get labelTitle => widget.label?.title ?? "";
  bool _toggleView = false;
  _LabelNotesPageState();
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
        Navigator.popUntil(context, ModalRoute.withName('/home'));
      },
      child: Scaffold(
        appBar: _getAppBar(),
        drawer: SideMenu(),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                      Icons.label_outline_rounded,
                      color: AppColor.white,
                      size: 100
                  ),
                  const SizedBox(height: 20),
                  Text(S.of(context).no_notes_for_label_msg, style: CustomTheme.primaryTextStyle)
                ]
            )
        ),
      ),
    );
  }

  AppBar _getAppBar() {
   return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      title: Text(labelTitle),
      actions: [
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: GestureDetector(
              onTap: () async{
                  var notes = NotesController().notesArray;
                  var labels = LabelsController().labelsArray;
                await showSearch(context: context, delegate: NoteSearchDelegate(notes, labels, false));
              },
              child: const Icon( Icons.search_rounded, color: AppColor.white)),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _toggleView = !_toggleView;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Icon( _toggleView ? Icons.view_agenda_outlined : Icons.grid_view_outlined, color: AppColor.white),
          ),
        ),
        PopupMenuButton<String>(
          shape: const Border.symmetric(),
          icon: const Icon(Icons.more_vert_outlined),
          color: AppColor.cardColor,
          onSelected: handleClick,
          itemBuilder: (BuildContext context) {
            return {S.of(context).edit_label, S.of(context).delete_label}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Adjust padding as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      child: Text(
                        choice,
                        style: const TextStyle(
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  void handleClick(String value) {
    switch (value) {
      case "Edit Label":
        logPrint('On Click Edit Label');
        break;
      case "Delete Label":
        logPrint('Onclick Delete Label');
        break;
    }
  }
}
