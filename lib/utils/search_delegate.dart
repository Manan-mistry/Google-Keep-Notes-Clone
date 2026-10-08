import 'package:keeps_note_clone/components/list_view_card.dart';
import 'package:keeps_note_clone/components/search_label_component.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/notes_detail_page.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/device_helper.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:flutter/material.dart';

class NoteSearchDelegate extends SearchDelegate<String> {

  List<Note> notes = [];
  List<Label> labelsArray = [];
  bool isFromReminder = false;
  String hintText = "Search your notes";

  NoteSearchDelegate(this.notes, this.labelsArray, this.isFromReminder);


  @override
  String? get searchFieldLabel => hintText;

  @override
  ThemeData appBarTheme(BuildContext context) {
    // Set the theme for the search bar and its components
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.bgColor, // Set the background color
        iconTheme: IconThemeData(color: AppColor.white), // Set the icon color
        toolbarTextStyle: TextStyle(color: AppColor.white), // Set the toolbar text color
        titleTextStyle: TextStyle(color: AppColor.white, fontSize: 18), // Set the title text color
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColor.white), // Text color in the search bar
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColor.white), // Hint text color
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // Clear the search query
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: AppColor.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // Back button to close the search
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColor.white),
      onPressed: () {
        close(context, '');
      },

    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes.where((note) =>
        note.title.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return Container(
      color: AppColor.bgColor,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    settings: const RouteSettings(name: Screens.notesDetails),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return NotesDetailPage(
                          note: results[index], image: '');
                    },
                    transitionsBuilder: (context, animation,
                        secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween<Offset>(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                  child: ListViewCard(note: results[index])
              )
          );
        },
      ),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    final suggestions = notes.where((note) => note.title.toLowerCase().contains(query.toLowerCase())).toList();

    if (query.isEmpty) {
      return Container(
        width: deviceSize.width,
        color: AppColor.bgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isFromReminder)
              _ReminderSection(
                  remindersArray: labelsArray, onClickLabel: (reminder) {
                logPrint(
                    "Reminder - ${"Search notes within \"${reminder.title}\"."}");
                showSuggestions(context);
              }),
            _LabelSection(labelsArray: labelsArray, onClickLabel: (label) {
              logPrint("Label - ${"Search notes within \"${label.title}\"."}");
              showSuggestions(context);
            }),
          ],
        ),
      );
    } else {
      if (suggestions.isNotEmpty) {
        return Container(
          color: AppColor.bgColor,
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        settings: const RouteSettings(name: Screens.notesDetails),
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return NotesDetailPage(
                              note: suggestions[index], image: ''
                          );
                        },
                        transitionsBuilder: (context, animation,
                            secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween<Offset>(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                        margin: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                        child: ListViewCard(note: suggestions[index])
                  ),
              );
            },
          ),
        );
      } else {
        return Center(
          child: Container(
            color: AppColor.bgColor,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search, size: 50, color: AppColor.white),
                Text(S.of(context).no_matching_notes_msg, style: const TextStyle(color: AppColor.white, fontSize: 20)),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        );
      }
    }
  }
}

class _LabelSection extends StatefulWidget {
  final List<Label> labelsArray;
  final Function(dynamic) onClickLabel;

  const _LabelSection({required this.labelsArray, required this.onClickLabel});

  @override
  __LabelSectionState createState() => __LabelSectionState();
}

class __LabelSectionState extends State<_LabelSection> {
  bool showMore = false;
  late List<Label> labelsToShow;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var count = DeviceHelper.isTablet(context) ? 4 : 3;
    labelsToShow = widget.labelsArray.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    var count = DeviceHelper.isTablet(context) ? 4 : 3;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 0),
      margin: EdgeInsets.zero,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              Text(
                S.of(context).label_title,
                style: TextStyle(
                  color: AppColor.white,
                  fontWeight: FontWeight.w600,
                  fontSize: DeviceHelper.isTablet(context) ? 14 : 12,
                ),
              ),
              const Spacer(),
              if (widget.labelsArray.length > count)
                TextButton(
                  onPressed: () {
                    setState(() {
                      showMore = !showMore;
                      labelsToShow = showMore
                          ? widget.labelsArray.toList()
                          : widget.labelsArray.take(count).toList();
                    });
                  },
                  child: Text(showMore ? S.of(context).less : S.of(context).more, style: TextStyle(
                   color: AppColor.white,
                   fontWeight: FontWeight.w600,
                   fontSize: DeviceHelper.isTablet(context) ? 14 : 12,
                  )),
                ),
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: DeviceHelper.isTablet(context) ? 4 : 3,
              crossAxisSpacing: 1.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            itemCount: labelsToShow.length,
            itemBuilder: (context, index) {
              return SearchLabelComponent(
                  labelTitle: labelsToShow[index].title,
                  onClickComponent: (label) {
                    widget.onClickLabel(labelsToShow[index]);
                  },
                  isReminder: false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReminderSection extends StatefulWidget {
  final List<Label> remindersArray;
  final Function(dynamic) onClickLabel;

  const _ReminderSection({required this.remindersArray, required this.onClickLabel});

  @override
  _ReminderSectionState createState() => _ReminderSectionState();
}

class _ReminderSectionState extends State<_ReminderSection> {
  bool showMore = false;
  late List<Label> labelsToShow;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var count = DeviceHelper.isTablet(context) ? 4 : 3;
    labelsToShow = widget.remindersArray.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    var count = DeviceHelper.isTablet(context) ? 4 : 3;
    return Wrap(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  S.of(context).reminder_title,
                  style: TextStyle(
                    color: AppColor.white,
                    fontWeight: FontWeight.w600,
                    fontSize: DeviceHelper.isTablet(context) ? 14 : 13,
                  ),
                ),
                const Spacer(),
                if (widget.remindersArray.length > count)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showMore = !showMore;
                        labelsToShow = showMore
                            ? widget.remindersArray.toList()
                            : widget.remindersArray.take(count).toList();
                      });
                    },
                    child: Text(
                        showMore ?
                        S.of(context).less :
                        S.of(context).more,
                        style: TextStyle(
                          color: AppColor.white,
                          fontWeight: FontWeight.w600,
                          fontSize: DeviceHelper.isTablet(context) ? 14 : 12,
                        )
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: DeviceHelper.isTablet(context) ? 4 : 3,
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 1.0,
              ),
              itemCount: labelsToShow.length,
              itemBuilder: (context, index) {
                return SearchLabelComponent(
                  labelTitle: labelsToShow[index].title,
                  onClickComponent: (label) {
                    widget.onClickLabel(labelsToShow[index]);
                  },
                  isReminder: true,
                );
              },
            )
          ],
    );
  }
}
