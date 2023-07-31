import 'package:flutter/material.dart';

import 'package:share/share.dart';

import 'package:take_notes/models/note.dart';
import 'package:take_notes/models/notes_database.dart';
import 'package:take_notes/theme/note_colors.dart';
import 'package:take_notes/screens/noto_title_entry.dart';
import 'package:take_notes/screens/node_entry.dart';
import 'package:take_notes/widgets/appBarPopMenu.dart';
import 'package:take_notes/widgets/color_palette.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A;

class NotesEdit extends StatefulWidget {
  final args;

  const NotesEdit(this.args);
  _NotesEdit createState() => _NotesEdit();
}

class _NotesEdit extends State<NotesEdit> {
  String noteTitle = '';
  String noteContent = '';
  String noteColor = 'red';

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _contentTextController = TextEditingController();

  void onSelectAppBarPopupMenuItem(
      BuildContext currentContext, String optionName) {
    switch (optionName) {
      case 'Color':
        handleColor(currentContext);
        break;
      case 'Sort by A-Z':
        handleNoteSort('ascending');
        break;
      case 'Sort by Z-A':
        handleNoteSort('descending');
        break;
      case 'Share':
        handleNoteShare();
        break;
      case 'Delete':
        handleNoteDelete();
        break;
    }
  }

  void handleColor(currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) => ColorPalette(
        parentContext: currentContext,
      ),
    ).then((colorName) {
      if (colorName != null) {
        setState(() {
          noteColor = colorName;
        });
      }
    });
  }

  void handleNoteSort(String sortOrder) {
    List<String> sortedContentList;
    if (sortOrder == 'ascending') {
      sortedContentList = noteContent.trim().split('\n')..sort();
    } else {
      sortedContentList = noteContent.trim().split('\n')
        ..sort((a, b) => b.compareTo(a));
    }
    String sortedContent = sortedContentList.join('\n');
    setState(() {
      noteContent = sortedContent;
    });
    _contentTextController.text = sortedContent;
  }

  void handleNoteShare() async {
    await Share.share(noteContent, subject: noteTitle);
  }

  void handleNoteDelete() async {
    if (widget.args[0] == 'update') {
      try {
        NotesDatabase notesDb = NotesDatabase();
        await notesDb.initDatabase();
        int result = await notesDb.deleteNote(widget.args[1]['id']);
        await notesDb.closeDatabase();
      } catch (e) {
      } finally {
        Navigator.pop(context);
        return;
      }
    } else {
      Navigator.pop(context);
      return;
    }
  }

  void handleTitleTextChange() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  Future<void> _insertNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.insertNote(note);
    await notesDb.closeDatabase();
  }

  Future<void> _updateNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.updateNote(note);
    await notesDb.closeDatabase();
  }

  void handleBackButton() async {
    if (noteTitle.length == 0) {
      // Go Back without saving
      if (noteContent.length == 0) {
        Navigator.pop(context);
        return;
      } else {
        String title = noteContent.split('\n')[0];
        if (title.length > 31) {
          title = title.substring(0, 31);
        }
        setState(() {
          noteTitle = title;
        });
      }
    }
    // Save New note
    if (widget.args[0] == 'new') {
      Note noteObj =
          Note(title: noteTitle, content: noteContent, noteColor: noteColor);
      try {
        await _insertNote(noteObj);
      } catch (e) {
      } finally {
        Navigator.pop(context);
        return;
      }
    }
    // Update Note
    else if (widget.args[0] == 'update') {
      Note noteObj = Note(
          id: widget.args[1]['id'],
          title: noteTitle,
          content: noteContent,
          noteColor: noteColor);
      try {
        await _updateNote(noteObj);
      } catch (e) {
      } finally {
        Navigator.pop(context);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    noteTitle = (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    noteContent = (widget.args[0] == 'new' ? '' : widget.args[1]['content']);
    noteColor = (widget.args[0] == 'new' ? 'red' : widget.args[1]['noteColor']);

    _titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    _contentTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['content']);
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleNoteTextChange);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackButton();
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(NoteColors[this.noteColor]!['l']!),
        appBar: AppBar(
          backgroundColor: Color(NoteColors[this.noteColor]!['b']!),

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: const Color(c1),
            ),
            tooltip: 'Back',
            onPressed: () => handleBackButton(),
          ),

          title: NoteTitleEntry(_titleTextController),

          // actions
          actions: [
            appBarPopMenu(
              parentContext: context,
              onSelectPopupmenuItem: onSelectAppBarPopupMenuItem,
            ),
          ],
        ),
        body: NoteEntry(_contentTextController),
      ),
    );
  }
}
