import 'package:bloc/bloc.dart';
import 'package:done_tasks/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:done_tasks/modules/new_done/new_done_screen.dart';
import 'package:done_tasks/modules/new_tasks/new_tasks_screen.dart';

import 'package:done_tasks/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit <AppStates>{

  AppCubit(): super (AppIntialStat());
  static AppCubit get (context)=>BlocProvider.of(context);
  int currentIndex = 0;

  List<Widget> screens = [
    NewTasksScreen(),
    NewDoneScreen(),
    ArchivedTasksScreen(),


  ];
  List<String> titles = [
    "New Tasks",
    "New Don",
    "Archived Tasks",
  ];




  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  void changeIndex (int index){currentIndex= index;
emit(AppChangeBootSheetNaveBarState());
  }


  Database? database;
  //List <Map>tasks =[] ;
  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database database, version) {
        database
            .execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
print("tasks");
        }).catchError((error) {
          print(error.toString());
        });
      },


      onOpen: (database)
      {
getDataFromDatabase(database);

      }
    ).then((value) {
print("$value");
    database =value;
      emit(AppCreateDataBaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String date,
    required String time,
  })async {
return await database!.transaction((txn) async {
      txn.rawInsert('INSERT INTO tasks (title,date,time,status) VALUES ("$title","$date","$time","new")').then((value) {
        print('task inserted');

        emit(AppInsertToDataBaseState());
        getDataFromDatabase(database!);

      }).catchError((err) {
        print(err.toString());
      });
    });
  }

  void getDataFromDatabase( Database database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppCreateDataBaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
//newTasks = value;
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }

  void updateData({required String status, required int id}) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?', ['$status', id]).then((value) {
      getDataFromDatabase(database!);
      emit(AppUpdateDatabaseStat());
    });
  }

  void deleteData({required int id}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database!);
      emit(AppDeleteDatabaseStat());
    });
  }

  // floating action bottom
  bool isBottomSheetShawn = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheetShawn = isShow;
    fabIcon = icon;
    emit(AppChangeBootSheetNaveBarState());
  }
}