import 'package:examen_flutter/pages/home_page.dart';
import 'package:examen_flutter/pages/form_task.dart';
import 'package:examen_flutter/services/task_service.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';

class Show extends StatefulWidget{

  final Task task;

  const Show({super.key, required this.task,});

  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Tâche"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.title,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                    widget.task.isFinish == 0 ? 1 : 0;
                    try{
                      var result = await TaskService().createOrUpdate(widget.task.toJson());
                      if (result == 0) throw Exception();
        
        
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Une erreur c'est produite lors de la validation de la tâche"),
                        )
                      );
                    }
                },
                child: Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                            Icons.check,
                            color: widget.task.isFinish == 0 ? Colors.grey : Colors.green
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          widget.task.isFinish == 0 ? "A faire": "Terminer",
                          style: TextStyle(color: widget.task.isFinish == 0 ? Colors.grey : Colors.green),
                        ),
        
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              Text(
                widget.task.description == "" ? 'Aucune description' : widget.task.description!,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 250,),
        
              const SizedBox(height: 40,)
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _actionSelected(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit, color: Colors.blue,),
            label: "Modifier",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.delete,color: Colors.red,),
              label: "Supprimer",
              backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  _actionSelected(context, int index){
    switch (index) {
      case 0:
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=> FormTask(bottomName: "Modifier", task: widget.task))
        );
        break;
      case 1:
        _showMyDialog(context);
        break;
    }
  }

  Future<void> _showMyDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Etes-vous sur de vouloir supprimer cette entité ?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () async {
                var message = "L'élément à bien été supprimé.";
                try{
                  var result = await TaskService().delete(widget.task.id!);
                  if (result == 0) throw Exception();
                }catch(e){
                  message = "Une erreur c'est produite lors de la suppréssion";
                } finally {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    ),
                  );

                  Navigator.pop(context);
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const HomePage()
                  )
                );
              }



              },
            ),
          ],
        );
      });
  }
}