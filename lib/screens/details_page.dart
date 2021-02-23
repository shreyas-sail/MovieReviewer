import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Details extends StatefulWidget {

  @override
  _DetailsState createState() => _DetailsState();
}


class _DetailsState extends State<Details> {
//  StreamController _streamController;
//  Stream _stream;
  String base_url2='http://www.omdbapi.com/?apikey=935e6a11&';
  Map ombdMap={};
  Future<dynamic> ombdMapFinal;
  Map data={};
  String image_url;
  String g_url='https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482930.jpg';

//  _searchDetails(String name ) async {
//    if (name == null ) {
//      return;
//    } else {
//      Response resp = await get(base_url2 +
//          's=' +
//          name );
//      print('Reached');
//      print(resp.body);
//      ombdMap=jsonDecode(resp.body);
//      return ombdMap;
//    }
//  }
//  _callMethod() async{
//    Map xyz= await _searchDetails('Thor') ;
//    final image_url=xyz['Search'][0]['Poster'];
//    print(image_url);
//
//  }






//  @override
//  void initState() {
//    super.initState();
//
//    ombdMapFinal= _callMethod();
//    print('init');
//
//  }




  @override
  Widget build(BuildContext context) {
    data=ModalRoute.of(context).settings.arguments;
    print('Main');
    //print(image_url);
    return Scaffold(
        appBar: AppBar(
          title: Text(data['Name']),
          ),
          body:SingleChildScrollView(

                child: Container(
                  child: Card(
                    child: Column(


                      children: [

                        Padding(
                          padding: const EdgeInsets.fromLTRB(135.0, 10.0, 135.0, 0.0),

                          child: Image.network(
                              data['image_link']==null? 'https://st.depositphotos.com/1987177/3470/v/600/depositphotos_34700099-stock-illustration-no-photo-available-or-missing.jpg' :data['image_link'],
                              errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                return Text('No Image Found');
                              }
                          ),

                          //Image.network(data['image_link']==null? g_url:data['image_link']),==null? g_url:data['image_link']


//                          Image(
//                              image:data['image_link']==null? NetworkImage(g_url):NetworkImage(data['image_link']),
//                          )
//                          CircleAvatar(
//                            radius: 40.0,
//                            backgroundColor: Colors.blueAccent,
//                           backgroundImage: data['image_link']==null? NetworkImage(g_url):NetworkImage(data['image_link']),
//                          ),
                        ),
                         SizedBox(height: 20.0,),




                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                    'Description',
                                    style: TextStyle(
                                        fontFamily: 'LuckiestGuy', fontSize: 25.0),

                                  ),
                          ),


                        SizedBox(height: 20.0,),

                         Text(
                                data['Description'],
                             style: TextStyle(
                               fontSize: 15.0,
                               fontFamily: 'Montserrat',
                               color: Colors.black
                             ),
                              ),

                        SizedBox(height: 25.0,),
                        Container(
                          //color: Colors.red,
                          child: Row(
                            children: [


                               Container(
                                 foregroundDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                 ),
                                 color:Colors.red,
                                 child: FlatButton.icon(
                                      onPressed: (){
                                        _open_yt(data['yt_link']);
                                      },
                                      icon: Icon(
                                      Icons.video_library
                                  ),
                                      label: Text('Watch Trailer on Youtube')
                                  ),
                               ),

                                SizedBox(width: 10.0,),
                                Container(
                                  color: Colors.blue,
                                  child: FlatButton.icon(
                                      onPressed: (){
                                        _open_wiki(data['wiki_link']);
                                      },
                                      icon: Icon(
                                        Icons.rate_review,
                                      ),
                                      label: Text('Wikipedia')
                                  ),
                                ),

                            ],
                          ),
                        ),






                      ],

                    ),
                  ),
                ),
              )
    );
}
  Future <void> _open_yt(String urlR) async{
    if(await canLaunch(urlR) ) {
      await launch(urlR, forceSafariVC: true, forceWebView: true);
    }else{
      throw "Cannot redirect to $urlR";
    }
  }

  Future <void> _open_wiki(String urlR) async{
    if(await canLaunch(urlR) ) {
    await launch(urlR, forceSafariVC: false, forceWebView: false);
    }else{
    throw "Cannot redirect to $urlR";
    }


  }
}
