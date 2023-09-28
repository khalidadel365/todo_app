import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../layout/todo_app/cubit/cubit.dart';
import '../../../layout/todo_app/cubit/states.dart';
import '../../../shared/components/components.dart';
class NewTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return BlocConsumer<AppCubit,AppStates>(
       listener: (context,state){},
       builder: (context,state){
         var tasks = AppCubit.get(context).newTasks;
         return taskBuilder(
           tasks: tasks
         );
       }
       );
  }
}
