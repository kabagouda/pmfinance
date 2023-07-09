import 'package:flutter/material.dart';

class DetailAnnonce extends StatefulWidget {
  const DetailAnnonce({Key? key}) : super(key: key);

  @override
  _DetailAnnonceState createState() => _DetailAnnonceState();
}

class _DetailAnnonceState extends State<DetailAnnonce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // Column with horizontal listview builder and a column of information
            Column(
      children: <Widget>[
        // Horizontal listview builder
        SizedBox(
          height: MediaQuery.of(context).size.height * 1 / 3,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.height,
                height: MediaQuery.of(context).size.height * 1 / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/image3.png'),
                    fit: BoxFit.none,
                  ),
                ),
              );
            },
          ),
        ),
        // Column of information
        SizedBox(
          height: MediaQuery.of(context).size.height * 2 / 3,
          child: const Column(
            children: <Widget>[
              // Row of information
              Row(children: <Widget>[
                // Column of information
                Text(
                  'Maison à lomé',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  '10000/m',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ])
            ],
          ),
        ),
      ],
    ));
  }
}
