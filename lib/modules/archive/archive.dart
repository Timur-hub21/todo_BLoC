import 'package:bloc_new_app/shared/components/components.dart';
import 'package:bloc_new_app/shared/cubit/cubit.dart';
import 'package:bloc_new_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Archive extends StatelessWidget {
  const Archive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return taskBuilder(tasks: tasks);
      },
    );
  }
}
