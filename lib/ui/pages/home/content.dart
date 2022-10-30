import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_ibm_watson/flutter_ibm_watson.dart';
import 'package:texto_falado_auth/data/sql_helper.dart';
import 'package:texto_falado_auth/constant.dart';
import 'package:get/get.dart';

import '../../controllers/authentication_controller.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _Home();
}

class _Home extends State<HomePage> {

  AudioPlayer audioPlayer = AudioPlayer();
  String textAsSpeech = "";

  void textToSpeech(String text) async {

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    IamOptions options =
    await IamOptions(iamApiKey: json['apiKey'], url: json['ibmURL']).build();
    TextToSpeech service = TextToSpeech(iamOptions: options);
    service.setVoice("pt-BR_IsabelaV3Voice");
    Uint8List voice = await service.toSpeech(text);

    audioPlayer.playBytes(voice);
  }

  // All journals
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); // Loading the diary when the app starts
  }

  final TextEditingController _titleController = TextEditingController();

// Insert a new journal to the database
  Future<void> _addItem() async {
    await SQLHelper.createItem(_titleController.text);
    _refreshJournals();
  }

  // Update an existing journal
  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text);
    _refreshJournals();
  }

  // Delete an item
  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    _refreshJournals();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
      _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: 'Texto'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _titleController.text = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text('Editar'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF000000)
                ),
              )
            ],
          ),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(

          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: Color(0xFF000000),
            bottom: const TabBar(
              indicatorColor: Color(0xFFFFFFFF),
              tabs: [
                Tab(icon: Icon(Icons.volume_up)),
                Tab(icon: Icon(Icons.history))
              ],
            ),
            centerTitle: true,
            title: Text("Texto Falado",
                style: TextStyle(
                  color: Colors.white, fontSize: 40,
                  fontWeight: FontWeight.w300,
                )),

          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.logout),
                label: 'Sair',
              ),
            ],
            selectedItemColor: Color(0xFF000000),
            onTap: (int index) {
              switch (index) {
                case 0:

                  break;
                case 1:
                  AuthenticationController controller = Get.find();
                  controller.logout();
                  break;
              }

            },
          ),
          body: TabBarView(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child:  Column(
                              children: [
                                TextField(
                                  // readOnly: true, // * Just for Debug
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black, fontSize: 25),
                                    showCursor: true,
                                    //cursorColor: mainColor,
                                    controller: _titleController,
                                    decoration: kTextFiledInputDecoration
                                        .copyWith(labelText: "Digite o texto"),onChanged: (value) {
                                  setState(() {
                                    textAsSpeech = value;
                                  });
                                }),

                              ]
                          )
                      ),
                      ElevatedButton(
                        onPressed: () {
                          textToSpeech(textAsSpeech);
                          _addItem();
                          _titleController.text = '';
                          textAsSpeech = '';
                        },
                        child: const Text(
                          'Falar',
                          style: TextStyle(fontSize: 16),
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF000000),
                          fixedSize: const Size(80, 80),
                          shape: const CircleBorder(),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 15),

                          itemCount: _journals.length,
                          itemBuilder: (context, index) => ElevatedButton(
                            onPressed: () {
                              textToSpeech(_journals[index]['title']);
                            },
                            child: Text(_journals[index]['title']),
                            style:
                            ElevatedButton.styleFrom(primary: Colors.grey),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: ListView.builder(
                    itemCount: _journals.length,
                    itemBuilder: (context, index) => Card(
                      color: Colors.grey,
                      margin: const EdgeInsets.all(15),
                      child: ListTile(
                          title: Text(_journals[index]['title']),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      _showForm(_journals[index]['id']),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteItem(_journals[index]['id']),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ),

      ),

    );
  }
}
