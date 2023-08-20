import 'package:flutter/material.dart';

import 'package:share/share.dart';

import 'package:take_notes/models/notes_database.dart';
import 'package:take_notes/widgets/display_notes.dart';
import 'package:take_notes/widgets/bottom_actionbar.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A,
    c8 = 0x3300B1CC,
    c9 = 0xCCFF595E;

/*
* Read all notes stored in database and sort them based on name 
*/
Future<List<Map<String, dynamic>>> readDatabase() async {
  try {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    List<Map> notesList = await notesDb.getAllNotes();
    //await notesDb.deleteAllNotes();
    await notesDb.closeDatabase();
    List<Map<String, dynamic>> notesData =
        List<Map<String, dynamic>>.from(notesList);
    notesData.sort((a, b) => (b['id']).compareTo(a['id']));
    return notesData;
  } catch (e) {
    return [{}];
  }
}

// Home Screen
class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  // Read Database and get Notes
  List<Map<String, dynamic>> notesData = [];
  List<int> selectedNoteIds = [];

  // Render the screen and update changes
  void afterNavigatorPop() {
    setState(() {});
  }

  // Long Press handler to display bottom bar
  void handleNoteListLongPress(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

  // Remove selection after long press
  void handleNoteListTapAfterSelect(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

  // Delete Note/Notes
  void handleDelete() async {
    try {
      NotesDatabase notesDb = NotesDatabase();
      await notesDb.initDatabase();
      for (int id in selectedNoteIds) {
        int result = await notesDb.deleteNote(id);
      }
      await notesDb.closeDatabase();
    } catch (e) {
      print('error');
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
  }

  // Share Note/Notes
  void handleShare() async {
    String content = '';
    try {
      NotesDatabase notesDb = NotesDatabase();
      await notesDb.initDatabase();
      for (int id in selectedNoteIds) {
        dynamic notes = await notesDb.getNotes(id);
        if (notes != null) {
          content = content + notes['title'] + '\n' + notes['content'] + '\n\n';
        }
      }
      await notesDb.closeDatabase();
    } catch (e) {
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
    await Share.share(content.trim(), subject: content.split('\n')[0]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(c6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 46, 140, 248),
        leading: (selectedNoteIds.length > 0
            ? IconButton(
                onPressed: () {
                  setState(() {
                    selectedNoteIds = [];
                  });
                },
                icon: const Icon(
                  Icons.close,
                  color: Color(c5),
                ),
              )
            : const Icon(Icons.note_add_outlined)),
        title: Text(
          (selectedNoteIds.isNotEmpty
              ? ('Selected ${selectedNoteIds.length}/${notesData.length}')
              : 'Note'),
          style: const TextStyle(
            color: const Color(c5),
          ),
        ),
        actions: [
          (selectedNoteIds.isEmpty
              ? Container()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      selectedNoteIds =
                          notesData.map((item) => item['id'] as int).toList();
                    });
                  },
                  icon: const Icon(
                    Icons.done_all,
                    color: Color(c5),
                  ),
                ))
        ],
      ),

      /*
			//Drawer
			drawer: Drawer(
				child: DrawerList(),
			),
			*/

      //Floating Button
      floatingActionButton: (selectedNoteIds.length == 0
          ? FloatingActionButton(
              tooltip: 'New Notes',
              backgroundColor: Color.fromARGB(255, 46, 140, 248),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/notes_edit',
                  arguments: [
                    'new',
                    [{}],
                  ],
                ).then((dynamic value) {
                  afterNavigatorPop();
                });
                return;
              },
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            )
          : null),

      body: FutureBuilder(
          future: readDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              notesData = snapshot.data!;
              return Container(
                margin: const EdgeInsets.only(top: 10),
                child: Stack(
                  children: <Widget>[
                    // Display Notes
                    notesData.isNotEmpty
                        ? AllNoteLists(
                            snapshot.data,
                            this.selectedNoteIds,
                            afterNavigatorPop,
                            handleNoteListLongPress,
                            handleNoteListTapAfterSelect,
                          )
                        : const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Icon(Icons.hourglass_empty_rounded,
                                  color: Color.fromARGB(255, 15, 122, 117),
                                  size: 200),
                            ),
                          ),

                    // Bottom Action Bar when Long Pressed
                    (selectedNoteIds.isNotEmpty
                        ? BottomActionBar(
                            handleDelete: handleDelete,
                            handleShare: handleShare)
                        : Container()),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error found'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(c3),
                ),
              );
            }
          }),
    );
  }
}

// Display all notes
class AllNoteLists extends StatelessWidget {
  final data;
  final selectedNoteIds;
  final afterNavigatorPop;
  final handleNoteListLongPress;
  final handleNoteListTapAfterSelect;

  AllNoteLists(
    this.data,
    this.selectedNoteIds,
    this.afterNavigatorPop,
    this.handleNoteListLongPress,
    this.handleNoteListTapAfterSelect,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          dynamic item = data[index];
          return DisplayNotes(
            item,
            selectedNoteIds,
            (selectedNoteIds.contains(item['id']) == false ? false : true),
            afterNavigatorPop,
            handleNoteListLongPress,
            handleNoteListTapAfterSelect,
          );
        });
  }
}


/*
class AppBarLeading extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Builder(
			builder: (context) => IconButton(
				icon: const Icon(
					Icons.menu,
					color: const Color(c5),
				),
				tooltip: 'Menu',
				onPressed: () => Scaffold.of(context).openDrawer(),
			),
		);
	}
}

class DrawerList extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return ListView(
			children: ListTile.divideTiles(
				context: context,
				tiles: [
					Container(
						padding: EdgeInsets.symmetric(vertical: 16.0),
						child: Text(
							'Super Note',
							textAlign: TextAlign.center,
							style: TextStyle(
								fontSize: 29,
								color: Color(c4),
							),
						),
					),
					DrawerRow(Icons.share, 'Share App'),
					DrawerRow(Icons.settings, 'About'),
				],
			).toList(),
     );
	}
}

class DrawerRow extends StatelessWidget {
	final leadingIcon, title;

	DrawerRow(this.leadingIcon, this.title);

	@override
	Widget build(BuildContext context) {
		return ListTile(
			leading: Icon(
    		leadingIcon,
    		color: Color(c2),
    	),
      title: Text(
      	title,
      	style: TextStyle(
      		color: Color(c3),
      		fontSize: 19,
      	),
      ),
      trailing: Icon(
    		Icons.keyboard_arrow_right,
    		color: Color(c2),
    	),
    	dense: true,
    	onTap: () {},
    	onLongPress: () {},
		);
	}
}
*/