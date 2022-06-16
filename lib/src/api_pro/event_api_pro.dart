import 'package:api_list/model/events_model.dart';
import 'package:api_list/src/provider.dart';
import 'package:dio/dio.dart';

class EventApiProvider {

  Future<List<Events>> getAllEvents() async {

    var url = "https://guidebook.com/service/v2/upcomingGuides/";
    Response response = await Dio().get(url);
    print("Response from request: \n ${response.data}");

    return (response.data['data'] as List).map((event) {

      print('Inserting: \n $event');
      Provider.db.createEvents(Events.fromJson(event));
      print('$event is created');
    }).toList();
  }
}