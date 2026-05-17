import 'package:depth_notes/core/dive/models/dive_time.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_cubit.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_state.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/date_picker_tile.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/precise_time_fields.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/rough_time_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DiveEditorScreen extends StatefulWidget {
  const DiveEditorScreen({super.key});

  @override
  State<DiveEditorScreen> createState() => _DiveEditorScreenState();
}

class _DiveEditorScreenState extends State<DiveEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _siteController = TextEditingController();
  final _depthController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();
  bool _isRoughTime = true;
  DiveTimeOfDay _timeOfDay = DiveTimeOfDay.morning;
  TimeOfDay? _timeIn;
  TimeOfDay? _timeOut;

  @override
  void dispose() {
    _siteController.dispose();
    _depthController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime({required bool isTimeIn}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isTimeIn) {
          _timeIn = picked;
        } else {
          _timeOut = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiveEditorCubit, DiveEditorState>(
      listener: (context, state) {
        if (state.status == DiveEditorStatus.saved) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log Dive'),
          actions: [
            TextButton(
              onPressed: () {
                final time = _isRoughTime
                    ? DiveTime.rough(
                        timeOfDay: _timeOfDay,
                        duration: int.tryParse(_durationController.text) ?? 0,
                      )
                    : DiveTime.precise(
                        timeIn: DateTime(
                          _date.year,
                          _date.month,
                          _date.day,
                          _timeIn?.hour ?? 0,
                          _timeIn?.minute ?? 0,
                        ),
                        timeOut: DateTime(
                          _date.year,
                          _date.month,
                          _date.day,
                          _timeOut?.hour ?? 0,
                          _timeOut?.minute ?? 0,
                        ),
                      );

                context.read<DiveEditorCubit>().saveDive(
                  date: _date,
                  site: _siteController.text,
                  depth: double.tryParse(_depthController.text) ?? 0,
                  time: time,
                  notes: _notesController.text.isEmpty
                      ? null
                      : _notesController.text,
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),

        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DatePickerTile(date: _date, onPick: _pickDate),
              const SizedBox(height: 16),

              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Rough')),
                  ButtonSegment(value: false, label: Text('Precise')),
                ],
                selected: {_isRoughTime},
                onSelectionChanged: (selected) {
                  setState(() => _isRoughTime = selected.first);
                },
              ),
              const SizedBox(height: 16),

              if (_isRoughTime)
                RoughTimeFields(
                  timeOfDay: _timeOfDay,
                  onTimeOfDayChanged: (v) => setState(() => _timeOfDay = v),
                  durationController: _durationController,
                ),

              if (!_isRoughTime)
                PreciseTimeFields(
                  timeIn: _timeIn,
                  timeOut: _timeOut,
                  onPickTimeIn: () => _pickTime(isTimeIn: true),
                  onPickTimeOut: () => _pickTime(isTimeIn: false),
                ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _siteController,
                decoration: const InputDecoration(labelText: 'Dive site'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _depthController,
                decoration: const InputDecoration(
                  labelText: 'Max depth',
                  suffixText: 'm',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
