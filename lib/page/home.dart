import 'package:flutter/cupertino.dart';

import '../models/download_helper.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  DownloaderHelper downloaderHelper = DownloaderHelper();
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  bool? isDowloanding;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
