enum NotificationType {
  classIsStarting,
  newCreditsAdded,
  resourceSentByTutor,
  classSlotsCompleted,
  groupClassThresholdMet,
  paymentCouldNotGoThrough,
  paymentWasSuccessful,
  someoneJoinedYourGroup,
  someoneJoinedYourClass,
  messageNew,
  unknown,
}

class NotificationHelper {
  static NotificationType? getNotificationType(String type) {
    final normalizedType = type.toLowerCase().replaceAll(' ', '').trim();
    switch (normalizedType) {
      case 'class_is_starting':
        return NotificationType.classIsStarting;
      case 'new_credits_added':
        return NotificationType.newCreditsAdded;
      case 'resource_sent_by_tutor':
        return NotificationType.resourceSentByTutor;
      case 'class_slots_completed':
        return NotificationType.classSlotsCompleted;
      case 'group_class_threshold_met':
        return NotificationType.groupClassThresholdMet;
      case 'payment_could_not_go_through':
        return NotificationType.paymentCouldNotGoThrough;
      case 'payment_was_successful':
        return NotificationType.paymentWasSuccessful;
      case 'someone_joined_your_group':
        return NotificationType.someoneJoinedYourGroup;
      case 'someone_joined_your_class':
        return NotificationType.someoneJoinedYourClass;
      case 'message.new':
        return NotificationType.messageNew;
      default:
        return NotificationType.unknown;
    }
  }

  static String notificationTypeToString(NotificationType type) {
    switch (type) {
      case NotificationType.classIsStarting:
        return 'CLASS_IS_STARTING';
      case NotificationType.newCreditsAdded:
        return 'NEW_CREDITS_ADDED';
      case NotificationType.resourceSentByTutor:
        return 'RESOURCE_SENT_BY_TUTOR';
      case NotificationType.classSlotsCompleted:
        return 'CLASS_SLOTS_COMPLETED';
      case NotificationType.groupClassThresholdMet:
        return 'GROUP_CLASS_THRESHOLD_MET';
      case NotificationType.paymentCouldNotGoThrough:
        return 'PAYMENT_COULD_NOT_GO_THROUGH';
      case NotificationType.paymentWasSuccessful:
        return 'PAYMENT_WAS_SUCCESSFUL';
      case NotificationType.someoneJoinedYourGroup:
        return 'SOMEONE_JOINED_YOUR_GROUP';
      case NotificationType.someoneJoinedYourClass:
        return 'SOMEONE_JOINED_YOUR_CLASS';
      case NotificationType.messageNew:
        return 'message.new';
      case NotificationType.unknown:
        return 'Unknown';
    }
  }
}
