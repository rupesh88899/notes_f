import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  final String scheduledDate;
  final VoidCallback onDelete;
  const TaskCard({
    super.key,
    required this.color,
    required this.headerText,
    required this.descriptionText,
    required this.scheduledDate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20).copyWith(
        left: 15,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                headerText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onDelete, // Trigger onDelete callback
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 244, 10, 10),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, bottom: 25),
            child: Text(
              descriptionText,
              style: const TextStyle(fontSize: 14),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.brightness_1,
                size: 8,
              ),
              const SizedBox(width: 5),
              Text(
                scheduledDate,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
