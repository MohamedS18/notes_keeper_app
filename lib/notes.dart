import 'package:flutter/material.dart';
import 'package:notes_keeper_app/controller.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'states.dart';

class Notes extends StatelessWidget {
  final VoidCallback fetchAndStoreNotes;
  final String title, description, id;
  final DateTime created;
  Notes({
    super.key,
    required this.fetchAndStoreNotes,
    required this.id,
    required this.title,
    required this.description,
    required this.created,
  });

  @override
  Widget build(BuildContext context) {
    void showError(message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16), // Adds spacing inside the container

      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900] // 🌙 Dark mode color
                : Colors.white, // Optional background color
        borderRadius: BorderRadius.circular(10), // Optional rounded corners
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // ✅ Correct title
          ),
          SizedBox(height: 8), // Adds spacing
          Text(description), // ✅ Regular text
          SizedBox(height: 12), // Adds spacing before row
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // ✅ Spreads content evenly
            children: [
              Text(DateFormat("dd/MM/yyyy HH:mm").format(created)),
              FilledButton(
                // key:ValueKey(id),
                onPressed: () async {
                  bool res = await Controller.deleteNote(
                    context.read<States>().username,
                    id,
                  );
                  print(res);
                  res ? fetchAndStoreNotes() : showError("Deletion failed");
                },
                child: Text("Delete"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
