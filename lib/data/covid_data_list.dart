import 'package:covid19_search/data/covid_data.dart';

class CovidDataList {
  List<CovidData> dataList;
  CovidDataList({this.dataList});

  factory CovidDataList.fromJson(List<dynamic> json) {
    List<CovidData> _list = List<CovidData>();
    json.toList().forEach((element) {
      final name = '${element['name_ja']}';
      final population = '${element['population']}';
      final cases = '${element['cases']}';
      final hospitalize = '${element['hospitalize']}';
      final severe = '${element['severe']}';
      final deaths = '${element['deaths']}';

      _list.add(CovidData(
        name: name,
        population: int.parse(population),
        cases: int.parse(cases),
        hospitalize: int.parse(hospitalize),
        severe: int.parse(severe),
        deaths: int.parse(deaths),
      ));
    });
    return CovidDataList(dataList: _list);
  }
}