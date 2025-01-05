import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import '../../providers/speech_provider.dart';

class AddTaskFAB extends ConsumerStatefulWidget {
  const AddTaskFAB({super.key});

  @override
  ConsumerState<AddTaskFAB> createState() => _AddTaskFABState();
}

class _AddTaskFABState extends ConsumerState<AddTaskFAB> {
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showAddTaskDialog,
      child: const Icon(Icons.add),
    );
  }
}

class AddTaskDialog extends ConsumerStatefulWidget {
  const AddTaskDialog({super.key});

  @override
  ConsumerState<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isTitleListening = false;
  bool _isDescriptionListening = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _toggleTitleListening() async {
    final speechService = ref.read(speechServiceProvider);

    if (!_isTitleListening) {
      final success = await speechService.startListening((text) {
        _titleController.text = text;
      });
      if (success) setState(() => _isTitleListening = true);
    } else {
      await speechService.stopListening();
      setState(() => _isTitleListening = false);
    }
  }

  void _toggleDescriptionListening() async {
    final speechService = ref.read(speechServiceProvider);

    if (!_isDescriptionListening) {
      final success = await speechService.startListening((text) {
        _descriptionController.text = text;
      });
      if (success) setState(() => _isDescriptionListening = true);
    } else {
      await speechService.stopListening();
      setState(() => _isDescriptionListening = false);
    }
  }

  void _addTask() {
    if (_titleController.text.isEmpty) return;

    final dueDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final task = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: dueDate,
    );

    ref.read(taskProvider.notifier).addTask(task);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isTitleListening ? Icons.mic : Icons.mic_none,
                    color: _isTitleListening ? Colors.red : null,
                  ),
                  onPressed: _toggleTitleListening,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isDescriptionListening ? Icons.mic : Icons.mic_none,
                    color: _isDescriptionListening ? Colors.red : null,
                  ),
                  onPressed: _toggleDescriptionListening,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Text(
                    '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}',
                  ),
                  onPressed: _selectDate,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.access_time),
                  label: Text(_selectedTime.format(context)),
                  onPressed: _selectTime,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addTask,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
