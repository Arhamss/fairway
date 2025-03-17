enum ChannelType {
  standardGroup,
  premiumGroup,
  premiumIndividualClass,
  oneToOneChat,
  unknown,
}

ChannelType getChannelType(String type) {
  switch (type) {
    case 'standard_group':
      return ChannelType.standardGroup;
    case 'premium_group':
      return ChannelType.premiumGroup;
    case 'premium_individual_class':
      return ChannelType.premiumIndividualClass;
    case 'one_to_one_chat':
      return ChannelType.oneToOneChat;
    default:
      return ChannelType.unknown;
  }
}

ChannelType getChannelTypeFromGroupType(bool groupType) {
  switch (groupType) {
    case true:
      return ChannelType.standardGroup;
    case false:
      return ChannelType.premiumGroup;
  }
}

String getChannelStringFromGroupType(bool groupType) {
  switch (groupType) {
    case false:
      return 'standard_group';
    case true:
      return 'premium_group';
  }
}

extension ChannelTypeExtension on ChannelType {
  String get stringValue {
    switch (this) {
      case ChannelType.standardGroup:
        return 'standard_group';
      case ChannelType.premiumGroup:
        return 'premium_group';
      case ChannelType.premiumIndividualClass:
        return 'premium_individual_class';
      case ChannelType.oneToOneChat:
        return 'one_to_one_chat';
      default:
        return 'unknown';
    }
  }
}
