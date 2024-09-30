// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:todo_app/config/config.dart';
// import 'package:todo_app/data/data.dart';
// import 'package:todo_app/providers/providers.dart';
// import 'package:todo_app/utils/utils.dart';
// import 'package:todo_app/widgets/widgets.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// class CreateTaskScreen extends ConsumerStatefulWidget {
//   static CreateTaskScreen builder(
//     BuildContext context,
//     GoRouterState state,
//   ) =>
//       const CreateTaskScreen();
//   const CreateTaskScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _CreateTaskScreenState();
// }

// class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _noteController = TextEditingController();

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _noteController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colorScheme;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: colors.primary,
//         title: const DisplayWhiteText(
//           text: 'Add New Task',
//         ),
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CommonTextField(
//                 hintText: 'Task Title',
//                 title: 'Task Title',
//                 controller: _titleController,
//               ),
//               const Gap(30),
//               const CategoriesSelection(),
//               const Gap(30),
//               const SelectDateTime(),
//               const Gap(30),
//               CommonTextField(
//                 hintText: 'Notes',
//                 title: 'Notes',
//                 maxLines: 6,
//                 controller: _noteController,
//               ),
//               const Gap(30),
//               ElevatedButton(
//                 onPressed: _createTask,
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: DisplayWhiteText(
//                     text: 'Save',
//                   ),
//                 ),
//               ),
//               const Gap(30),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _createTask() async {
//     final title = _titleController.text.trim();
//     final note = _noteController.text.trim();
//     final time = ref.watch(timeProvider);
//     final date = ref.watch(dateProvider);
//     final category = ref.watch(categoryProvider);
//     if (title.isNotEmpty) {
//       final task = Task(
//         title: title,
//         category: category,
//         time: Helpers.timeToString(time),
//         date: DateFormat.yMMMd().format(date),
//         note: note,
//         isCompleted: false,
//       );

//       await ref.read(tasksProvider.notifier).createTask(task).then((value) {
//         AppAlerts.displaySnackbar(context, 'Task create successfully');
//         context.go(RouteLocation.home);
//       });
//     } else {
//       AppAlerts.displaySnackbar(context, 'Title cannot be empty');
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/config/config.dart';
import 'package:todo_app/data/data.dart';
import 'package:todo_app/data/models/task_priority.dart';
import 'package:todo_app/providers/providers.dart';
import 'package:todo_app/utils/utils.dart';
import 'package:todo_app/widgets/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class CreateTaskScreen extends ConsumerStatefulWidget {
  static CreateTaskScreen builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const CreateTaskScreen();
  const CreateTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.low; // Default priority

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.primary,
        title: const DisplayWhiteText(
          text: 'Add New Task',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                hintText: 'Task Title',
                title: 'Task Title',
                controller: _titleController,
              ),
              const Gap(30),
              const CategoriesSelection(),
              const Gap(30),
              const SelectDateTime(),
              const Gap(30),
              CommonTextField(
                hintText: 'Notes',
                title: 'Notes',
                maxLines: 6,
                controller: _noteController,
              ),
              const Gap(30),
              _buildPrioritySelection(), // Add the priority selection widget
              const Gap(30),
              ElevatedButton(
                onPressed: _createTask,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: DisplayWhiteText(
                    text: 'Save',
                  ),
                ),
              ),
              const Gap(30),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display priority radio buttons
  Widget _buildPrioritySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: TaskPriority.values.map((priority) {
            return Expanded(
              child: ListTile(
                title: Text(priority.name.toUpperCase()),
                leading: Radio<TaskPriority>(
                  value: priority,
                  groupValue: _selectedPriority,
                  onChanged: (TaskPriority? value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _createTask() async {
    final title = _titleController.text.trim();
    final note = _noteController.text.trim();
    final time = ref.watch(timeProvider);
    final date = ref.watch(dateProvider);
    final category = ref.watch(categoryProvider);
    
    if (title.isNotEmpty) {
      final task = Task(
        title: title,
        category: category,
        time: Helpers.timeToString(time),
        date: DateFormat.yMMMd().format(date),
        note: note,
        isCompleted: false,
        priority: _selectedPriority, // Include selected priority
      );

      await ref.read(tasksProvider.notifier).createTask(task).then((value) {
        AppAlerts.displaySnackbar(context, 'Task created successfully');
        context.go(RouteLocation.home);
      });
    } else {
      AppAlerts.displaySnackbar(context, 'Title cannot be empty');
    }
  }
}
