import 'package:covid19_search/data/covid_data.dart';
import 'package:flutter/material.dart';
import 'package:covid19_search/data/covid_data_list.dart';

class CovidList extends StatelessWidget {
  CovidList({this.dataList, this.prefecture});

  Future<CovidDataList> dataList;
  String prefecture;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('全国のコロナ情報'),
      ),
      body: Center(
        child: FutureBuilder<CovidDataList>(
          future: dataList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var _showData = snapshot.data.dataList;
              if (prefecture.isNotEmpty) {
                // 都道府県を選択した場合はここで１つに絞る
                final _data = _showData.firstWhere((element) => element.name == prefecture);
                _showData = [CovidData(
                  name: _data.name,
                  population: _data.population,
                  cases: _data.cases,
                  hospitalize: _data.hospitalize,
                  severe: _data.severe,
                  deaths: _data.deaths,
                )];
              }
              return Container(
                child: Column(
                  children: [
                    Text(
                      '${now.year}-${now.month}-${now.day}',
                      style: TextStyle(fontSize: 25),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _showData.length,
                        itemBuilder: (context, index) {
                          final data = _showData[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data.name}',
                                style: TextStyle(fontSize: 25),
                              ),
                              Text(
                                '陽性者:${data.cases}(${(data.cases/data.population).toStringAsFixed(5)}%)',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '入院者:${data.hospitalize}',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '重傷者:${data.severe}',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '死者:${data.deaths}',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 20,),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text('${snapshot.error}');
            }
          },
        ),
      ),
    );
  }
}
