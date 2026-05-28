import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/core/dive_time/models/dive_time.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_cubit.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/date_picker_tile.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/dive_details_fields.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/precise_time_fields.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/rough_time_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The dive editor form.
///
/// Holds local form state (controllers + the rough/precise toggle) and
/// hands the assembled [DiveTime] to [DiveEditorCubit.saveDive] on submit.
class DiveEditorForm extends StatefulWidget {
  const DiveEditorForm({required this.initialDive, super.key});

  final Dive? initialDive;

  @override
  State<DiveEditorForm> createState() => _DiveEditorFormState();
}

class _DiveEditorFormState extends State<DiveEditorForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _siteController;
  late final TextEditingController _depthController;
  late final TextEditingController _durationController;
  late final TextEditingController _notesController;

  DateTime _date = DateTime.now();
  bool _isRoughTime = true;
  DiveTimeOfDay _timeOfDay = DiveTimeOfDay.morning;
  TimeOfDay? _timeIn;
  TimeOfDay? _timeOut;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDive;

    _siteController = TextEditingController(text: initial?.siteName ?? '');
    _depthController = TextEditingController(
      text: initial?.depth.toString() ?? '',
    );
    _durationController = TextEditingController();
    _notesController = TextEditingController(text: initial?.notes ?? '');

    if (initial == null) return;

    // Editing an existing dive — seed the form from it.
    _date = initial.date;
    switch (initial.time) {
      case RoughDiveTime(:final timeOfDay, :final duration):
        _isRoughTime = true;
        _timeOfDay = timeOfDay;
        _durationController.text = duration.toString();
      case PreciseDiveTime(:final timeIn, :final timeOut):
        _isRoughTime = false;
        _timeIn = TimeOfDay.fromDateTime(timeIn);
        _timeOut = TimeOfDay.fromDateTime(timeOut);
    }
  }

  @override
  void dispose() {
    _siteController.dispose();
    _depthController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Precise mode needs both pickers set; validators can't see them.
    if (!_isRoughTime && (_timeIn == null || _timeOut == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set both time in and time out')),
      );
      return;
    }

    // Recombine `_date` with each TimeOfDay into a full DateTime.
    // Crossing-midnight dives aren't supported yet — both stamps share _date.
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

    await context.read<DiveEditorCubit>().saveDive(
      date: _date,
      site: _siteController.text,
      depth: double.tryParse(_depthController.text) ?? 0,
      time: time,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DatePickerTile(
            date: _date,
            onDateChanged: (d) => setState(() => _date = d),
          ),
          const SizedBox(height: 16),

          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Rough')),
              ButtonSegment(value: false, label: Text('Precise')),
            ],
            selected: {_isRoughTime},
            onSelectionChanged: (s) => setState(() => _isRoughTime = s.first),
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
              onTimeInChanged: (t) => setState(() => _timeIn = t),
              onTimeOutChanged: (t) => setState(() => _timeOut = t),
            ),
          const SizedBox(height: 16),

          DiveDetailsFields(
            siteController: _siteController,
            depthController: _depthController,
            notesController: _notesController,
          ),
          const SizedBox(height: 24),

          FilledButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
