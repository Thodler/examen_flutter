import 'package:examen_flutter/pages/form_task.dart';
import 'package:examen_flutter/pages/show.dart';
import 'package:examen_flutter/services/task_service.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';

class HomePage extends StatefulWidget {
  static const _title = "Home Page";
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final Future<List<Task>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = TaskService().getAllAttraction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: const Text(HomePage._title),
      ),
      body: FutureBuilder(
        future: tasks,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.hasData){
            if(snapshot.data!.length == 0){
              return const Center(
                child: Text("Aucune tâche à faire",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            return listTasks(snapshot);
          }

          if(snapshot.hasError){
            return const Center(child: Text("Base de donnée introuvable."),);
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const FormTask(bottomName: "Enregistré")));
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget listTasks(AsyncSnapshot<dynamic> snapshot){
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (BuildContext context, int index) {
          return
            card(snapshot.data[index]);
      },
    );
  }

  Widget card(Task task){
    bool isChecked = task.isFinish == 1;
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  shape: const CircleBorder(),
                  value: isChecked,
                  onChanged: (bool? value) async {
                    try{
                      var result =
                          await TaskService().createOrUpdate(task.toJson());
                      if (result == 0) throw Exception();

                      setState(() {
                        task.isFinish = value! ? 1 : 0;
                      });
                    }catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Une erreur c'est produite lors de la validation de la tâche"),
                          )
                      );
                    }
                    setState(() {

                    });
                  },
                ),
              ),
              title: Text(
                  task.title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ),
              ),
              subtitle: Text(
                  task.description == "" ?
                    "Aucune description" :
                    task.description!
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('DETAIL'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Show(task: task,),
                        )
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}