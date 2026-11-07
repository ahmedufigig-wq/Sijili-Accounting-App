import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(const SijiliApp());

class SijiliApp extends StatefulWidget {
  const SijiliApp({super.key});
  @override
  State<SijiliApp> createState() => _SijiliAppState();
}

class _SijiliAppState extends State<SijiliApp> {
  final List<Map<String, dynamic>> entries = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سجلي',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: HomePage(entries: entries, onChanged: () => setState(() {})),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.entries, required this.onChanged});
  final List<Map<String, dynamic>> entries;
  final VoidCallback onChanged;

  double get income => entries.where((e) => e['income'] == true).fold(0.0, (s, e) => s + e['amount']);
  double get expense => entries.where((e) => e['income'] == false).fold(0.0, (s, e) => s + e['amount']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجلي'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addEntry(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة عملية'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('سجّل دخلك ومصروفاتك بسهولة', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _summary(context, 'إجمالي الدخل', income, Icons.south_west)),
            const SizedBox(width: 8),
            Expanded(child: _summary(context, 'إجمالي الخرج', expense, Icons.north_east)),
          ]),
          Card(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('الرصيد الحالي'),
              Text((income - expense).toStringAsFixed(2), style: Theme.of(context).textTheme.headlineMedium),
            ]),
          )),
          const SizedBox(height: 16),
          const Text('آخر العمليات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ...entries.reversed.map((e) => Card(child: ListTile(
            leading: Icon(e['income'] ? Icons.add_circle : Icons.remove_circle),
            title: Text(e['name']),
            subtitle: Text(e['note'].isEmpty ? 'بدون بيان' : e['note']),
            trailing: Text(e['amount'].toStringAsFixed(2)),
          ))),
          if (entries.isEmpty)
            const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('لا توجد عمليات حتى الآن'))),
        ],
      ),
    );
  }

  Widget _summary(BuildContext context, String title, double value, IconData icon) {
    return Card(child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(children: [Icon(icon), Text(title), Text(value.toStringAsFixed(2))]),
    ));
  }

  void _addEntry(BuildContext context) {
    final name = TextEditingController();
    final amount = TextEditingController();
    final note = TextEditingController();
    bool isIncome = true;
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: const Text('إضافة عملية'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            SwitchListTile(
              title: Text(isIncome ? 'دخل' : 'خرج'),
              value: isIncome,
              onChanged: (v) => setLocalState(() => isIncome = v),
            ),
            TextField(controller: name, decoration: const InputDecoration(labelText: 'الاسم أو الجهة')),
            TextField(controller: amount, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'المبلغ')),
            TextField(controller: note, decoration: const InputDecoration(labelText: 'البيان أو المصدر')),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
            FilledButton(
              onPressed: () {
                final value = double.tryParse(amount.text) ?? 0;
                if (name.text.trim().isEmpty || value <= 0) return;
                entries.add({'income': isIncome, 'name': name.text.trim(), 'amount': value, 'note': note.text.trim()});
                onChanged();
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}
