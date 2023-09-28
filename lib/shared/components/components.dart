import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../layout/todo_app/cubit/cubit.dart';


Widget defaultButton({
  double width = double.infinity,
  Color backgound = Colors.blue,
  bool isUpperCase = true,
  required String text,
  required VoidCallback onPressed,
  double radius = 15,
  bool isClickable = true,
}) => Container(
      width: width,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgound,
      ),
    );

Widget defaultFormField({required TextEditingController controller,
  required TextInputType type,
  ValueChanged? onSubmit,
  ValueChanged? onChanged,
  FormFieldValidator? validate,
  required String? label,
  required IconData prefix,
  bool obsecureText = false,
  IconData? suffix,
  VoidCallback? suffixPressed,
  VoidCallback? onTap,
  TextStyle? inputColor,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      onTap: onTap,
      controller: controller,
      //autovalidateMode: AutovalidateMode.always,
      keyboardType: type,
      obscureText: obsecureText,
      onFieldSubmitted: onSubmit,
      onChanged: onChanged,
      validator: validate,
      style: inputColor,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
      ),
    );

  Widget buildTaskItem(Map model ,context) => Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             CircleAvatar(
              backgroundColor: Colors.indigoAccent,
              radius: 42.0,
              child: Text(
                '${model['time']}',
                style: const TextStyle(color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: (){
                  AppCubit.get(context).updateData(
                      status: 'done',
                      id: model['id'],
                  );
                },
                icon: const Icon(
                    Icons.check_box_outlined,
                  color: Colors.green,
                )
            ),
            IconButton(
                onPressed: (){
                  AppCubit.get(context).updateData(
                    status: 'archive',
                    id: model['id'],
                  );
                },
                icon: const Icon(
                    Icons.archive_outlined,
                color: Colors.black45,
                )
            ),
          ],
        ),
      ),
    onDismissed: (direction){
      AppCubit.get(context).deleteData(id: model['id']);
    },
  );

  Widget taskBuilder ({required List<Map> tasks,})=> ConditionalBuilder(
    condition: tasks.isNotEmpty,
    builder: (context) => ListView.separated(
      itemBuilder: (context,index) {
        return buildTaskItem(tasks[index],context);
      },
      separatorBuilder: (context,index) => Container(
        width: double.infinity,
        color: Colors.grey[300],
        height: 1.7,
      ),
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset('assets/images/task.json'),
          const SizedBox(
            height: 18,
          ),
          Text('Please Add Some Tasks',
              style:GoogleFonts.abel(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )
          ),
        ],
      ),
    ),
  );

  Widget myDivider() => Container(
    width: double.infinity,
    color: Colors.grey[300],
    height: 1.7,
  );



  void navigateTo (context,widget) => Navigator.push(
      context,
    MaterialPageRoute(
        builder: (context) => widget
    )
  );

  Widget defaultTextButton({required String text,required VoidCallback function}) =>  TextButton(
      onPressed: function,
      child: Text(
          text.toUpperCase(),
      )
  );

