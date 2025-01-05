import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskCalendar extends ConsumerStatefulWidget {
  const TaskCalendar({super.key});

  @override
  ConsumerState<TaskCalendar> createState() => _TaskCalendarState();
}

class _TaskCalendarState extends ConsumerState<TaskCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    // Get the current theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Task Calendar',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            // Table Calendar
            TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: colorScheme.error, 
                ),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
                formatButtonVisible: false,
                leftChevronIcon: Icon(Icons.chevron_left, color: colorScheme.onSurface),
                rightChevronIcon: Icon(Icons.chevron_right, color: colorScheme.onSurface),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: colorScheme.error),
                weekdayStyle: TextStyle(color: colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
