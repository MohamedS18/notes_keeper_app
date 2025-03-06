import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notes_keeper_app/controller.dart';
import 'package:notes_keeper_app/notes.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'states.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool toAddNote = false;
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();

  late Future<List<Map<String, dynamic>>> notes;
  List<Notes> notesList = [];

  @override
  void initState() {
    super.initState();
    fetchAndStoreNotes();
  }

  void fetchAndStoreNotes() async {
    List<Notes> updatedNotes = [];
    List<Map<String, dynamic>> data = await Controller.getNotes(
      context.read<States>().username,
    );

    for (var note in data) {
      updatedNotes.add(
        Notes(
          fetchAndStoreNotes: fetchAndStoreNotes,
          id: note["id"],
          title: note["title"],
          description: note["content"],
          created: DateTime.parse(note["lastUpdated"].toString()),
        ),
      );
    }
    setState(() {
      notesList = updatedNotes;
    });
  }

  void showError(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void setToAddNote() {
    setState(() {
      toAddNote = !toAddNote;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (true) {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "asset/icons/logo.svg",
                        width: 30,
                        height: 30,
                        colorFilter:
                            Theme.of(context).brightness == Brightness.dark
                                ? ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                )
                                : ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Notes Keeper",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(fontSize: 30),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<States>().setIsDarkMode();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15),
                        ),
                        child:
                            context.watch<States>().isDarkMode
                                ? Icon(Icons.sunny)
                                : Icon(Icons.nightlight_round),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(15),
                        ),
                        child: Text(
                          context.read<States>().username.isNotEmpty
                              ? context.read<States>().username[0].toUpperCase()
                              : "?",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: notesList,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,

            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                setToAddNote();
              },
            ),
            bottomNavigationBar: BottomAppBar(height: 40),
          ),

          if (toAddNote)
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(30),
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: title,
                                  decoration: InputDecoration(
                                    label: Text("title"),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20.0),
                                TextField(
                                  maxLines: 5,
                                  controller: description,
                                  decoration: InputDecoration(
                                    label: Text("description"),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Transform.translate(
                                    offset: Offset(0, -16),
                                    child: FloatingActionButton.small(
                                      onPressed: () async {
                                        if (title.text.isNotEmpty &&
                                            description.text.isNotEmpty) {
                                          bool res = await Controller.addNote(
                                            context.read<States>().username,
                                            title.text,
                                            description.text,
                                          );
                                          toAddNote = false;
                                          res
                                              ? fetchAndStoreNotes()
                                              : showError("Failed to add");
                                        } else {
                                          showError("Fields Empty");
                                        }
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,

              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
                onPressed: () {
                  setToAddNote();
                },
              ),
              bottomNavigationBar: BottomAppBar(
                height: 40,
                color: Colors.transparent,
              ),
            ),
        ],
      );
    }
  }
}
