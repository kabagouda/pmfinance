import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pmfinance/src/functions/api_manager.dart';
import 'package:pmfinance/src/models/products.dart';
import 'package:http/http.dart' as http;

import '../gen/assets.gen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  /// Static named route for page
  static const String route = 'home';

  /// Static method to return the widget as a PageRoute
  static Route go() => MaterialPageRoute<void>(builder: (_) => const HomePage());
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var dio = Dio();
  @override
  void initState() {
    // dio.interceptors.add(DioNetworkLogger());
    // NetworkLoggerOverlay.attachTo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.purple,
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: Text('Mode Admin'),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: http.get(Uri.parse('${baseUrl}products')),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purple,
                ),
              );
            } else if (snapshot.hasError) {
              return const SafeArea(
                child: Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.purple, size: 100),
                        SizedBox(height: 20),
                        Text('Erreur de connexion'),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              var jsonResponse = jsonDecode(snapshot.data!.body);
              List<Product> products = [];
              for (var productJson in jsonResponse) {
                var product = Product.fromJson(productJson);
                products.add(product);
              }
              return HomePageHead(products: products);
            } else {
              return const Center(
                child: Text('Désolé , une erreur s\'est produite , réessayer'),
              );
            }
          },
        ),
      ),
    );
  }
}

class HomePageHead extends StatefulWidget {
  final List<Product> products;
  const HomePageHead({required this.products, Key? key}) : super(key: key);

  @override
  State<HomePageHead> createState() => _HomePageHeadState();
}

class _HomePageHeadState extends State<HomePageHead> {
  @override
  Widget build(BuildContext context) {
    final listOfData = widget.products;
    final width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Row widget with children Drawer icon and Notification icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: IconButton(
                  icon: const Icon(Icons.menu, size: 28),
                  onPressed: () {
                    // Scaffold.of(context).openDrawer();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
                child: IconButton(
                  icon: const Icon(Icons.notifications, size: 28),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          // Search bar with search icon at the left
          Padding(
            padding: EdgeInsets.only(top: height * 0.01, left: width * 0.05, right: width * 0.05),
            child: Container(
              height: height * 0.08,
              width: width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  // Textfield at the right and Icon inside a purple container at the left
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: width * 0.05),
                      child: const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Rechercher',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.05),
                    child: Container(
                      height: height * 0.05,
                      width: height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Text widget with title
          Padding(
            padding: EdgeInsets.only(
              top: height * 0.01,
              left: width * 0.05,
            ),
            child: const Text(
              'Explorer',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Little text : les plus vues
          Padding(
            padding: EdgeInsets.only(top: height * 0.01, left: width * 0.05),
            child: const Text(
              'Les plus vues',
              style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          // a container containing 4 images with a carousel slider widget
          SizedBox(
            height: height * 0.2,
            child: CarouselSlider(
              options: CarouselOptions(
                height: height * 0.3,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
              items: listOfData.map((product) {
                return Builder(
                  builder: (BuildContext context) {
                    return
                        // a stack of a container and a column of two texts at the bottom right
                        product.image!.firstOrNull == null
                            ? const SizedBox.shrink()
                            : Stack(
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(product.image!.first.convertedImageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(left: width * 0.05, bottom: height * 0.01),
                                          child: Text(
                                            // '${i['type']} à ${i['ville']}',
                                            "${product.type} à ${product.city}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: width * 0.05, bottom: height * 0.01),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 1),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '${product.price} FCFA',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                  },
                );
              }).toList(),
            ),
          ),
          // Little text : Catégories
          Padding(
            padding: EdgeInsets.only(top: height * 0.01, bottom: height * 0.01, left: width * 0.05),
            child: const Text(
              'Catégories',
              style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          // Two row widgets with two rows of purple container containing home icon and a little bit title
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05, right: width * 0.02),
              child: Container(
                height: height * 0.08,
                width: width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image(
                      image: AssetImage(Assets.icons.house1.path),
                      height: height * 0.04,
                    ),
                    const Text(
                      'Maisons',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: width * 0.05, left: width * 0.02),
              child: Container(
                height: height * 0.08,
                width: width * 0.4,
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                  Image(
                    image: AssetImage(Assets.icons.appartment1.path),
                    height: height * 0.05,
                  ),
                  const Text(
                    'Appartements',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ]),
              ),
            ),
          ]),
          //  Proche de chez vous
          Padding(
            padding: EdgeInsets.only(top: height * 0.01, bottom: height * 0.01, left: width * 0.05),
            child: const Text(
              'Proche de chez vous',
              style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),

          // a listview builder inside this listview with a container with a stack of an image and a column of two texts at the bottom right
          ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: min(
              4,
              listOfData.length,
            ),
            itemBuilder: (context, index) {
              var random = Random();
              List extractRandomListIndex = List.generate(
                  min(
                    4,
                    listOfData.length,
                  ), (i) {
                return random.nextInt(listOfData.length);
              });
              final extractRandomList = List.generate(
                  min(
                    4,
                    listOfData.length,
                  ), (i) {
                return listOfData[extractRandomListIndex[i]];
              });
              return extractRandomList[index].image?.first == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: EdgeInsets.all(width * 0.03),
                      child: Container(
                        height: height * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(extractRandomList[index].image!.first.convertedImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: width * 0.05, bottom: height * 0.01),
                                    child: Text(
                                      '${extractRandomList[index].type} à ${extractRandomList[index].city}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: width * 0.05, bottom: height * 0.01),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${extractRandomList[index].price} FCFA',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
