class ConnectorState {
  final String? address;

  bool get connected => address != null;

  ConnectorState._({required this.address});

  factory ConnectorState.initial({required String? address}) =>
      ConnectorState._(address: address);

  ConnectorState clone({bool? connected, String? address}) {
    return ConnectorState._(address: address);
  }
}
