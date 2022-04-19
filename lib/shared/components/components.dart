import 'package:done_tasks/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required IconData prefix,
  required String label,
   required Function onTap,
  Function? validate,
}) =>
    TextFormField(
validator: (s){
  validate!(s);
},
      controller: controller,
      keyboardType: type,
      onTap: (){
        onTap();
      },
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        labelText: label,
        border: OutlineInputBorder(),

      ),
    );




Widget buildTaskItems (Map model ,context) => Dismissible(

  key: Key( model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

          radius: 40,

          backgroundColor: Colors.blue,

          child: Text('${model['time']}'),

        ),

        SizedBox(width: 20.0),

        Expanded(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Text(

                '${model['title']}',

                style: TextStyle(

                  fontSize: 20,

                  fontWeight: FontWeight.bold,

                ),

              ),



              Text(

               '${model['date']}',

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),



            ],

          ),

        ),

        SizedBox(

          width: 20,

        ),

        IconButton(

            onPressed: () {

              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            },

            icon: Icon(

              Icons.check_box,

              color: Colors.green,

            )),

        IconButton(

          onPressed: () {

            AppCubit.get(context).updateData(status: 'archive', id: model['id']);

          },

          icon: Icon(Icons.archive),

          color: Colors.black45,

        ),

      ],

    ),



  ),
  onDismissed: (direction){
AppCubit.get(context).deleteData(id: model['id'],);
  },
);








