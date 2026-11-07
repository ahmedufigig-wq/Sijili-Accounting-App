class TransactionEntry {
  final int? id;
  final bool income;
  final String name;
  final double amount;
  final String date;
  final String receivedBy;
  final String source;
  final String note;

  TransactionEntry({this.id, required this.income, required this.name, required this.amount, required this.date, this.receivedBy='', this.source='', this.note=''});

  Map<String, dynamic> toMap() => {'id':id,'income':income?1:0,'name':name,'amount':amount,'date':date,'received_by':receivedBy,'source':source,'note':note};
  factory TransactionEntry.fromMap(Map<String,dynamic> m) => TransactionEntry(id:m['id'] as int?, income:m['income']==1, name:m['name']??'', amount:(m['amount'] as num).toDouble(), date:m['date']??'', receivedBy:m['received_by']??'', source:m['source']??'', note:m['note']??'');
}