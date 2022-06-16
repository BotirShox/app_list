import 'package:api_list/src/api_pro/event_api_pro.dart';
import 'package:api_list/src/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/color.dart';
import 'guide_web.dart';

class LazyLoad extends StatefulWidget {

  const LazyLoad({Key key}) : super(key: key);

  @override
  _LazyLoadState createState() => _LazyLoadState();
}

class _LazyLoadState extends State<LazyLoad> {

  var isLoading = false;
  List guides;
  ScrollController _scrollController = ScrollController();
  int _currentMax = 6;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    guides = List.generate(_currentMax, (index) => "${index + 1}");
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  _getMoreData() {

    for (int index = _currentMax; index < _currentMax + 3; index++) {
      guides.add("${index + 1}");
    }
    _currentMax = _currentMax + 3;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actual Events:'),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.system_update_alt),
              onPressed: () async {
                bool req = await Permission.storage.request().isGranted;
                print(req);
                await _loadFromApi();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildEventListView(),
    );
  }

  _loadFromApi() async {

    setState(() {
      isLoading = true;
    });
    var apiProvider = EventApiProvider();
    await apiProvider.getAllEvents();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
    print('Events are saved');
  }

  _buildEventListView() {
    return FutureBuilder(
      future: Provider.db.getAllEvents(),
      builder: (BuildContext context, AsyncSnapshot arrayData) {
        if (!arrayData.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              if (index == arrayData.data.length) {
                return CupertinoActivityIndicator();
              }
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GuideWeb(url: "https://guidebook.com" + arrayData.data[index].url, Names: arrayData.data[index].name)
                      ));
                },
                title: Row(
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 50,
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(5),
                          image: DecorationImage(
                              image: NetworkImage(arrayData.data[index].icon)
                          )
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                            width: MediaQuery.of(context).size.width-120,
                            child: Text("${arrayData.data[index].name}", style: TextStyle(fontSize: 18, color: Colors.black87),)),
                        SizedBox(height: 10,),
                        Text("${arrayData.data[index].endDate}", style: TextStyle(color: Colors.purple,),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
            itemCount: arrayData.data.length + 1,
          );
        }
      },
    );
  }
}