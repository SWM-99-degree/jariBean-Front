import 'package:flutter/material.dart';

class KakaoMapView extends StatefulWidget {
  const KakaoMapView({Key? key}) : super(key: key);

  @override
  State<KakaoMapView> createState() => _KakaoMapViewState();
}

class _KakaoMapViewState extends State<KakaoMapView> {
  @override
  Widget build(BuildContext context) {
    return Text('카카오 지도');
  }
}
