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
      margin: EdgeInsets.all(16),

      decoration: BoxDecoration(
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(description),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DateFormat("dd/MM/yyyy HH:mm").format(created)),
              FilledButton(
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
