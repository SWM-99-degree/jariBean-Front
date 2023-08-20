import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/component/home_pointing_triangle.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/provider/home_selection_provider.dart';
import 'package:jari_bean/matching/screen/matching_home_screen.dart';
import 'package:jari_bean/reservation/screen/reservation_home_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.86, -0.52),
          end: Alignment(-0.86, 0.52),
          colors: const [PRIMARY_YELLOW, PRIMARY_ORANGE],
        ),
      ),
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildMenuBarItem(
                  title: '자리 예약하기',
                  updateFunction: () {
                    ref
                        .read(homeSelectionProvider.notifier)
                        .update(HomeSelection.reservation);
                  },
                  homeSelectionState: ref.watch(homeSelectionProvider),
                  homeSelectionValue: HomeSelection.reservation,
                ),
                buildMenuBarItem(
                  title: '실시간 매칭하기',
                  updateFunction: () {
                    ref
                        .read(homeSelectionProvider.notifier)
                        .update(HomeSelection.matching);
                  },
                  homeSelectionState: ref.watch(homeSelectionProvider),
                  homeSelectionValue: HomeSelection.matching,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 9,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child:
                  ref.watch(homeSelectionProvider) == HomeSelection.reservation
                      ? ReservationHomeScreen()
                      : MatchingHomeScreen(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuBarItem({
    required String title,
    required Function()? updateFunction,
    required HomeSelection homeSelectionState,
    required HomeSelection homeSelectionValue,
  }) {
    return Expanded(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Center(
              child: TextButton(
                onPressed: updateFunction,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(
                      homeSelectionState == homeSelectionValue ? 1 : 0.5,
                    ),
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w800,
                    fontSize: 18 * 1.2,
                  ),
                ),
              ),
            ),
            HomePointingTriangle(
              isActive: homeSelectionState == homeSelectionValue,
            ),
          ],
        ),
      ),
    );
  }
}
