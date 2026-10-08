// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:keeps_note_clone/controllers/labels_controller.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/archive_page.dart';
import 'package:keeps_note_clone/screens/edit_label_page.dart';
import 'package:keeps_note_clone/screens/help_feedback_page.dart';
import 'package:keeps_note_clone/screens/reminder_page.dart';
import 'package:keeps_note_clone/screens/settings_page.dart';
import 'package:keeps_note_clone/screens/trash_page.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:keeps_note_clone/utils/side_menu_helper.dart';
import 'package:flutter/material.dart';
import 'package:keeps_note_clone/screens/home_page.dart';
import 'package:state_extended/state_extended.dart';

class LabelsProvider extends ChangeNotifier {
//   final List<String> _labels = [];
//
//   List<String> get labels => _labels;
//
//   void addLabel(String label) {
//     if (!_labels.contains(label)) {
//       _labels.add(label);
//       notifyListeners(); // Notify listeners about the change
//     }
//   }
//
//   void removeLabel(String label) {
//     _labels.remove(label);
//     notifyListeners();
//   }
}

class SideMenu extends StatefulWidget {

  // Private constructor
  const SideMenu._internal();

  // Singleton instance
  static final SideMenu _instance = SideMenu._internal();

  // Factory constructor to return the singleton instance
  factory SideMenu() => _instance;

  @override
  SideMenuState createState() => SideMenuState();

  // Static getter for the state
  static SideMenuState? of(BuildContext context) =>
      context.findAncestorStateOfType<SideMenuState>();
}

class SideMenuState extends StateX<SideMenu> {

  late LabelsController labelsController;
  List<Label> labelsArray = [];

  @override
  void initState() {
    super.initState();
    logPrint("Call Labels array here");
    init();
  }

  void init() async {
    var labels = await labelsController.fetchLabelsFromDB();
    setState(() {
      labelsArray = labels;
    });

    logPrint("Array - ${labelsArray.length}");
  }

  final menuState = MenuState();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final List<Map<String, dynamic>> drawerItems = [
    {'icon': Icons.lightbulb_outlined, 'title': 'Notes', 'screen': HomePage()},
    {'icon': Icons.notifications_none, 'title': 'Reminders', 'screen': ReminderPage()},
    {'icon': Icons.add, 'title': 'Create new label', 'screen': null},
    {'icon': Icons.archive_outlined, 'title': 'Archive', 'screen': ArchivePage()},
    {'icon': Icons.delete_outline, 'title': 'Trash', 'screen': TrashPage()},
    {'icon': Icons.settings_outlined, 'title': 'Settings', 'screen': SettingsPage()},
    {'icon': Icons.help_outline_outlined, 'title': 'Help & Feedback', 'screen': HelpFeedbackPage()},
  ];

  SideMenuState() : super(controller: LabelsController()){
    labelsController = controller as LabelsController;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   labelsProvider = Provider.of<LabelsProvider>(context, listen: false);
  // }

  void addLabel(String label) async {
    // if (!labelsProvider.labels.contains(label)) {
    //   setState(() {
    //     labelsProvider.addLabel(label);
    //   });
    // }
    if (label.isNotEmpty) {
      labelsController.insertLabel(
          Label(title: label, createdDate: DateTime.now()));
      var notes = await labelsController.fetchLabelsFromDB();
      setState(() {
        labelsArray = notes;
      });
    }
    else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(content: Text('Failed to add note', style: TextStyle(color: AppColor.bgColor),), backgroundColor: AppColor.white),
      );
    }
  }

  void removeLabel(Label label) async {
    var success = await labelsController.deleteLabel(label);
    if (success == 1) {
      setState(() {
        labelsArray.removeWhere((listLabel) => listLabel.id == label.id);
      });
    }
  }

  void resetSelectedIndex() {
    setState(() {
      menuState.selectedIndex = 0;
    });
  }

  void _createNewLabel() {
    TextEditingController labelController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColor.bgColor,
          title: Text(S.of(context).create_new_label, style: CustomTheme.secondaryTextStyle.merge(TextStyle(fontWeight: FontWeight.w800))),
          content: TextField(
            style: CustomTheme.secondaryTextStyle,
            controller: labelController,
            decoration: InputDecoration(hintText: "Label name", hintStyle: CustomTheme.secondaryTextStyle),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel, style: CustomTheme.secondaryTextStyle),
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.popUntil(context, ModalRoute.withName('/home'));
              },
            ),
            TextButton(
              child: Text(S.of(context).add, style: CustomTheme.secondaryTextStyle),
              onPressed: () {
                addLabel(labelController.text);
                // Navigator.of(context).pop();
                // if (Platform.isAndroid) {
                  _scaffoldKey.currentState?.closeDrawer();
                // }
                setState(() {
                  menuState.selectedIndex = 0;
                });

                Navigator.pop(context); // Close the drawer


                // Avoid context issues by delaying navigation until after the drawer is closed
                Future.delayed(Duration.zero, () {
                  // Navigator.popUntil(context, ModalRoute.withName('/home'));
                  menuState.selectedIndex = 0;
                });
                setState(() {
                  menuState.selectedIndex = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditLabelScreen() {
    Navigator.of(context).push(
      PageRouteBuilder(
        settings: const RouteSettings(name: Screens.editLabels),
        pageBuilder: (context, animation, secondaryAnimation) {
          return EditLabelPage();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Slide in from right
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    const int labelOffset = 100;

    return Drawer(
      backgroundColor: AppColor.bgColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                physics: labelsController.labelsArray.length > 7 ?
                AlwaysScrollableScrollPhysics() :
                NeverScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: Platform.isAndroid ? 80 : 90,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      margin: const EdgeInsets.only(bottom: 15),
                      alignment: Alignment.bottomLeft,
                      color: AppColor.bgColor,
                      child: Text(
                        S
                            .of(context)
                            .google_keep_title,
                        style: CustomTheme.primaryTextStyle.merge(
                            const TextStyle(fontSize: 24)),
                      ),
                    ),
                    ...drawerItems
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> item = entry.value;

                      if (item['title'] == 'Create new label' && index == 2) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (labelsController.labelsArray.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5),
                                  const Divider(color: AppColor.selectionColor,
                                      thickness: 1,
                                      height: 1),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    margin: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    height: 44,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(S
                                            .of(context)
                                            .label_title, style: TextStyle(
                                            fontSize: 15,
                                            color: AppColor.white.withOpacity(
                                                0.8),
                                            fontWeight: FontWeight.w500)),
                                        TextButton(
                                          onPressed: () {
                                            logPrint('Edit Label');
                                            Navigator.pop(context);
                                            _navigateToEditLabelScreen();
                                          },
                                          child: Text(S
                                              .of(context)
                                              .edit, style: TextStyle(
                                              fontSize: 15,
                                              color: AppColor.white.withOpacity(
                                                  0.8),
                                              fontWeight: FontWeight.w500)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ...labelsController.labelsArray.map((label) {
                                    int index = labelsArray.indexOf(label) +
                                        labelOffset;
                                    return Column(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          decoration: BoxDecoration(
                                            color: menuState.selectedIndex ==
                                                index
                                                ? AppColor.selectionColor
                                                : null,
                                            borderRadius: BorderRadius.circular(
                                                20),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            // Ensures the container's background color is used.
                                            borderRadius: BorderRadius.circular(
                                                20),
                                            // Matches the container's border radius.
                                            child: InkWell(
                                              onTap: () {
                                                if (menuState.selectedIndex ==
                                                    index) {
                                                  Navigator.pop(
                                                      context);
                                                  setState(() {
                                                    menuState.selectedIndex =
                                                        index;
                                                  });
                                                } else {
                                                  setState(() {
                                                    menuState.selectedIndex =
                                                        index;
                                                  });
                                                  logPrint(
                                                      'Index for Label $index');
                                                  _scaffoldKey.currentState
                                                      ?.closeDrawer();
                                                  Navigator.pushNamed(
                                                      context,
                                                      Screens.labelPage,
                                                      arguments: label
                                                  ).then((_) {
                                                    menuState.selectedIndex =
                                                        index;
                                                  });
                                                }
                                              },
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                              child: ListTile(
                                                key: ValueKey(label),
                                                leading: Icon(
                                                    Icons.label_outline_rounded,
                                                    color: menuState
                                                        .selectedIndex == index
                                                        ? AppColor.white
                                                        : AppColor.white
                                                        .withOpacity(0.7),
                                                    size: 25),
                                                title: Text(label.title,
                                                    style: menuState
                                                        .selectedIndex == index
                                                        ? CustomTheme
                                                        .primaryTextStyle
                                                        : CustomTheme
                                                        .secondaryTextStyle),
                                                minTileHeight: 50,
                                                // trailing: IconButton(
                                                //   icon: Icon(Icons.delete_outline_outlined, color: menuState.selectedIndex == index ? AppColor.white : AppColor.white.withOpacity(0.7)),
                                                //   onPressed: () => removeLabel(labelsArray[labelsArray.indexOf(label)]),
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: menuState.selectedIndex == index
                                      ? AppColor.selectionColor
                                      : null,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Material(
                                color: Colors.transparent,
                                // Ensures the container's background color is used.
                                borderRadius: BorderRadius.circular(20),
                                // Matches the container's border radius.
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  // Ensures ripple effect matches the shape.
                                  onTap: () {
                                    Navigator.pop(context);
                                    _navigateToEditLabelScreen();
                                  },
                                  child: ListTile(
                                    leading: Icon(item['icon'],
                                        color: menuState.selectedIndex == index
                                            ? AppColor.white
                                            : AppColor.white.withOpacity(0.7),
                                        size: 25),
                                    title: Text(item['title'],
                                        style: menuState.selectedIndex == index
                                            ? CustomTheme.primaryTextStyle
                                            : CustomTheme.secondaryTextStyle),
                                    minTileHeight: 50,
                                  ),
                                ),
                              ),
                            ),
                            if (labelsController.labelsArray.isNotEmpty)
                              const SizedBox(height: 5),
                            const Divider(color: AppColor.selectionColor,
                                thickness: 1,
                                height: 1),
                            const SizedBox(height: 5)
                          ],
                        );
                      } else {
                        return Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: menuState.selectedIndex == index ? AppColor
                                  .selectionColor : null,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Material(
                            color: Colors.transparent,
                            // Ensures the container's background color is used.
                            borderRadius: BorderRadius.circular(20),
                            // Matches the container's border radius.
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              // Ensures ripple effect matches the shape.
                              onTap: () {
                                if (menuState.selectedIndex == index) {
                                  Navigator.pop(
                                      context); // Close the drawer if the same item is clicked again
                                }
                                else {
                                  Navigator.pop(
                                      context); // Close the drawer and navigate.
                                  setState(() {
                                    menuState.selectedIndex = index;
                                  });
                                  if (item['screen'] != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => item['screen']),
                                    );
                                  }
                                }
                              },
                              child: ListTile(
                                leading: Icon(
                                    item['icon'],
                                    color: menuState.selectedIndex == index ?
                                    AppColor.white :
                                    AppColor.white.withOpacity(0.7),
                                    size: 25
                                ),
                                title: Text(
                                    item['title'],
                                    style: menuState.selectedIndex == index ?
                                    CustomTheme.primaryTextStyle :
                                    CustomTheme.secondaryTextStyle
                                ),
                                minTileHeight: 50,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          );
        })
    );
  }
}