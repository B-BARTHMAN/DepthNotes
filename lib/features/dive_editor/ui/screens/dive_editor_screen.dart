import 'package:depth_notes/features/dive_editor/cubit/dive_editor_cubit.dart';
import 'package:depth_notes/features/dive_editor/cubit/dive_editor_state.dart';
import 'package:depth_notes/features/dive_editor/ui/widgets/dive_editor_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DiveEditorScreen extends StatelessWidget {
  const DiveEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiveEditorCubit, DiveEditorState>(
      listener: (context, state) {
        if (state.status == DiveEditorStatus.saved) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Log Dive')),
        body: const DiveEditorForm(),
      ),
    );
  }
}
