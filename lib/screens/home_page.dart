import 'package:keeps_note_clone/components/grid_view_card.dart';
import 'package:keeps_note_clone/components/list_view_card.dart';
import 'package:keeps_note_clone/controllers/labels_controller.dart';
import 'package:keeps_note_clone/controllers/notes_controller.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/screens/bottom_tab_view.dart';
import 'package:keeps_note_clone/screens/notes_detail_page.dart';
import 'package:keeps_note_clone/screens/side_menu.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:keeps_note_clone/utils/search_delegate.dart';
import 'package:keeps_note_clone/utils/side_menu_helper.dart';
import 'package:flutter/material.dart';
import 'package:state_extended/state_extended.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  StateX<HomePage> createState() => _HomePageState();
}

class _HomePageState extends StateX<HomePage> {

  bool _toggleView = false;
  final menuState = MenuState();
  late NotesController _notesController;

  List<Note> notes = [];
  _HomePageState() : super(controller: NotesController()){
    _notesController = controller as NotesController;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var notesFromDB = await _notesController.fetchNotesFromDB();
    setState(() {
      notes = notesFromDB;
      menuState.selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      drawer: SideMenu(),
      body:  Stack(
          children: [
            SafeArea(
              child:
              Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: AppColor.cardColor,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      padding: const EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Row(
                            children: [
                              Builder(
                                builder: (context) {
                                  return IconButton(
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    icon: const Icon(Icons.menu, color: AppColor.white),
                                  );
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    var notes = _notesController.notesArray;
                                    var labels = await _notesController.databaseManager.getLabelsFromDB();
                                    showSearch(context: context, delegate: NoteSearchDelegate(notes, labels, false));
                                  },
                                  child: Text(
                                    "Search your notes",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: AppColor.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
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
                              const SizedBox(width: 10),
                              const SizedBox(
                                height: 30,
                                child: CircleAvatar(
                                    backgroundColor: AppColor.white,
                                    child: Icon(Icons.person, size: 20,)
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: _toggleView ?
                        WaterfallFlow.builder(
                          padding: const EdgeInsets.all(5.0),
                          gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemBuilder: (BuildContext c, int index) {
                            return Dismissible(
                              key: ValueKey(notes[index].id),
                              onDismissed: (direction) {
                                var deletedNotes = notes[index];
                                var deletedIndex = index;
                                setState(() {
                                  notes.removeAt(index);
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: const Text('Note Archived'), duration: const Duration(seconds: 3), action: SnackBarAction(label: 'Undo', onPressed: () {
                                  logPrint("Undo Archived Note ${deletedNotes.id} - ${deletedNotes.title}");
                                  setState(() {
                                    notes.insert(deletedIndex, deletedNotes);
                                  });
                                })
                                ));
                              },
                              child: LongPressDraggable<Note>(
                                data: notes[index],
                                feedback: Material(
                                  type: MaterialType.transparency,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColor.selectionColor, width: 3),
                                    ),
                                    padding: EdgeInsets.zero,
                                    child: GridViewCard(
                                      key: ValueKey(notes[index]),
                                      note: notes[index],
                                    ),
                                  ),
                                ),
                                childWhenDragging: Container(),
                                child: DragTarget<Note>(
                                  onAcceptWithDetails: (details) {
                                    setState(() {
                                      final receivedItem = details.data;
                                      final currentItem = notes[index];
                                      notes.remove(receivedItem);
                                      notes.insert(notes.indexOf(currentItem), receivedItem);
                                    });
                                  },
                                  builder: (context, acceptedItems, rejectedItems) {
                                    return GestureDetector(
                                      onTap: () {
                                        _navigateToNoteDetails(notes[index]);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                        child: GridViewCard(
                                          key: ValueKey(notes[index]),
                                          note: notes[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          itemCount: notes.length,
                        ) :
                        ReorderableListView.builder(
                          onReorder: (oldIndex, newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1; // Adjust index if moving item down
                              }
                              final item = notes.removeAt(oldIndex);
                              notes.insert(newIndex, item);
                            });
                          },
                          itemCount: notes.length,
                          itemBuilder: (BuildContext context, int index) {
                            logPrint("Notes Id--${notes[index].id}");
                            return Dismissible(
                              key: ValueKey(notes[index].id),
                              onDismissed: (direction) {
                                var deletedNotes = notes[index];
                                var deletedIndex = index;
                                setState(() {
                                  notes.removeAt(index);
                                });

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: const Text('Note Archived'), duration: const Duration(seconds: 3), action: SnackBarAction(label: 'Undo', textColor: AppColor.white, onPressed: () {
                                  logPrint("Undo Archived Note ${deletedNotes.id} - ${deletedNotes.title}");
                                  setState(() {
                                    notes.insert(deletedIndex, deletedNotes);
                                  });
                                })
                                ));
                              },
                              child: LongPressDraggable<Note>(
                                key: ValueKey(notes[index].id),
                                data: notes[index],
                                feedback: Material(
                                  type: MaterialType.transparency,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColor.selectionColor, width: 3),
                                    ),
                                    padding: EdgeInsets.zero,
                                    child: ListViewCard(
                                      key: ValueKey(notes[index].id),
                                      note: notes[index],
                                    ),
                                  ),
                                ),
                                childWhenDragging: Container(),
                                child: DragTarget<Note>(
                                  onAcceptWithDetails: (DragTargetDetails<Note> details) {
                                    setState(() {
                                      final receivedItem = details.data;
                                      final currentItem = notes[index];
                                      notes.remove(receivedItem);
                                      notes.insert(notes.indexOf(currentItem), receivedItem);
                                    });
                                  },
                                  builder: (context, acceptedItems, rejectedItems) {
                                    return GestureDetector(
                                      onTap: () {
                                        logPrint("On Click Open Details ${notes[index].id}");
                                        _navigateToNoteDetails(notes[index]);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 4),
                                        child: ListViewCard(
                                          key: ValueKey(notes[index].id),
                                          note: notes[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ]
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: CustomTabBar(onNotesChanged: (onValue) {
                  if (onValue) {
                    setState(() {
                      init();
                    });
                  }
                })
            )
          ]
      ),

    );
  }

  void _navigateToNoteDetails(Note note) async {
    Navigator.of(context).push(
      PageRouteBuilder(
        settings: const RouteSettings(name: Screens.notesDetails),
        pageBuilder: (context, animation, secondaryAnimation) {
          return NotesDetailPage(note: note, image: "");
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
    ).then((note) async {
      if (note != null) {
        var updatedNote = await _notesController.fetchNoteById(note);
        setState(() {
          if (updatedNote.id != 0) {
            init();
          }
        });
      }
    });
  }
}
// Expanded(
//   child: Container(
//     margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
//     child: _toggleView ?
//     WaterfallFlow.builder(
//       padding: const EdgeInsets.all(5.0),
//       gridDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 0,
//         mainAxisSpacing: 0,
//       ),
//       itemBuilder: (BuildContext c, int index) {
//         return GridViewCard(note: notes[index]);
//       },
//       itemCount: notes.length,
//     ) :
//     ListView.builder(
//       scrollDirection: Axis.vertical,
//       itemCount: notes.length,
//       itemBuilder: (BuildContext context, int index) {
//         return GestureDetector(
//             onTap: () {
//               Navigator.of(context).push(PageRouteBuilder(
//                 settings: const RouteSettings(name: "/notes-detail"),
//                 pageBuilder: (context, animation, secondaryAnimation) {
//                   return NotesDetailPage(note: notes[index],
//                   //     onNotesUpdated: (updatedNotes) {
//                   //   print("Updated Notes $updatedNotes");
//                   // }
//                   ); // Use suggestions[index] here
//                 },
//                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                   const begin = Offset(1.0, 0.0); // Slide in from right
//                   const end = Offset.zero;
//                   const curve = Curves.ease;
//
//                   var tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
//                   var offsetAnimation = animation.drive(tween);
//
//                   return SlideTransition(
//                     position: offsetAnimation,
//                     child: child,
//                   );
//                 },
//               )
//               );
//             },
//             child: ListViewCard(note: notes[index])
//         );
//       },
//     ),
//   ),
// ),
