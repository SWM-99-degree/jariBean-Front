import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/user/models/agreement_model.dart';

final totalAgreementProvider = StateNotifierProvider.autoDispose<
    TotalAgreementStateNotifier, List<AgreementModel>>((ref) {
  return TotalAgreementStateNotifier();
});

class TotalAgreementStateNotifier extends StateNotifier<List<AgreementModel>> {
  TotalAgreementStateNotifier() : super([]) {
    initAgreement();
  }

  void initAgreement() {
    state = [
      AgreementModel(
        id: '0',
        title: '[필수] 이용약관 동의',
        url: linkTermsOfUse,
        isMandatory: true,
        isAgreed: false,
      ),
      AgreementModel(
        id: '1',
        title: '[필수] 개인정보 수집 및 이용 동의',
        url: linkPrivacy,
        isMandatory: true,
        isAgreed: false,
      ),
      AgreementModel(
        id: '2',
        title: '[필수] 개인정보 제3자 제공 동의',
        url: linkPrivacy,
        isMandatory: true,
        isAgreed: false,
      ),
    ];
  }

  void toggleAgreement(int index) {
    state[index].isAgreed = !state[index].isAgreed;
    state = [...state];
  }

  void agreeAll() {
    state = state.map((e) => e..isAgreed = true).toList();
  }

  void disagreeNotMandatory() {
    state = state.map((e) {
      if (!e.isMandatory) {
        e.isAgreed = false;
      }
      return e;
    }).toList();
  }

  bool get isAllAgreed {
    return state.every((e) => e.isAgreed);
  }

  bool get isAllMandatoryAgreed {
    return state.every(
      (e) {
        if (e.isMandatory) {
          return e.isAgreed;
        }
        return true;
      },
    );
  }

  String get buttonText {
    return isAllMandatoryAgreed ? '회원 가입하기' : '전체 동의하기';
  }
}
