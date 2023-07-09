import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const AnimatedPractice());
}

class AnimatedPractice extends StatelessWidget {
  const AnimatedPractice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.brown),
        home: const AnimatedScreen());
  }
}

class AnimatedScreen extends StatefulWidget {
  const AnimatedScreen({super.key});

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> with SingleTickerProviderStateMixin{
  late Animation<Offset> _offset;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this,duration:const Duration(seconds: 1));
    _offset = Tween<Offset>(begin:const Offset(2.0, 0.0),end:const Offset(0.0, 0.0)).animate(_animationController,);
    _animationController.forward();
  }


  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
  final _item = [];
  final _key = GlobalKey<AnimatedListState>();

  void addItem() {
    _item.insert(0, "Item ${_item.length + 1}");
    _key.currentState!.insertItem(0, duration: const Duration(milliseconds: 500));
  }

  void removeItem(int index) {
    _key.currentState!.removeItem(index,duration: const Duration(milliseconds: 500),
      (context, animation) {
        return SizeTransition(
          sizeFactor: animation,
          child:  Card(
            shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            color: primariesColors(index),
            margin:const EdgeInsets.all(10),
            child:const ListTile(
              title: Text("Deleted",
                style: TextStyle(fontSize: 20, color: Colors.white),),
            ),
          ),
        );
      },
    );
    _item.removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
      children: [
        const SizedBox(height: 10,),
        SlideTransition(
          position: _offset,
          child: IconButton(onPressed: addItem, icon: const Icon(Icons.add,color: Colors.white,))),
        Expanded(
          child: AnimatedList(
            reverse: true,
            key: _key,
            initialItemCount: 0,
            padding:const EdgeInsets.all(10),
            itemBuilder: (context, index, animation) {
              return SizeTransition(
                key: UniqueKey(),
                sizeFactor: animation,
                child: Card(
                  shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  shadowColor: primariesColors(index),
                  elevation: 8,
                  color: primariesColors(index),
                  child: ListTile(
                    title: Text(_item[index],
                    style:const TextStyle(fontSize: 20,color: Colors.white),),
                    trailing: IconButton(onPressed: (){
                      removeItem(index);
                    }, icon:const Icon(Icons.remove,color: Colors.white,),
                  ),
                ),));
            },
          ),
        )
      ],
        ),
    );
  }

// ** using Primaries Multiple Colors.
  Color primariesColors(int index){
   return Colors.primaries[index % Colors.primaries.length];
  }
}


// ** Model Class .
// class AnimatedModelClass {
//   String imageUrl;
//   String name;
//   AnimatedModelClass({required this.imageUrl, required this.name});
// }
