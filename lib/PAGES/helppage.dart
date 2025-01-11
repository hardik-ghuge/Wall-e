import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help",style: TextStyle(fontWeight: FontWeight.w900,color: Colors.black),),
        centerTitle: true,
        backgroundColor:Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const ExpansionTile(
              title: Text("How do I sign in?"),
              children: [
                ListTile(
                  title: Text("To sign in, simply use Google."),
                ),
              ],
            ),
            const ExpansionTile(
              title: Text("How do I use the app?"),
              children: [
                ListTile(
                  title: Text("To use the app simply click an image of a plant or upload one from the gallery then Wall-e will give you all the information about the plant"),
                ),
              ],
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: (){Navigator.pop(context);
                    },
                  child:const Text("Go To The App")),
            )
          ],
        ),
      ),
    );
  }
}