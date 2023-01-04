import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_des/flutter_des.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class Cifrar extends StatefulWidget{
  const Cifrar({
    super.key,
});

  @override
  CifrarState createState() => CifrarState();
}

class CifrarState extends State<Cifrar>{

  List<String> pasosCifrado = ["Elegir Archivo .txt", "Crear Archivo Cifrado"];
  List<bool> pasosState = [false, false];
  late File decryptedFile;
  String fileString = "";
  static const key = "4t7w!z%C*F-JaNcRfUjXn2r5u8x/A?D(";
  late Uint8List encrypt;
  String outputFileName = "";
  TextEditingController fileName = TextEditingController(text: "");

  chooseFile(int index) async {
    // Open native file browser to choose a text file from device external storage
    FilePickerResult? result = await FilePicker.platform.pickFiles(); // Wait for user to pick a file

    if (result != null){
      setState(() {
        decryptedFile = File(result.files.single.path!); // Choosed file path
        pasosState[index] = true; // Check task as done!
        readTextFile();
      });
    } else {
      print("user cancelled selection");
    }
  }

  readTextFile() async {
    // This method is used to read the selected text file as string

    setState(() {
      fileString = decryptedFile.readAsStringSync();
    });
    print("Decrypted message :  $fileString");

    encryptText();

  }

  encryptText() async {
    // Once a file text is read, we can encrypt the message using DES algorithm
    Uint8List? temp = await FlutterDes.encrypt(fileString, key);

    setState(() async {
      encrypt = temp!;
    });

    print("Encrypted message : $encrypt");
  }


  exportEncryptedFileDialog(BuildContext context, int index){
    // Let user choose a filename for a new file before creating it
    showDialog(context: context,
        builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.transparent,
        content: SizedBox(
          child: Column(
            children: [
              Expanded(
          child: ListView(
            children : [

              SizedBox(height: 200,),
              // Title
              Text("Elige Un Nombre", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30), textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              // Text Field
              SizedBox(
              child : ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  topLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                ),
                  child : TextField(
                decoration: InputDecoration(
                  hintText: "Escribe un nombre...",
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                ),
                    controller: fileName,
              )
              )
              ),


              // Button
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child : TextButton(
                style : TextButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                ),
                  onPressed: (){
                  setState(() {
                    outputFileName = fileName.text;
                    fileName.text = "";
                    createEncryptedFile(index);
                    Navigator.pop(context);
                  });
                  },
                  child: Text("Guardar", style: TextStyle(color: Colors.white),))),
            ]
        )
              )
            ],
          ),
        ),
      );
    }
    );
  }

  createEncryptedFile(int index){
    // Create an output file with the choosed file name
    File output = File("sdcard/download/$outputFileName.txt");

    if (output.existsSync()){
      // Already exists. Delete it before creating a new one with the same name
      output.deleteSync();
      output.writeAsBytesSync(encrypt);
      setState(() {
        pasosState[index] = true;
      });

    } else {
      // Create a new file
      output.writeAsBytesSync(encrypt);
      setState(() {
        pasosState[index] = true;
      });
    }
  }

  resetValues() async {
    // Set all values to default when a file is encrypted
    setState(() {
      pasosState = [false, false];
    });
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
          /**
              1.- Elegir archivo;
              2.- Leer contenido de archivo y cifrarlo;
              3.- Crear archivo de salida
              4.- Escribir texto cifrado en archivo de salida
           */

          // Banner
          Image.asset("assets/icon/banner_encriptar.png"),

          SizedBox(height: 50,),

          // Title
          Text("Pasos a seguir", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),),

          SizedBox(height: 50,),

          Expanded(
              child: ListView.builder(
                itemCount: pasosCifrado.length,
                  itemBuilder: (context, index){
                  return InkWell(
                    onTap: (){
                      // TO-DO
                      if(index == 0 && pasosState[index] == false){
                        chooseFile(index);
                      }

                      else if (index == 1 && pasosState[index] == false){
                        exportEncryptedFileDialog(context, index);
                      }

                    },
                      child : Card(
                  color: Colors.black,
                  child: Row(
                  children: [
                    ListTile(
                    leading: Icon(pasosState[index] == false ? Icons.pending : Icons.check_rounded, color: Colors.green,),
                    title: Text(pasosCifrado[index], style: TextStyle(color: Colors.white),),
                    )
    ],
                  ),
                  )
                  );
    }
              )
          ),

          if (pasosState[0] == true && pasosState[1] == true)
            // All checked, allow to reset it
            Row(
                  children : [
                    Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                  child : TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent
              ),
                onPressed: (){
                resetValues();
                }, child: Text("Reset Value", style: TextStyle(color: Colors.white),))))]),
        ],
      ),
    );
  }
}