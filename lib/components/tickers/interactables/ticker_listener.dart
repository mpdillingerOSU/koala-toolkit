import 'package:flutter/material.dart';
import 'package:gaming_toolkit/components/tickers/interactables/ticker_notification.dart';

class TickerListener extends NotificationListener<TickerNotification> {
  const TickerListener({
    super.key,
    required super.onNotification,
    required super.child,
  });
}
