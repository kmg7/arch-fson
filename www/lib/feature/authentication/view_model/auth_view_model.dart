import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';

import '../../../gen/translations.g.dart';
import '../../../utils/auth/auth_manager.dart';

part 'auth_view_model.g.dart';

class AuthViewModel = AuthViewModelBase with _$AuthViewModel;

abstract class AuthViewModelBase with Store {
  final auth = AuthManager.instance;

  @observable
  bool isLoading = false;

  @observable
  bool protocol = true; //true=>join, false=>setup

  @observable
  String buttonTitle = t.action.main.join;

  @observable
  String pageTitle = t.message.main.join;

  @observable
  String switchProtocolTitle = t.action.main.change_to_setup;

  String message = t.message.common.unexpected;

  @action
  void changeLoading() {
    isLoading = !isLoading;
  }

  @action
  void switchProtocol() {
    protocol = !protocol;
    if (protocol) {
      buttonTitle = t.action.main.join;
      pageTitle = t.message.main.join;
      switchProtocolTitle = t.action.main.change_to_setup;
    } else {
      buttonTitle = t.action.main.setup;
      pageTitle = t.message.main.setup;
      switchProtocolTitle = t.action.main.change_to_join;
    }
  }

  @action
  Future<bool> request(String code, String password) async {
    try {
      final response = protocol ? await auth.connect(code, password) : await auth.create(code, password);

      if (response.code == AuthResponseCode.success) {
        return true;
      } else {
        if (response.code == AuthResponseCode.notFound) {
          message = t.message.common.not_found;
        } else if (response.code == AuthResponseCode.badRequest && response.message != null) {
          message = response.message!;
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}
