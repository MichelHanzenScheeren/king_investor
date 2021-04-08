import 'package:king_investor/shared/notifications/notifiable.dart';

const emailRegex = r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]" +
    r"*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

class Contract extends Notifiable {
  Contract requires() => this;

  Contract isNotNull(var value, String property, String message) {
    if (value == null) addNotification(property, message);
    return this;
  }

  Contract isNotEmpty(String value, String property, String message) {
    if (value?.trim()?.length == 0) addNotification(property, message);
    return this;
  }

  Contract isNotNullOrEmpty(String value, String property, String message) {
    if (value == null || value?.trim()?.length == 0) addNotification(property, message);
    return this;
  }

  Contract minLength(String value, int min, String property, String message) {
    if (value == null) return this;
    if (value.trim().length < min) addNotification(property, message);
    return this;
  }

  Contract maxLength(String value, int max, String property, String message) {
    if (value == null) return this;
    if (value.trim().length > max) addNotification(property, message);
    return this;
  }

  Contract minAndMaxLength(String value, int min, int max, String property, String message) {
    if (value == null) return this;
    if (value.trim().length < min || value.trim().length > max) addNotification(property, message);
    return this;
  }

  Contract isValidEmail(String value, String property, String message) {
    if (value == null) return this;
    if (!RegExp(emailRegex).hasMatch(value)) addNotification(property, message);
    return this;
  }

  Contract isGreatherOrEqualTo(var value1, var value2, String property, String message) {
    if (value1 == null || value2 == null) return this;
    if (value1 < value2) addNotification(property, message);
    return this;
  }

  Contract canBeConvertedToDouble(String value, String property, String message) {
    if (value == null) return this;
    if (double.tryParse(value) == null) addNotification(property, message);
    return this;
  }
}
