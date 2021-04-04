class CashierItem {
  String title;
  int quantity;
  double price, total;

  CashierItem({
    this.title,
    this.quantity,
    this.price,
  }) {
    this.total = price * quantity;
  }
}
