import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flow_360/features/tank/controllers/station_shift_controller.dart';
import 'package:flow_360/features/tank/models/station_shift_model.dart';
import 'package:flow_360/features/auth/controllers/auth_controller.dart';

class CreateStationShiftDialog extends StatefulWidget {
  final StationShiftModel? shift;

  const CreateStationShiftDialog({
    super.key,
    this.shift,
  });

  @override
  State<CreateStationShiftDialog> createState() => _CreateStationShiftDialogState();
}

class _CreateStationShiftDialogState extends State<CreateStationShiftDialog> {
  final _formKey = GlobalKey<FormState>();
  final _shiftDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _notesController = TextEditingController();
  String _status = 'ACTIVE';

  bool get isEditing => widget.shift != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final shift = widget.shift!;
      _shiftDateController.text = shift.shiftDate;
      _startTimeController.text = shift.startTime;
      _endTimeController.text = shift.endTime ?? '';
      _notesController.text = shift.notes ?? '';
      _status = shift.status;
    } else {
      // Set default values for new shift
      final now = DateTime.now();
      _shiftDateController.text = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      _startTimeController.text = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _shiftDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StationShiftController>();
    final authController = Get.find<AuthController>();
    final isAdmin = authController.currentUser.value?.user.isStaff ?? false;
    final canCreate = controller.canCreateShiftToday;
    final todayCount = controller.todayShiftCount;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Station Shift' : 'Create Station Shift'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Show shift limit warning for new shifts
              if (!isEditing && !canCreate) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.orange[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isAdmin 
                            ? 'No more shifts allowed today'
                            : 'Maximum 3 shifts per day reached ($todayCount/3)',
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Shift Date
              TextFormField(
                controller: _shiftDateController,
                decoration: const InputDecoration(
                  labelText: 'Shift Date',
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter shift date';
                  }
                  return null;
                },
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    _shiftDateController.text = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Start Time
              TextFormField(
                controller: _startTimeController,
                decoration: const InputDecoration(
                  labelText: 'Start Time',
                  hintText: 'HH:MM',
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter start time';
                  }
                  return null;
                },
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    _startTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // End Time (optional)
              TextFormField(
                controller: _endTimeController,
                decoration: const InputDecoration(
                  labelText: 'End Time (Optional)',
                  hintText: 'HH:MM',
                  prefixIcon: Icon(Icons.access_time),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    _endTimeController.text = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                  }
                },
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Status (only for editing)
              if (isEditing) ...[
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ACTIVE', child: Text('Active')),
                    DropdownMenuItem(value: 'COMPLETED', child: Text('Completed')),
                    DropdownMenuItem(value: 'CANCELLED', child: Text('Cancelled')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Enter any additional notes...',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (!isEditing && !canCreate) ? null : _submitForm,
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final controller = Get.find<StationShiftController>();
      final authController = Get.find<AuthController>();
      
      // Get current user's station ID
      final currentUser = authController.currentUser.value;
      final stationId = currentUser?.user.station;
      
      if (stationId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No station assigned to user'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Check if user can create more shifts today (only for new shifts)
      if (!isEditing && !controller.canCreateShiftToday) {
        final isAdmin = currentUser?.user.isStaff ?? false;
        final message = isAdmin 
          ? 'No more shifts allowed today'
          : 'Maximum 3 shifts per day reached. Please contact your administrator if you need more shifts.';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      
      final data = {
        'shift_date': _shiftDateController.text,
        'start_time': _startTimeController.text,
        if (_endTimeController.text.isNotEmpty) 'end_time': _endTimeController.text,
        if (_notesController.text.isNotEmpty) 'notes': _notesController.text,
        if (isEditing) 'status': _status,
      };

      if (isEditing) {
        controller.updateStationShift(widget.shift!.id, data);
      } else {
        controller.createStationShift(data);
      }
    }
  }
}
