import 'package:keeps_note_clone/components/image_widget.dart';
import 'package:keeps_note_clone/components/show_label_card.dart';
import 'package:keeps_note_clone/controllers/labels_controller.dart';
import 'package:keeps_note_clone/controllers/notes_controller.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/data/models/notes_model.dart';
import 'package:keeps_note_clone/generated/l10n.dart';
import 'package:keeps_note_clone/screens/label_selection_page.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/label_search_delegate.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:keeps_note_clone/utils/screens.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:state_extended/state_extended.dart';

class NotesDetailPage extends StatefulWidget {
  final Note? note;
  final String image;

  const NotesDetailPage({super.key, required this.note, required this.image});

  @override
  StateX<NotesDetailPage> createState() => _NotesDetailPageState();
}

class _NotesDetailPageState extends StateX<NotesDetailPage> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late NotesController _controller;
  // List<Label> labels = [Label(id: 1, title: "Added"), Label(id: 2, title: "Aaaa"), Label(id: 3, title: "Deleted Notes Label"), Label(id: 4, title: "ABC"), Label(id: 5, title: "AA"), Label(id: 6, title: "AB"), Label(id: 7, title: "Added"), Label(id: 8, title: "Aaaa"), Label(id: 9, title: "Deleted Notes Label")];
  late List<Label> selectedLabels = [];
  List<Label> labels = [];

  _NotesDetailPageState() : super(controller: NotesController()){
    _controller = controller as NotesController;
  }

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.note;
      getAllLabels();
    }
  }

  void getAllLabels() async {
    labels = await LabelsController().fetchLabelsFromDB();
    var existingLabelsForNotes = await _controller.fetchLabelsForNote(widget.note ?? Note());
    setState(() {
      selectedLabels = existingLabelsForNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.bgColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildFooter(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColor.bgColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () async {
          if (_titleController.text.isNotEmpty || _descriptionController.text.isNotEmpty) {
            if (widget.note == null) {
              // Add a new note
              var title = _titleController.text;
              var note = _descriptionController.text;
              int success = await _controller.insertNoteInDB(
                Note(title: title, note: note, createdDate: DateTime.now())
              );
              if (success != 1) {
                _scaffoldKey.currentState?.showSnackBar(
                  const SnackBar(content: Text('Failed to add note')),
                );
              } else {

              }
            } else {
              Note updatedNote = Note(
                id: widget.note!.id,
                title: _titleController.text.isNotEmpty ? _titleController.text : '',
                note: _descriptionController.text.isNotEmpty ? _descriptionController.text : '',
                createdDate: widget.note?.createdDate,
              );
              if (selectedLabels.isNotEmpty) {
                await _controller.deleteLabelsByNoteId(updatedNote);

                for (var label in selectedLabels) {
                  await _controller.insertLabelsForNote(updatedNote, label);
                }
              }
              bool success = await _controller.updateNoteInDB(updatedNote) == 1 ? true : false;
              if (!success) {
                _scaffoldKey.currentState?.showSnackBar(
                  const SnackBar(content: Text('Failed to update note')),
                );
              }
            }
          }
          Future.delayed(Duration.zero, () {
            Navigator.pop(context, widget.note ?? Note());
          });
        },
        icon: Icon(Icons.arrow_back_rounded, size: 26, color: AppColor.white.withOpacity(0.8)),
      ),
      actions: [
        IconButton(
          onPressed: null,
          icon: Icon(Icons.pin_drop_outlined, color: AppColor.white.withOpacity(0.8), size: 26),
        ),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.notification_add_outlined, color: AppColor.white.withOpacity(0.8), size: 26),
        ),
        IconButton(
          onPressed: () async {
            var success = await _controller.archiveNote(widget.note ?? Note());
            setState(() {
              if (success != 0) {
                Navigator.pop(context, widget.note);
              }
            });
          },
          icon: Icon(Icons.archive_outlined, color: AppColor.white.withOpacity(0.8), size: 26),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      children: [
        if (widget.image.isNotEmpty)
          Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: ImageWidget(image: widget.image)
          ),
        TextField(
          maxLines: null,
          controller: _titleController,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22, color: AppColor.white.withOpacity(0.8)),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).enter_title,
            hintStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 20, color: AppColor.white.withOpacity(0.6)),
          ),
        ),
        TextField(
          maxLines: null,
          controller: _descriptionController,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, height: 1.4, color: AppColor.white.withOpacity(0.8)),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).enter_note,
            hintStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18, height: 1.4, color: AppColor.white.withOpacity(0.6)),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedLabels.map((label) => ShowLabelCard(
            label: label,
            onTapLabel: (tappedLabel) {

              showSearch(
                context: context,
                delegate: LabelSearchDelegate(labels, selectedLabels, false),
              ).then((updatedLabels) {
                if (updatedLabels != null) {
                  setState(() => selectedLabels = updatedLabels);
                }
              });

            }, // Capture tapped label title
          )).toList(),
        )
      ],
    );
  }

  Widget _buildFooter() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 80,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: AppColor.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 3),
        ],
        color: AppColor.bgColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                logPrint("Add List Item here");
                showMoreBottomSheet();
              },
              icon: Icon(Icons.add_box_outlined, size: 22, color: AppColor.white.withOpacity(0.7)),
            ),
            IconButton(
              onPressed: () {
                logPrint("Add Color & Theme here");
              },
              icon: Icon(Icons.color_lens_outlined, size: 22, color: AppColor.white.withOpacity(0.7)),
            ),
            IconButton(
              onPressed: () {
                logPrint("Add Font Style here");
              },
              icon: Icon(Icons.format_underline, size: 22, color: AppColor.white.withOpacity(0.7)),
            ),
            const SizedBox(width: 20),
            Align(
              alignment: Alignment.center,
              child: Text(
                S.of(context).edited_at_msg(DateFormat.Hm().format(DateTime.now())),
                style: TextStyle(fontSize: 12, color: AppColor.white.withOpacity(0.7)),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                logPrint("More Actions here");
                showMoreBottomSheet();
              },
              icon: Icon(Icons.more_vert_outlined, size: 22, color: AppColor.white.withOpacity(0.7)),
            )
          ],
        ),
      ),
    );
  }

  void showMoreBottomSheet(){
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.bgColor,  // Customize background color if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: AppColor.white),
                title: Text(S.of(context).delete_title, style: const TextStyle(color: AppColor.white)),
                onTap: () {
                  logPrint("Delete action");
                  Navigator.pop(context);  // Close the bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined, color: AppColor.white),
                title: Text(S.of(context).share_title, style: const TextStyle(color: AppColor.white)),
                onTap: () {
                  logPrint("Share action");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.label_outline_rounded, color: AppColor.white),
                title: Text(S.of(context).label_title, style: const TextStyle(color: AppColor.white)),
                onTap: () {
                  logPrint("Labels action");
                  Navigator.pop(context);
                  showSearch(context: context, delegate: LabelSearchDelegate(labels, selectedLabels, false)).then((updatedLabels) {
                    if (updatedLabels != null) {
                      setState(() {
                        logPrint(updatedLabels.length);
                        selectedLabels = updatedLabels;
                      });
                    }
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt_outlined, color: AppColor.white),
                title: Text(S.of(context).collaborator_title, style: const TextStyle(color: AppColor.white)),
                onTap: () {
                  logPrint("Collaborator action");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline_outlined, color: AppColor.white),
                title: Text(S.of(context).help_feedback_title, style: const TextStyle(color: AppColor.white)),
                onTap: () {
                  logPrint("Collaborator action");
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
