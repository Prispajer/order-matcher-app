abstract class OrderEvent {}

class AnalyzeOrder extends OrderEvent {
  final String input;

  AnalyzeOrder(this.input);
}
