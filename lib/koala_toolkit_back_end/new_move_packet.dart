class NewMovePacket {
  final String moveName;
  final int moveNum;
  final String moveElement;
  final String moveType;
  final int energyCost;

  NewMovePacket({
    required this.moveName,
    required this.moveNum,
    required this.moveElement,
    required this.moveType,
    required this.energyCost,
  });
}