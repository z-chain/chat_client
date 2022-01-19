abstract class ConnectorEvent {}

class ConnectorChanged extends ConnectorEvent {
  final String? address;

  ConnectorChanged({required this.address});
}
