
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

final webAuthProvider = Provider<FlutterWebAuth>((ref) {
  return FlutterWebAuth();
});