import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/side_menu.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:keeps_note_clone/utils/side_menu_helper.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
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
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ),
          title: Text(S.of(context).archive_title),
        ),
        drawer: SideMenu(),
        body: Center(
          child: CustomText(
              S.of(context).no_notes_found_msg
          ),
        ),
      ),
    );
  }
}
