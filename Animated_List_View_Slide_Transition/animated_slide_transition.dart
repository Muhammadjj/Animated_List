import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const AnimatedSlideTransition());
}

class AnimatedSlideTransition extends StatelessWidget {
  const AnimatedSlideTransition({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.brown),
        home: const AnimatedTransition());
  }
}

class AnimatedTransition extends StatefulWidget {
  const AnimatedTransition({super.key});

  @override
  State<AnimatedTransition> createState() => _AnimatedTransitionState();
}

class _AnimatedTransitionState extends State<AnimatedTransition> {
  final item = [];
  final key = GlobalKey<AnimatedListState>();

  void addItem() {
    item.insert(0, "${item.length + 1}");
    key.currentState!.insertItem(0,duration:const Duration(milliseconds: 600));
  }


  void removeItem(int index){
    key.currentState!.removeItem(duration:const Duration(milliseconds: 600), index, 
    (context, animation) {
      return SlideTransition(
        position: Tween<Offset>(begin:const Offset(-1.0, 0.0),end:const Offset(0.0, 0.0)).animate(animation),
        child: Card(
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 8,
          color: Colors.red,
          child:const ListTile(
            title: Text("Deleted",style: TextStyle(fontSize: 20,color: Colors.white),),
          ),
        ),
        );
    });
    item.removeAt(index);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          IconButton(onPressed: addItem, icon:const Icon(Icons.add,color: Colors.white,)),
         Expanded(
           child: AnimatedList(
            initialItemCount: 0,
            key: key,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                 position: Tween<Offset>(begin:const Offset(-1.0, 0.0),end:const Offset(0.0, 0.0)).animate(animation),
                 child: Card(
                   elevation: 8,
                   shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
                   margin:const EdgeInsets.all(10),
                   color: primariesColors(index),
                   child: ListTile(
                   title: Text(item[index],style:const TextStyle(fontSize: 20,color: Colors.white),),
                   trailing: IconButton(onPressed: (){
                    removeItem(index);
                   }, icon:const Icon(Icons.delete,color: Colors.white,),
                   ),
                 ),)
                 );
            },),
         )
        ],
      ),
    );
  }

  // ** using Primaries Multiple Colors.
  Color primariesColors(int index) {
    return Colors.primaries[index % Colors.primaries.length];
  }
}
