import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/side_menu.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/side_menu_helper.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        appBar: AppBar(
          leading: Builder(
            builder: (context) =>
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
          ),
          title: Text(S.of(context).settings_title),
        ),
        drawer: SideMenu(),
        body: const Center(
          child: CustomText(
              "No notes with this label yet"
          ),
        ),
      ),
    );
  }
}
