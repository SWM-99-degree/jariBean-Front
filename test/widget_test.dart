// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:jari_bean/cafe/screen/cafe_detail_info_screen.dart';
// import 'package:jari_bean/common/layout/default_screen_layout.dart';

// void main() {
//   testWidgets('CafeDetailTableScreen has its info', (tester) async {
//     await tester.pumpWidget(
//       defaultTestableWidgetBuilder(
//         CafeDetailInfoScreen(
//           cafeId: '123',
//           cafeAddress: '부평',
//           cafePhoneNumber: '0102814',
//           cafeRunTime: '00~24',
//           cafeUrl: 'http://google.com',
//         ),
//       ),
//     );

//     expect(find.text('부평'), findsOneWidget);
//     expect(find.text('00~24'), findsOneWidget);
//     expect(find.textContaining('0102814', findRichText: true), findsOneWidget);
//     expect(
//       find.textContaining('http://google.com', findRichText: true),
//       findsOneWidget,
//     );
//   });
// }

// Widget defaultTestableWidgetBuilder(Widget widget) {
//   return ProviderScope(
//     child: ScreenUtilInit(
//       designSize: const Size(375, 812),
//       builder: (context, child) => MaterialApp(
//         builder: (context, child) => MediaQuery(
//           data: MediaQuery.of(context).copyWith(
//             textScaleFactor: 1.0,
//           ),
//           child: DefaultLayout(
//             child: widget,
//           ),
//         ),
//       ),
//     ),
//   );
// }

// import 'package:jari_bean/alert/model/alert_model.dart';
// import 'package:jari_bean/common/models/fcm_message_model.dart';

void main() async {
  // final model = ReservationDataModel.fromJson({
  //   "reserveId": "6510dffd05e62d52edc13edc",
  //   "reserveStartTime": "2023-09-29T06:00:00",
  //   "reserveEndTime": "2023-09-29T08:00:00",
  //   "matchingSeating": 5,
  //   "cafeSummaryDto": {
  //     "id": "64fd48821a11b172e165f2fd",
  //     "name": "스타벅스 테헤란로아남타워점",
  //     "address": "아남타워빌딩 1층",
  //     "imageUrl": "https://picsum.photos/50/50"
  //   }
  // });
  // print(model);
  // final container = ProviderContainer();
  // final AlertRepository alert = await container.read(alertRepositoryProvider);

  // //create 300 random id alerts and insert to db
  // for (int i = 0; i < 300; i++) {
  //   AlertModel alertModel = AlertModel(
  //     id: i.toString(),
  //     title: '자리빈에 오신것을 환영합니다',
  //     isRead: false,
  //     body: '메뚜기 월드에 오신걸 환영합니다~',
  //     type: PushMessageType.announcement,
  //     receivedAt: DateTime.now(),
  //     detailedBody: 'detailedBody',
  //     data: FcmDataModelBase(),
  //   );
  //   await alert.insertAlert(alertModel);
  // }

  // //get alerts using cursor pagination
  // List<AlertModel> alerts = await alert.getAlerts(0);
  // print(alerts.length); //10
  // print(alerts[0].id); //299
  // print(alerts[9].id); //290

  // alerts = await alert.getAlerts(10);
  // print(alerts.length); //10
  // print(alerts[0].id); //289
  // print(alerts[9].id); //280

  // alerts = await alert.getAlerts(20);
  // print(alerts.length); //10
  // print(alerts[0].id); //279
  // print(alerts[9].id); //270

  // alerts = await alert.getAlerts(30);
  // print(alerts.length); //10
  // print(alerts[0].id); //269
  // print(alerts[9].id); //260

  // // marking alert as read
  // await alert.markAsRead('299');

  // // delete test
  // await alert.deleteAlert('299');
  // alerts = await alert.getAlerts(0);
}
