import 'dart:convert';
import 'package:covid19_search/models/prefecture_model.dart';
import 'package:covid19_search/pages/covid_list.dart';
import 'package:flutter/cupertino.dart';

import 'data/covid_data.dart';
import 'data/covid_data_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MyHomePage> {
  Future<CovidDataList> dataList;

  @override
  void initState() {
    super.initState();
    dataList = fetch();
  }

  Future<CovidDataList> fetch() async {
    final response = await http.get('https://covid19-japan-web-api.now.sh/api/v1/prefectures');
    if (response.statusCode != 200) {
      throw Exception('${response.statusCode}');
    }
    final json = jsonDecode(response.body);
    return CovidDataList.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('今日のコロナ情報'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 150,),
          _PrefecturesTextField(dataList: dataList,),
          const SizedBox(height: 150,),
          _AllButton(dataList: dataList,)
        ],
      ),
    );
  }
}

class _PrefecturesTextField extends StatelessWidget {
  _PrefecturesTextField({this.dataList});
  Future<CovidDataList> dataList;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final list = PrefectureModel.prefectures.map((prefecture) => Text(prefecture)).toList();
    var selectedIndex = 0;

    return Center(
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: '都道府県別に調べる',
          ),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height / 3,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: CupertinoButton(
                              child: Text('完了'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                            child: Container(
                              color: CupertinoColors.systemGrey2,
                              child: CupertinoPicker(
                                itemExtent: 32,
                                children: list,
                                onSelectedItemChanged: (index) {
                                  selectedIndex = index;
                                },
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).then((_) {
              _controller.value = TextEditingValue(text: list[selectedIndex].data);
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) {
                        return CovidList(dataList: dataList, prefecture: list[selectedIndex].data,);
                      }
                  )
              );
            });
          },
        ),
      ),
    );
  }
}

class _AllButton extends StatelessWidget {
  _AllButton({this.dataList});
  Future<CovidDataList> dataList;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('全国一覧画面へ'),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) {
                    return CovidList(dataList: dataList, prefecture: '',);
                  }
              )
          );
        }
    );
  }
}
