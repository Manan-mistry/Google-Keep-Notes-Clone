// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Could not connect to the internet.`
  String get internet_msg {
    return Intl.message(
      'Could not connect to the internet.',
      name: 'internet_msg',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get try_again {
    return Intl.message(
      'Try Again',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `something went wrong.`
  String get err_msg {
    return Intl.message(
      'something went wrong.',
      name: 'err_msg',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection.`
  String get err_internet {
    return Intl.message(
      'No internet connection.',
      name: 'err_internet',
      desc: '',
      args: [],
    );
  }

  /// `Google Keep`
  String get google_keep_title {
    return Intl.message(
      'Google Keep',
      name: 'google_keep_title',
      desc: '',
      args: [],
    );
  }

  /// `Delete Note`
  String get delete_note {
    return Intl.message(
      'Delete Note',
      name: 'delete_note',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this note?`
  String get delete_note_message {
    return Intl.message(
      'Are you sure you want to delete this note?',
      name: 'delete_note_message',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Enter Notes`
  String get note_hint {
    return Intl.message(
      'Enter Notes',
      name: 'note_hint',
      desc: '',
      args: [],
    );
  }

  /// `Enter Title`
  String get title_hint {
    return Intl.message(
      'Enter Title',
      name: 'title_hint',
      desc: '',
      args: [],
    );
  }

  /// `Add Note`
  String get add_note {
    return Intl.message(
      'Add Note',
      name: 'add_note',
      desc: '',
      args: [],
    );
  }

  /// `Edit Note`
  String get edit_note {
    return Intl.message(
      'Edit Note',
      name: 'edit_note',
      desc: '',
      args: [],
    );
  }

  /// `Create New Label`
  String get create_new_label {
    return Intl.message(
      'Create New Label',
      name: 'create_new_label',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get enter_note {
    return Intl.message(
      'Note',
      name: 'enter_note',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get enter_title {
    return Intl.message(
      'Title',
      name: 'enter_title',
      desc: '',
      args: [],
    );
  }

  /// `Labels`
  String get label_title {
    return Intl.message(
      'Labels',
      name: 'label_title',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings_title {
    return Intl.message(
      'Settings',
      name: 'settings_title',
      desc: '',
      args: [],
    );
  }

  /// `Trash`
  String get trash_title {
    return Intl.message(
      'Trash',
      name: 'trash_title',
      desc: '',
      args: [],
    );
  }

  /// `Help & Feedback`
  String get help_feedback_title {
    return Intl.message(
      'Help & Feedback',
      name: 'help_feedback_title',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive_title {
    return Intl.message(
      'Archive',
      name: 'archive_title',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder_title {
    return Intl.message(
      'Reminder',
      name: 'reminder_title',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get add_image {
    return Intl.message(
      'Add Image',
      name: 'add_image',
      desc: '',
      args: [],
    );
  }

  /// `Take photo`
  String get take_photo {
    return Intl.message(
      'Take photo',
      name: 'take_photo',
      desc: '',
      args: [],
    );
  }

  /// `Choose image`
  String get choose_image {
    return Intl.message(
      'Choose image',
      name: 'choose_image',
      desc: '',
      args: [],
    );
  }

  /// `No notes with this label`
  String get no_notes_for_label_msg {
    return Intl.message(
      'No notes with this label',
      name: 'no_notes_for_label_msg',
      desc: '',
      args: [],
    );
  }

  /// `Edit Label`
  String get edit_label {
    return Intl.message(
      'Edit Label',
      name: 'edit_label',
      desc: '',
      args: [],
    );
  }

  /// `Delete Label`
  String get delete_label {
    return Intl.message(
      'Delete Label',
      name: 'delete_label',
      desc: '',
      args: [],
    );
  }

  /// `We'll delete this label and remove it from all of your Keep notes. Your notes won't be deleted.`
  String get delete_label_message {
    return Intl.message(
      'We\'ll delete this label and remove it from all of your Keep notes. Your notes won\'t be deleted.',
      name: 'delete_label_message',
      desc: '',
      args: [],
    );
  }

  /// `No Matching Notes`
  String get no_matching_notes_msg {
    return Intl.message(
      'No Matching Notes',
      name: 'no_matching_notes_msg',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete_title {
    return Intl.message(
      'Delete',
      name: 'delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Less`
  String get less {
    return Intl.message(
      'Less',
      name: 'less',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Edited {time}`
  String edited_at_msg(Object time) {
    return Intl.message(
      'Edited $time',
      name: 'edited_at_msg',
      desc: '',
      args: [time],
    );
  }

  /// `Collaborator`
  String get collaborator_title {
    return Intl.message(
      'Collaborator',
      name: 'collaborator_title',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share_title {
    return Intl.message(
      'Share',
      name: 'share_title',
      desc: '',
      args: [],
    );
  }

  /// `No notes with this label yet`
  String get no_notes_found_msg {
    return Intl.message(
      'No notes with this label yet',
      name: 'no_notes_found_msg',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
