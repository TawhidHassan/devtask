import 'package:flutter/material.dart';

class ConectivityWidget extends StatelessWidget {
  final Color colors;
  final Color colors2;
  final String text;

  const ConectivityWidget({Key? key, required this.colors, required this.colors2,  required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
                decoration:  BoxDecoration(
                  color: colors2,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check,color:colors==null?Colors.white:colors,)),
            Text(text)
          ],
        ),
      ),
    );
  }
}
