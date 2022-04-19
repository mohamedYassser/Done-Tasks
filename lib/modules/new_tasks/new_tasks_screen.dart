
import 'package:done_tasks/shared/components/components.dart';
import 'package:done_tasks/shared/cubit/cubit.dart';
import 'package:done_tasks/shared/cubit/states.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewTasksScreen extends StatelessWidget {









  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates> (


      listener: ( context, state) {},

      builder: (context,  state) {
        var tasks = AppCubit.get(context).newTasks;


    var newTasks = tasks;
      return ListView.separated(itemBuilder: (context,index)=>buildTaskItems (newTasks [index],context),
          separatorBuilder: (context,index)=>Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey,

          ),
          itemCount: tasks.length);

    },


    );



}
}
