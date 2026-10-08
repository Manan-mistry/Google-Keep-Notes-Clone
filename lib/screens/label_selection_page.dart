import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:flutter/material.dart';

class LabelSelectionPage extends StatefulWidget {
  final List<Label> labelArray;
  const LabelSelectionPage({super.key, required this.labelArray});

  @override
  State<LabelSelectionPage> createState() => _LabelSelectionPageState();
}

class _LabelSelectionPageState extends State<LabelSelectionPage> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              logPrint("On Click Back");
              Navigator.pop(context);
            },
            icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColor.white
            )
        ),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextField(
              cursorColor: AppColor.white,
              maxLines: 1,
              controller: textEditingController,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1,
                color: AppColor.white,
              ),
              decoration: const InputDecoration(
                  hintStyle: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.normal
                  ),
                  hintText: "Enter label name"
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.zero,
          child: Text(
              "Labels Count - ${widget.labelArray.length}",
              style: const TextStyle(
                  color: AppColor.white
              )
          ),
        ),
      ),
    );
  }
}
