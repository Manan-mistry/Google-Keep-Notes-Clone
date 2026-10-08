import 'package:keeps_note_clone/controllers/notes_controller.dart';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/search_delegate.dart';
import 'package:keeps_note_clone/utils/side_menu_helper.dart';
import 'package:flutter/material.dart';
import 'package:keeps_note_clone/screens/side_menu.dart';
import 'package:state_extended/state_extended.dart';

class ReminderPage extends StatefulWidget {
  const ReminderPage({super.key});

  @override
  StateX<ReminderPage> createState() => _ReminderPageState();
}

class _ReminderPageState extends StateX<ReminderPage> with WidgetsBindingObserver {
  bool _toggleView = false;

  final menuState = MenuState();
  late NotesController _notesController;

  List<Note> notes = [];
  _ReminderPageState() : super(controller: NotesController()){
    _notesController = controller as NotesController;
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
        Navigator.popUntil(context, ModalRoute.withName('/home'));
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: SideMenu(),
        body: const Center(
          child: CustomText(
              'Reminder Page'
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      title: Text(S.of(context).reminder_title),
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () async {
            var notes = _notesController.notesArray;
            var labels = await _notesController.databaseManager.getLabelsFromDB();
            /// TODO:- Share notes with Reminder in the Search Delegate method.
            showSearch(delegate: NoteSearchDelegate(notes, labels, true), context: context);
          },
          child: const SizedBox(
            child: Icon(Icons.search_rounded, color: AppColor.white),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _toggleView = !_toggleView;
            });
          },
          child: SizedBox(
            child: Icon( _toggleView ? Icons.view_agenda_outlined : Icons.grid_view_outlined, color: AppColor.white),
          ),
        ),
        const SizedBox(
          width: 16,
        )
      ],
    );
  }

}
