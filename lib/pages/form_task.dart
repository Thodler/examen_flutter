import 'package:examen_flutter/models/task.dart';
import 'package:examen_flutter/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../services/task_service.dart';

class FormTask extends StatefulWidget{
  final String bottomName;
  final Task? task;


  const FormTask({super.key, required this.bottomName, this.task});

  @override
  State<FormTask> createState() => _FormTaskState();
}

class _FormTaskState extends State<FormTask> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  String titlePage = "Ajouter";

  @override
  Widget build(BuildContext context) {
    if(widget.task != null){
      _title = TextEditingController(text: widget.task!.title);
      _description = TextEditingController(text: widget.task!.description);

      titlePage = "Modifier";
    }

    return  Scaffold(
      appBar: AppBar(
        title: Text("$titlePage une tâche"),
      ),
      body: SingleChildScrollView (
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    TextFormField(
                      controller: _title,
                      decoration: const InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer le nom d'une tâche";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: _description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        clickSave(context);
                      }
                    },
                    style: const ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(200, 50))
                    ),
                    child: Text(widget.bottomName)
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void clickSave(context) async {
    var task =
      Task(
          title: _title.text,
          description: _description.text,
          isFinish: widget.task != null ? widget.task!.isFinish:0);

    if(widget.task != null){
      task.id = widget.task!.id;
    }

    try{
      var result = await TaskService().createOrUpdate(task.toJson());

      if(result == 0) throw Exception();

    } catch (exception){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Une erreur c'est produite."),
        ),
      );
    }

    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        )
    );
  }
}