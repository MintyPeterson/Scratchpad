import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scratchpad/text_localisations.dart';

/// Defines the items for the [NotesPage] overflow menu.
enum NotesPageOverflowMenu { copy, paste, removeEmptyLines, trimWhitespace }

/// A widget that provides a notes page.
///
/// The notes pages allows the user to enter plain text using the keyboard.
class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

/// The logic and internal state for [NotesPage].
class _NotesPageState extends State<NotesPage> {
  late FocusNode textFieldFocusNode;

  final textFieldController = TextEditingController();

  Future<File?> get _textFieldFile async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return File(
        '${directory.path}${Platform.pathSeparator}.scratchpad${Platform.pathSeparator}notes.txt');
    } on MissingPluginException {
      // Do nothing. The environment does not support writing files to disk
      // using the path_provider package.
      return null;
    }
  }

  void _onTextFieldChanged() {
    _writeTextFile(textFieldController.text);
  }

  void _writeTextFile(String contents) async {
    final file = await _textFieldFile;
    if (file == null) {
      return;
    }
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(contents, flush: true);
  }

  Future<String> _readTextFile() async {
    final file = await _textFieldFile;
    if (file?.existsSync() == true) {
      return file?.readAsString() ?? Future(() => '');
    }
    return Future(() => '');
  }

  @override
  void initState() {
    super.initState();

    textFieldFocusNode = FocusNode();

    _readTextFile().then((value) {
      textFieldController.text = value;

      // Move the cursor to the end of the text field.
      textFieldController.selection = TextSelection.fromPosition(
        TextPosition(offset: textFieldController.text.length));

      textFieldController.addListener(_onTextFieldChanged);
    });
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    textFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextLocalisations.of(context).title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(TextLocalisations.of(context).clearScratchpadTitle),
                content: Text(
                  TextLocalisations.of(context).clearScratchpadDescription),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      textFieldFocusNode.requestFocus();
                      Navigator.pop(context);
                    },
                    child: Text(TextLocalisations.of(context).cancelButton),
                  ),
                  TextButton(
                    onPressed: () {
                      textFieldController.clear();
                      textFieldFocusNode.requestFocus();
                      Navigator.pop(context);
                    },
                    child: Text(TextLocalisations.of(context).clearButton),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<NotesPageOverflowMenu>(
            onSelected: (NotesPageOverflowMenu item) {
              switch (item) {
                case NotesPageOverflowMenu.copy:
                  {
                    Clipboard.setData(
                      ClipboardData(text: textFieldController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(TextLocalisations.of(context)
                        .notesCopiedMessage)),
                    );
                  }
                  break;
                case NotesPageOverflowMenu.paste:
                  {
                    Clipboard.getData('text/plain').then((value) {
                      String text = value?.text ?? '';
                      if (textFieldController.text.isNotEmpty) {
                        textFieldController.text =
                          textFieldController.text + text;
                      } else {
                        textFieldController.text = text;
                      }
                    });
                  }
                  break;
                case NotesPageOverflowMenu.removeEmptyLines:
                  {
                    // Remove empty lines and those that only contain whitespace.
                    textFieldController.text = textFieldController.text
                      .replaceAll(RegExp(r'^[ \t]*\n', multiLine: true), '');
                  }
                  break;
                case NotesPageOverflowMenu.trimWhitespace:
                  {
                    // Remove start and end spacing.
                    textFieldController.text = textFieldController.text
                      .replaceAll(RegExp(r'^ +| +$', multiLine: true), '');
                    // Replace multiple spaces with a single space.
                    textFieldController.text = textFieldController.text
                      .replaceAll(RegExp(r' +', multiLine: true), ' ');
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<NotesPageOverflowMenu>>[
                PopupMenuItem<NotesPageOverflowMenu>(
                  enabled: false,
                  textStyle: const TextStyle(fontSize: 14.0),
                  child: Text(TextLocalisations.of(context).clipboardMenuItem),
                ),
                PopupMenuItem<NotesPageOverflowMenu>(
                  value: NotesPageOverflowMenu.copy,
                  child: Text(TextLocalisations.of(context).copyMenuItem),
                ),
                PopupMenuItem<NotesPageOverflowMenu>(
                  value: NotesPageOverflowMenu.paste,
                  child: Text(TextLocalisations.of(context).pasteMenuItem),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<NotesPageOverflowMenu>(
                  enabled: false,
                  textStyle: const TextStyle(fontSize: 14.0),
                  child:Text(
                    TextLocalisations.of(context).formattingMenuItem),
                ),
                PopupMenuItem<NotesPageOverflowMenu>(
                  value: NotesPageOverflowMenu.removeEmptyLines,
                  child: Text(TextLocalisations.of(context)
                    .removeEmptyLinesMenuItem),
                ),
                PopupMenuItem<NotesPageOverflowMenu>(
                  value: NotesPageOverflowMenu.trimWhitespace,
                  child: Text(
                    TextLocalisations.of(context).trimWhitespaceMenuItem),
                ),
              ]
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: TextField(
              controller: textFieldController,
              decoration: const InputDecoration.collapsed(hintText: ''),
              autofocus: true,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              focusNode: textFieldFocusNode,
            ),
          ),
        ),
        onTap: () => textFieldFocusNode.requestFocus(),
      ),
    );
  }
}
