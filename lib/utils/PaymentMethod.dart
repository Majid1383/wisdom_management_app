enum PaymentMethod {
  cash,
  upi,
  online,
}

extension PaymentMethodExtension on PaymentMethod {
  String get name {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.online:
        return 'Online';
    }
  }

  static PaymentMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'upi':
        return PaymentMethod.upi;
      case 'online':
        return PaymentMethod.online;
      default:
        return PaymentMethod.cash; // fallback
    }
  }
}
