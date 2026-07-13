import 'package:flutter/material.dart';
import '../../../models/book.dart';

/// Book item displayed in the list, with edit and delete actions.
class BookListTile extends StatelessWidget {
  const BookListTile({
    super.key,
    required this.book,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Book book;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.shade50,
          child: Icon(Icons.book_rounded, color: Colors.deepPurple.shade400),
        ),
        title: Text(book.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_rounded, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_rounded, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}