import 'package:done_tasks/shared/components/components.dart';

import 'package:done_tasks/shared/cubit/cubit.dart';
import 'package:done_tasks/shared/cubit/states.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
// key for scaffold
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var formKey = GlobalKey<FormState>();

    // return BlocProvider
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertToDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
            ),
            body:

                 cubit.screens[cubit.currentIndex],
              floatingActionButton: FloatingActionButton(
              onPressed: () {
            if (cubit.isBottomSheetShawn) {
              if (formKey.currentState!.validate()) {
                cubit.insertToDatabase(
                    date: dateController.text,
                    time: timeController.text,
                    title: titleController.text);
              }
            } else {
              scaffoldKey.currentState!
                  .showBottomSheet(
                    (context) => Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultFormField(
                          onTap: (){},
                          prefix: Icons.title,
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'title is empty';
                            }
                          //  return null;
                          },
                          controller: titleController,
                          label: 'Task Title',
                          type: TextInputType.text,
                        ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                        defaultFormField(
                          prefix: Icons.watch_later_outlined,
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'time is empty';
                            }
                         //   return null;
                          },
                          controller: timeController,
                          label: 'Task Time',
                          type: TextInputType.datetime,
                          onTap: () {
                            showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                              timeController.text = value!.format(context).toString();
                            });
                          },
                        ),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                        defaultFormField(
                          prefix: Icons.calendar_today,
                          validate: (String? val) {
                            if (val!.isEmpty) {
                              return 'Date is empty';
                            }
                        //    return null;
                          },
                          controller: dateController,
                          label: 'Task Date',
                          type: TextInputType.datetime,
                          onTap: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2021-12-12'))
                                .then((value) {
                              dateController.text = DateFormat.yMMMd().format(value!);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                    ),
                elevation: 20,
              )
                  .closed
                  .then((value) {
                cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
              });
              cubit.changeBottomSheet(isShow: true, icon: Icons.add);
            }
              },
                child: Icon(cubit.fabIcon),
              ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'archived'),
              ],
            ),
          );
        },
      ),
    );
  }
}
// crate database
//create table
// open database
// insert database
//update database
//delete database


