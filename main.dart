import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(ExpenseTrackerApp());
}

class Expense {
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Expense Tracker',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  String _searchQuery = '';

  void _addExpense() {
    final title = _titleController.text;
    final amount = double.tryParse(_amountController.text);

    if (title.isEmpty || amount == null) return;

    setState(() {
      _expenses.add(Expense(
        title: title,
        amount: amount,
        category: _selectedCategory,
        date: DateTime.now(),
      ));
      _titleController.clear();
      _amountController.clear();
    });
  }

  List<Expense> get _filteredExpenses {
    return _expenses.where((exp) {
      return exp.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: ['Food', 'Travel', 'Shopping', 'Bills']
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCategory = val!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addExpense,
                    child: Text('Add Expense'),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: _filteredExpenses.isEmpty
                ? Center(child: Text('No expenses found'))
                : ListView.builder(
                    itemCount: _filteredExpenses.length,
                    itemBuilder: (ctx, i) {
                      final e = _filteredExpenses[i];
                      return ListTile(
                        title: Text(e.title),
                        subtitle: Text('${e.category} • ${e.date.toLocal().toString().split(' ')[0]}'),
                        trailing: Text('\$${e.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
