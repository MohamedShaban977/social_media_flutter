import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/enums/account_mode.dart';

/// account mode provider to check if the user is authorized or not
/// added logic to check if the user is authorized or not based on the token
/// TODO:don't forget add logic to checked if the user is authorized in => ( logout, change password )
/// hwo to check if the user is authorized or not
/// if(ref.read([AccountViewModel.accountModeProvider]) == [AccountMode.authorized]){
//  enter code here
//  }
//  else {
//  enter another code here
//  }

class AccountViewModel {
  static final accountModeProvider = StateProvider<AccountMode>((ref) => AccountMode.unauthorized);
}
