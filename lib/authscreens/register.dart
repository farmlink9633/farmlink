import 'package:flutter/material.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

      ),
      body: Column(
        children: [
          Text("Create Your Account",style: TextStyle(fontSize: 34,color:Colors.brown),),
          TextField(
            decoration: InputDecoration(
              prefixIcon:Icon(Icons.email,),
              border:OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide:BorderSide(color: Colors.lightGreenAccent) ),
              fillColor: const Color.fromARGB(255, 7, 23, 1),
              filled: true,
              
label: Text("email"),
            
          )),
          SizedBox(height: 15,),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.password),
                fillColor: const Color.fromARGB(255, 7, 23, 1),
                filled: true,

              ),
            ),
            ElevatedButton(onPressed: () {},style: ElevatedButton.styleFrom(backgroundColor:Colors.lightGreen), child: Text("Register"))
       ],
    
      ),
    );
  }
}