import 'package:flutter/material.dart';

class ProfileImagePreview extends StatefulWidget {

  final Map<String, dynamic> data;

  const ProfileImagePreview({super.key, required this.data});

  @override
  State<ProfileImagePreview> createState() => _ProfileImagePreviewState();
}

class _ProfileImagePreviewState extends State<ProfileImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_sharp, )),
        title: const Text("Identification"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(tag: 'image-animation',
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Image.network(widget.data['picture'], fit: BoxFit.cover,),
              )
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Name",
                  style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.data['name'],
                  style: const TextStyle(color: Colors.black, fontSize: 22),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Mole",
                  style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Mole under arm",
                  style: TextStyle(color: Colors.black, fontSize: 22),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
