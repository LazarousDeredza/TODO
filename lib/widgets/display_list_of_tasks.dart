import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/data/data.dart';
import 'package:todo_app/providers/providers.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/widgets/widgets.dart';

class DisplayListOfTasks extends ConsumerWidget {
  const DisplayListOfTasks({
    super.key,
    this.isCompletedTasks = false,
    required this.tasks,
  });
  final bool isCompletedTasks;
  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceSize = context.deviceSize;
    final height =
        isCompletedTasks ? deviceSize.height * 0.25 : deviceSize.height * 0.3;
    final emptyTasksAlert = isCompletedTasks
        ? 'There is no completed task yet'
        : 'There is no task to todo!';

    // return CommonContainer(
    //   height: height,
    //   child: tasks.isEmpty
    //       ? Center(
    //           child: Text(
    //             emptyTasksAlert,
    //             style: context.textTheme.headlineSmall,
    //           ),
    //         )
    //       : ListView.separated(
    //           shrinkWrap: true,
    //           itemCount: tasks.length,
    //           padding: EdgeInsets.zero,
    //           itemBuilder: (ctx, index) {
    //             final task = tasks[index];

    //             return InkWell(
    //               onLongPress: () async {
    //                 await AppAlerts.showAlertDeleteDialog(
    //                   context: context,
    //                   ref: ref,
    //                   task: task,
    //                 );
    //               },
    //               onTap: () async {
    //                 await showModalBottomSheet(
    //                   context: context,
    //                   builder: (ctx) {
    //                     return TaskDetails(task: task);
    //                   },
    //                 );
    //               },
    //               child: TaskTile(
    //                 task: task,
    //                 onCompleted: (value) async {
    //                   await ref
    //                       .read(tasksProvider.notifier)
    //                       .updateTask(task)
    //                       .then((value) {
    //                     AppAlerts.displaySnackbar(
    //                       context,
    //                       task.isCompleted
    //                           ? 'Task incompleted'
    //                           : 'Task completed',
    //                     );
    //                   });
    //                 },
    //               ),
    //             );
    //           },
    //           separatorBuilder: (context, index) => const Divider(
    //             thickness: 1.5,
    //           ),
    //         ),
    // );
 
 return CommonContainer(
  height: height,
  child: tasks.isEmpty
      ? Center(
          child: Text(
            emptyTasksAlert,
            style: context.textTheme.headlineSmall,
          ),
        )
      : ListView.separated(
          shrinkWrap: true,
          itemCount: tasks.length,
          padding: EdgeInsets.zero,
          itemBuilder: (ctx, index) {
            final task = tasks[index];

            return InkWell(
              onLongPress: () async {
                await AppAlerts.showAlertDeleteDialog(
                  context: context,
                  ref: ref,
                  task: task,
                );
              },
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return TaskDetails(task: task);
                  },
                );
              },
              child: TaskTile(
                task: task,
                onCompleted: (value) async {
                  await ref
                      .read(tasksProvider.notifier)
                      .updateTask(task)
                      .then((value) {
                    AppAlerts.displaySnackbar(
                      context,
                      task.isCompleted
                          ? 'Task incompleted'
                          : 'Task completed',
                    );
                  });
                },
                // Here you add the radio button instead of a checkbox
                child: Row(
                  children: [
                    Radio(
                      value: task.isCompleted,
                      groupValue: true, // Replace with a variable to manage state
                      onChanged: (bool? selected) async {
                        if (selected != null) {
                          await ref
                              .read(tasksProvider.notifier)
                              .updateTask(task.copyWith(isCompleted: selected))
                              .then((value) {
                            AppAlerts.displaySnackbar(
                              context,
                              selected
                                  ? 'Task completed'
                                  : 'Task incompleted',
                            );
                          });
                        }
                      },
                    ),
                    Expanded(
                      child: Text(task.title), // Adjust based on your task model
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            thickness: 1.5,
          ),
        ),
);

 
  }
}
