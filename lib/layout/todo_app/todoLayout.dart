import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget  { // homeCubit كامل
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey =GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> AppCubit()..createDatabase(), // مشترك بين الابليكيشنين (مهم)
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context ,AppStates state){
          if(state is AppInserteDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context , AppStates state){
          AppCubit cubit =AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.current_Index],
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              backgroundColor: Colors.indigoAccent,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context)=>cubit.Screens[cubit.current_Index],
              fallback: (context)=> Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.indigoAccent,
              child: Icon(
                cubit.fabIcon,
              ),
              onPressed: () {
                if(cubit.isBottomSheetShown) {
                  if(formKey.currentState!.validate()){
                    cubit.insertToDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text);
                  }
                  titleController.clear();
                  dateController.clear();
                  titleController.clear();
                }
                else {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) => Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Title must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Title',
                                  prefix: Icons.title,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: (){
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value){
                                      timeController.text=value!.format(context);
                                      print(value.format(context).toString());
                                    }).catchError((Error){
                                      Error.toString();
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: (){
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                    ).then((value){
                                      dateController.text=DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task Date',
                                  prefix: Icons.calendar_month_outlined,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit
                    );
                  });   //happen when closed with mouse
                  cubit.changeBottomSheetState(
                      isShow: true, icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.indigoAccent,
              type: BottomNavigationBarType.fixed,
              currentIndex: AppCubit.get(context).current_Index,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}



