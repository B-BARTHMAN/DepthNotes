import 'package:depth_notes/core/dive/models/dive.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_cubit.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_state.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/dive_editor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DiveEditorScreen extends StatelessWidget {
  const DiveEditorScreen({this.initialDive, super.key});

  final Dive? initialDive;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiveEditorCubit, DiveEditorState>(
      listener: (context, state) {
        if (state.status == DiveEditorStatus.saved) return;
        context.pop();
        if (initialDive != null) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(initialDive == null ? 'Log Dive' : 'Edit Dive'),
        ),
        body: DiveEditorForm(initialDive: initialDive),
      ),
    );
  }
}
