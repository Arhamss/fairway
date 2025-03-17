import 'package:flutter/material.dart';

class FieldValidators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Please enter a password greater than 6 characters';
    }
    if (value.length > 100) {
      return 'Please enter a password less than 100 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(
    String? value,
    TextEditingController passwordController,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the name';
    }
    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }
    if (value.length > 30) {
      return 'Name must be less than 30 characters';
    }
    return null;
  }

  static String? textValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the text';
    }
    return null;
  }

  static String? numberValidator(
    String? value, {
    int? min,
    int? max,
  }) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }

    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (min != null && number < min) {
      return 'Number must be greater than or equal to $min';
    }

    if (max != null && number > max) {
      return 'Number must be less than or equal to $max';
    }

    return null;
  }

  static String? dateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a date';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Please enter a valid date';
    }

    if (date.isBefore(DateTime.now())) {
      return 'Date must be greater than or equal to today';
    }

    return null;
  }

  static String? timeValidator(String? value, DateTime? date) {
    if (value == null || value.isEmpty) {
      return 'Please enter a time';
    }

    final timeParts = value.split(':');
    if (timeParts.length != 2) {
      return 'Please enter a valid time in format';
    }

    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return 'Please enter a valid time';
    }

    if (date != null) {
      final enteredDateTime =
          DateTime(date.year, date.month, date.day, hour, minute);
      final now = DateTime.now();
      if (enteredDateTime.isBefore(now)) {
        return 'Time must be greater than or equal to now';
      }
    }

    return null;
  }
}
