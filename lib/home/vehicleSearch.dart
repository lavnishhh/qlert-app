import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleSearch extends StatefulWidget {
  @override
  _VehicleSearchState createState() => _VehicleSearchState();
}

class _VehicleSearchState extends State<VehicleSearch> {
  TextEditingController _textController = TextEditingController();
  String _recordedText = '';

  final String searchField =
      'vehicleNumber'; // Replace with the actual field name
  final String collectionGroup =
      'users'; // Replace with the actual collection group name

  List<Map<String, dynamic>> searchResults = [];

  void _performSearch() {
    String searchTerm = _recordedText;

    if (searchTerm.isNotEmpty) {
      FirebaseFirestore.instance
          .collectionGroup(collectionGroup)
          .where(searchField, isEqualTo: searchTerm)
          .get()
          .then((QuerySnapshot querySnapshot) {
        setState(() {
          searchResults = querySnapshot.docs.map((DocumentSnapshot document) {
            return document.data() as Map<String, dynamic>;
          }).toList();
        });
      }).catchError((error) {
        print('Error: $error');
        // Handle error
      });
    }
  }

  void _recordText() {
    setState(() {
      _recordedText = _textController.text;
    });
    _performSearch();
    print(searchResults);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              labelText: 'Enter Vehicle Number',
              border:
                  OutlineInputBorder(), // Apply the border only to TextField
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
            ),
            onPressed: () {
              _recordText();
            },
            child: Text('Submit'),
          ),
          SizedBox(height: 20),
          Text(
            'Scan Qr Code or Enter Vehicle Number',
            style: TextStyle(fontSize: 20, color: Colors.red),
          )
          // Text('Recorded Text: $_recordedText'),
        ],
      ),
    );
  }
}
