import 'package:starlight_utils/starlight_utils.dart';

String? emailValidator(String? value) => value?.isEmpty == true
    ? 'Email is required'
    : value?.isEmail == true
        ? null
        : 'Invalid email';
String? passwordValidator(String? value,
        {bool checkPass = false, String? checkValue}) =>
    value?.isEmpty == true
        ? 'Password is required'
        : checkPass == true
            ? checkValue != value
                ? 'Password must be same!'
                : null
            : value?.isStrongPassword();
