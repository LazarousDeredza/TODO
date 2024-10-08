import 'package:flutter/material.dart';
import 'package:todo_app/data/data.dart';
import 'package:todo_app/data/models/task_priority.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/widgets/widgets.dart';
import 'package:gap/gap.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    this.onCompleted,
    this.onPriorityChanged
  });

  final Task task;

  final Function(bool?)? onCompleted;
  final Function(TaskPriority?)? onPriorityChanged; // Callback for priority change

  @override
  Widget build(BuildContext context) {
    final style = context.textTheme;
    final colors = context.colorScheme;

    final textDecoration =
        task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none;
    final fontWeight = task.isCompleted ? FontWeight.normal : FontWeight.bold;
    final double iconOpacity = task.isCompleted ? 0.3 : 0.5;
    final double backgroundOpacity = task.isCompleted ? 0.1 : 0.3;

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 10),
      child: Row(
        children: [
          CircleContainer(
            borderColor: task.category.color,
            color: task.category.color.withOpacity(backgroundOpacity),
            child: Icon(
              task.category.icon,
              color: task.category.color.withOpacity(iconOpacity),
            ),
          ),
          const Gap(16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: style.titleMedium?.copyWith(
                  fontWeight: fontWeight,
                  fontSize: 20,
                  decoration: textDecoration,
                ),
              ),
              Text(
                task.time,
                style: style.titleMedium?.copyWith(
                  decoration: textDecoration,
                ),
              ),
               Center(
                 child: Text(
                 "Priority",
                  style: style.titleMedium?.copyWith(
                    decoration: textDecoration,
                  ),
                               ),
               ),
               // Radio buttons for priority
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: TaskPriority.values.map((priority) {
                  return Expanded(
                    child: RadioListTile<TaskPriority>(
                      title: Text(priority.name.toUpperCase().substring(0,1)), // Assuming you have a method to capitalize
                      value: priority,
                      groupValue: task.priority,
                      onChanged: (value) {
                        onPriorityChanged?.call(value); // Update priority
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          )),
          Switch(
            value: task.isCompleted, // Current state of the task
            onChanged: onCompleted,
            activeColor: colors.surface, // Color when the switch is on
          ),
        ],
      ),
    );
  }
}
