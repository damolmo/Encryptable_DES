import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Cifrar/cifrar.dart';
import '../Descifrar/descifrar.dart';

class Home extends StatefulWidget{
  const Home({
    super.key,
  });

  @override
  HomeState createState()=> HomeState();
}

class HomeState extends State<Home>{
  List<String> menuOptionsTitle = ["Cifrar", "Descifrar", "Salir"];
  List<String> menuOptionsSubtitle = ["Lee un archivo y genera un archivo cifrado", "Lee un archivo y genera un archivo descifrado", "Salir de la aplicación"];
  List<IconData> menuIcons = [Icons.enhanced_encryption_rounded, Icons.no_encryption_rounded, Icons.exit_to_app_rounded, ];

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade400,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [

        // Banner
        Image.asset("assets/icon/banner.png"),

        const SizedBox(height : 50),

        // Menu
        Expanded(
            child: ListView.builder(
              itemCount: menuOptionsTitle.length,
                itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    if (menuOptionsTitle[index] == "Cifrar"){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Cifrar()));
                    }
                    else if (menuOptionsTitle[index] == "Descifrar"){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Descifrar()));
                    } else if (menuOptionsTitle[index] == "Salir"){
                      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    }
                  },
                    child : Card(
                  color: Colors.black,
                  child: Row(
                    children: [
                      ListTile(
                        leading: Icon(menuIcons[index], color: Colors.blueAccent, size: 40,),
                        title: Text(menuOptionsTitle[index], style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                        subtitle: Text(menuOptionsSubtitle[index], style: const TextStyle(color: Colors.white, fontSize: 15),),
                      )
                    ],
                  ),
                )
                );
                }
            )
        ),


        ]
          )
    );
  }
}