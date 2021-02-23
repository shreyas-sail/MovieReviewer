import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
Home({Key key}) : super(key: key);

@override
_HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
final TextEditingController _controller = TextEditingController();
String base_url = 'https://tastedive.com/api/similar?';
//String base_url2='http://www.omdbapi.com/?apikey=935e6a11&';
String api_key = '384111-coursera-G4UFO3GJ';

StreamController _streamController;
Stream _stream;

@override
void initState() {
  super.initState();
  print('INIT');

  _streamController = StreamController();
  _stream = _streamController.stream;
}
Timer _debounce;
_search() async {
  if (_controller.text == null || _controller.text.length == 0) {
    _streamController.add(null);
    return;
  }
    _streamController.add("Waiting");
    Response resp = await get(base_url +
        'q=' +
        _controller.text.trim() +
        '&k=' +
        api_key +
        '&info=1');
    print(resp.body);
    return _streamController.add(json.decode(resp.body));

}



String base_url2='http://www.omdbapi.com/?apikey=935e6a11&';
Map ombdMap={};
Future<dynamic> ombdMapFinal;
String _image_url='';


_searchDetails(String name ) async {
  if (name == null ) {
    return;
  } else {
    Response resp = await get(base_url2 +
        's=' +
        name );
    print('Reached');
    print(resp.body);
    ombdMap=jsonDecode(resp.body);
    return ombdMap;
  }
}

  _callMethod(String mainName) async{
    Map xyz= await _searchDetails(mainName) ;
    _image_url=xyz['Search'][0]['Poster'];
  }
//

//_searchDetails(String name ) async {
//  if (name == null ) {
//    _streamController.add(null);
//    return;
//  } else {
//    Response resp = await get(base_url2 +
//        's=' +
//        name );
//    print(resp.body);
//    return _streamController.add(json.decode(resp.body));
//  }
//}

@override
Widget build(BuildContext context) {
  print('HOME');
  return Scaffold(
    appBar: AppBar(
      title: Center(
        child: Text(
          'MOVIFY',
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Column(
            children: [
              Container(
                height: 10.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 300.0,
                      margin: EdgeInsets.only(left: 5.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        onChanged: (String text) {
                          if (_debounce?.isActive ?? false) _debounce.cancel();
                          _debounce = Timer(const Duration(milliseconds: 1000), () {
                            _search();
                          });
                        },
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: '  Enter Movie/Show Name',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 30.0,
                    ),
                    onPressed: () {
                      _search();
                      print(_controller.text);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    body: StreamBuilder(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Text(
                'Enter a Movie Name',
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Montserrat',
                ),
              ),
            );
          }

          if (snapshot.data == "Waiting") {
            return Center(
              child: SpinKitRotatingCircle(
                color: Colors.black,
                size: 50.0,
              ),
            );
          }

          if (snapshot.data['Similar']['Results'].length == 0) {
            return Center(
              child: Text('No Results Found'),
            );
          }






            return Column(
              children: [
              Text(
              'Related Movies',
              style: TextStyle(
                fontSize: 30.0,
                fontFamily: 'Montserrat',
              ),
              ),

              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data['Similar']['Results'].length,
                    itemBuilder: (BuildContext context, int index) {


                      return ListBody(
                          children: <Widget>[

                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: InkWell(
                            onTap: () {},
                            child: Card(
                                color: Colors.yellowAccent,
                                elevation: 3.0,
                                child: ListTile(
                                  onTap: (){
                                    _callMethod(snapshot.data['Similar']['Results'][index]['Name']);
                                     Navigator.pushNamed(context, '/details',arguments: {
                                    'Name':snapshot.data['Similar']['Results'][index]['Name'],
                                    'Description':snapshot.data['Similar']['Results'][index]['wTeaser'],
                                    'type':snapshot.data['Similar']['Results'][index]['Type'],
                                    'yt_link':snapshot.data['Similar']['Results'][index]['yUrl'],
                                    'wiki_link':snapshot.data['Similar']['Results'][index]['wUrl'],
                                    'image_link':_image_url,
                                  });
                                  },
                                  leading: CircleAvatar(
                                      radius: 20.0, child: Icon(Icons.movie)),
                                  title: Text(
                                    snapshot.data['Similar']['Results'][index]
                                        ['Name'],
                                    style: TextStyle(
                                        fontFamily: 'LuckiestGuy', fontSize: 15.0),
                                  ),
                                  trailing: Text(
                                    snapshot.data['Similar']['Results'][index]
                                        ['Type'],
                                    style: TextStyle(
                                        fontFamily: 'LuckiestGuy', fontSize: 15.0),
                                  ),

                                ),
                            ),
                          ),
                        ),
                      ]);
                    }),
              ),
              ],
            );
        }),
  );
}
}
