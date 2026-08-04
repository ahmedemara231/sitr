enum ScreenType { subscription, renew }

extension ScreenTypeCheck on ScreenType {
  bool get isSubscription => this == ScreenType.subscription;
  bool get isRenew => this == ScreenType.renew;
}
