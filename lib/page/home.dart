import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/download_helper.dart';
import '../widgets/my_bottom_sheet.dart';
import '../widgets/text_filed.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  DownloaderHelper downloaderHelper = DownloaderHelper();
  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey();

  bool isLoading = false;
  bool? isDowloanding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'DL Downloader',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backdrop.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: InputField(
                      title: "DL Video URL",
                      hint: "Enter url here",
                      fieldController: textEditingController,
                      onFieldSubmitted: (value) {
                        print(value);
                        fieldValidate();
                      },
                      validatior: (value) {
                        if (textEditingController.text.isEmpty) {
                          return "Enter a URL first !";
                        }
                        String y1 = "youtu.be";
                        String y2 = "youtube.com";
                        if (!textEditingController.text.contains("youtu")) {
                          return "Enter a YouTube URL !";
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      onPressed: fieldValidate,
                      child: const Text('Download')),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ));
  }

  void fieldValidate() {
    if (_globalKey.currentState!.validate()) {
      _validate();
    }
  }

  void _validate() async {
    setState(() {
      isLoading = true;
    });
    var data = await downloaderHelper
        .getVideoInfo(Uri.parse(textEditingController.text));
    setState(() {
      isLoading = false;
    });
    showModalBottomSheet(
        context: context,
        builder: (context) => MyBottomSheet(
              imageUrl: data['image'].toString(),
              title: data['title'],
              author: data["author"],
              duration: data['duration'].toString(),
              mp3Size: data['mp3'],
              mp4Size: data['mp4'],
              mp3Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Audio Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp3(data['id'], data['title']);
                setState(() {
                  isDowloanding = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('  Audio Downloaded')
                        ],
                      )));
                });
              },
              isDownloading: isDowloanding,
              mp4Method: () async {
                setState(() {
                  isDowloanding = true;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text('  Video Started Downloading')
                        ],
                      )));
                });
                await downloaderHelper.downloadMp4(data['id'], data['title']);
                setState(() {
                  isDowloanding = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.download_done,
                            color: Colors.green,
                            size: 30,
                          ),
                          Text('  Video Downloaded')
                        ],
                      )));
                });
              },
            ));
  }
}
