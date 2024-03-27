enum SyncRequestType { update, add }
enum SyncRequestStatus { success, error }
enum RecentActionsType { expense, payment }
enum RecentActionsValueType { tip, percentFromSale, prepayment }

class RecentAction {
  RecentActionsType type;
  double amount;
  DateTime creationDate;
  RecentActionsValueType valueType;

  RecentAction({
    required this.type, 
    required this.amount,
    required this.creationDate,
    required this.valueType
  });
}