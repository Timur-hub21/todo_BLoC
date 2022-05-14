import 'package:bloc_new_app/shared/adaptive/adaptive_indicator.dart';
import 'package:bloc_new_app/shared/components/components.dart';
import 'package:bloc_new_app/shared/components/constants.dart';
import 'package:bloc_new_app/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../shared/cubit/cubit.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (contex, state) {
        if (state is AppInsertDatabaseState) Navigator.pop(context);
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.title[cubit.currentIndex]),
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_4_outlined),
                onPressed: () {
                  cubit.changeAppMode();
                },
              ),
            ],
          ),
          key: scaffoldKey,
          body: (state is! AppGetDatabaseLoadingState)
              ? cubit.screens[cubit.currentIndex]
              : Center(
                  child: AdaptiveIndicator(
                  os: getOS(),
                )),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (value) {
              cubit.changeIndex(value);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Task'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline), label: 'Done'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined), label: 'Archive'),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              child: Icon(cubit.iconChange),
              onPressed: () {
                if (cubit.isBottomShow!) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultFormField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Text must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task title',
                                    prefix: Icons.title,
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later_outlined,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  defaultFormField(
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    prefix: Icons.calendar_today_outlined,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2025-12-31'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              }),
        );
      }),
    );
  }
}
