
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentiment Analysis',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String text = "";
  String sentimentResult = "";
  String sentimentScore = "";

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sentiment Analysis Using AI"),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade300,
      ),
      body: Container(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 100),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formkey,
                  child: TextField(
                    onChanged: (value){
                      setState(() {
                        text = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      hintText: "Write the tweet here",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextButton.icon(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.indigo.shade300.withOpacity(0.3)
                ),
                icon: Icon(
                  Icons.sentiment_very_satisfied_outlined,
                  color: Colors.black87,
                  size: 30,
                ),
                label: Text('Tap to Predict',
                    style: Theme.of(context).textTheme.titleMedium),
                onPressed: () async{

                  final url = Uri.http("127.0.0.1:5000", "/");

                  final response = await http.post(
                      url,
                      body: json.encode(
                          {
                            'text': text
                          }
                      ),
                      headers: {'Content-Type': "application/json; charset=utf-8"}
                  );
                  print('StatusCode: ${response.statusCode}');
                  print('Return Date: ${response.body}');


                  if(response.statusCode == 200){
                    final jsonResponse = jsonDecode(response.body) as Map<String,dynamic>;

                    sentimentResult = jsonResponse['sentiment'];
                    sentimentScore = jsonResponse['score'];

                    print(sentimentResult);
                    print(sentimentScore);

                    setState(() {
                      sentimentResult = sentimentResult;
                      sentimentScore = sentimentScore;
                    });
                  } else {
                    print("Request failed with status: ${response.statusCode}");
                  }

                },
              ),

              SizedBox(height: 10),
              Text(
                "Text: $text",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Sentiment: $sentimentResult",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Score: $sentimentScore",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}