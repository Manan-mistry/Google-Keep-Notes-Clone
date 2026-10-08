import 'package:keeps_note_clone/components/select_label_tile.dart';
import 'package:keeps_note_clone/controllers/labels_controller.dart';
import 'package:keeps_note_clone/data/models/label_model.dart';
import 'package:keeps_note_clone/utils/app_theme.dart';
import 'package:keeps_note_clone/utils/color.dart';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:flutter/material.dart';

class LabelSearchDelegate extends SearchDelegate<List<Label>> {

  List<Label> labelsArray = [];
  List<Label> selectedLabels = [];
  bool isFromReminder = false;
  String hintText = "Enter label name";

  LabelSearchDelegate( this.labelsArray, this.selectedLabels, this.isFromReminder);

  @override
  String? get searchFieldLabel => hintText;


  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColor.bgColor,
        iconTheme: IconThemeData(color: AppColor.white),
        toolbarTextStyle: TextStyle(color: AppColor.white),
        titleTextStyle: TextStyle(color: AppColor.white, fontSize: 18),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColor.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: AppColor.white.withOpacity(0.4)),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColor.white),
      onPressed: () {
        logPrint(selectedLabels.length);
        close(context, selectedLabels);
        // Navigator.of(context).pop(selectedLabels);
      },
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    final results =  labelsArray.where((label) =>
        label.title.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return Container(
      color: AppColor.bgColor,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedLabels.contains(results[index]);
          return GestureDetector(
            onTap: () {
              // Handle label selection logic
              if (selectedLabels.contains(results[index])) {
                selectedLabels.remove(results[index]);
              }  else {
                selectedLabels.add(results[index]);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
              child: SelectLabelTile(
                label: results[index],
                isSelected: isSelected,
                onLabelSelection: (label) {
                  logPrint("On Selected Label - ${label.title}");
                  if (selectedLabels.contains(results[index])) {
                    selectedLabels.remove(results[index]);
                  } else {
                    selectedLabels.add(results[index]);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    final suggestions = labelsArray.where((label) => label.title.toLowerCase().contains(query.toLowerCase())).toList();

    return Container(
      color: AppColor.bgColor,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedLabels.contains(suggestions[index]);
          return GestureDetector(
            onTap: () {
              // if (selectedLabels.contains(suggestions[index])) {
              //   selectedLabels.remove(suggestions[index]);
              // } else {
              //   selectedLabels.add(suggestions[index]);
              // }
            },
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
              child: SelectLabelTile(
                label: suggestions[index],
                isSelected: isSelected,
                onLabelSelection: (label) {
                  logPrint("On Selected Label - ${label.title}");
                  if (isSelected) {
                    selectedLabels.remove(suggestions[index]);
                  } else {
                    selectedLabels.removeWhere((label) => label.title == suggestions[index].title);
                    selectedLabels.add(suggestions[index]);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
