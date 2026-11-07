import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/transaction_entry.dart';

class ReportService {
  static Future<void> printReport(List<TransactionEntry> entries,String title) async {
    final income=entries.where((e)=>e.income).fold(0.0,(s,e)=>s+e.amount);
    final expense=entries.where((e)=>!e.income).fold(0.0,(s,e)=>s+e.amount);
    final pdf=pw.Document();
    pdf.addPage(pw.MultiPage(build:(context)=>[
      pw.Header(level:0,child:pw.Text('سجلي - '+title)),
      pw.Text('إجمالي الدخل: '+income.toStringAsFixed(2)),
      pw.Text('إجمالي الخرج: '+expense.toStringAsFixed(2)),
      pw.Text('الرصيد: '+(income-expense).toStringAsFixed(2)),
      pw.SizedBox(height:16),
      pw.Table.fromTextArray(headers:['النوع','الاسم','المبلغ','التاريخ','البيان'],data:entries.map((e)=>[e.income?'دخل':'خرج',e.name,e.amount.toStringAsFixed(2),e.date,e.note]).toList()),
    ]));
    await Printing.layoutPdf(onLayout:(format)=>pdf.save());
  }
}