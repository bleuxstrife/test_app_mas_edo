import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertestapp/boilerplates/view.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends View<MainScreen> {
  int _current = 0;
  final List<Widget> imageSliders = imgList
      .map((item) => Container(
    child: Container(
      margin: EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(item, fit: BoxFit.cover, width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'No. ${imgList.indexOf(item)} image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    ),
  ))
      .toList();


  @override
  void initStateWithContext(BuildContext context) {
    super.initStateWithContext(context);
  }

  @override
  Widget buildView(BuildContext context) {
    // TODO: implement buildView
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Image.asset(
              'images/pertamina-logo.png',
              width: 200,
              height: 53,
              fit: BoxFit.cover,
            ),
            margin: const EdgeInsets.all(40.0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 1.0),
                )
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.stars),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credit Limit',
                      style:
                      TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          'IDR',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          '130.250.000',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    )
                  ],
                ),
                VerticalDivider(),
                Icon(Icons.notifications_active),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Piutang',
                      style:
                      TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          'IDR',
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Text(
                          '50.320.100',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            margin: const EdgeInsets.all(40.0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.local_shipping),
                          onPressed: () {},
                        ),
                        Text(
                          'SO Monitoring',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.payment),
                          onPressed: () {},
                        ),
                        Text(
                          'Invoice Monitoring',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.note),
                          onPressed: () {},
                        ),
                        Text(
                          'eFaktur Monitoring',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        )
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 60.0,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.local_printshop),
                          onPressed: () {},
                        ),
                        Text(
                          'Bupot PPh22',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.file_upload),
                          onPressed: () {},
                        ),
                        Text(
                          'Mass Payment',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.history),
                          onPressed: () {},
                        ),
                        Text(
                          'History Transaksi',
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            margin: const EdgeInsets.all(40.0),
            alignment: Alignment.centerLeft,
          ),
          Container(
            color: Colors.grey,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                  items: imageSliders,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: false,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                  items: imageSliders,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imgList.map((url) {
                    int index = imgList.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            title: Text('Bantuan'),
          ),
        ],
      ),
    );
  }
}


