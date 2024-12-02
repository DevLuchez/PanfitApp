import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FinancesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              child: TabBar(
                tabs: [
                  Tab(text: 'Diário'),
                  Tab(text: 'Mensal'),
                  Tab(text: 'Anual'),
                ],
                labelColor: Color(0xFF996536),
                unselectedLabelColor: Colors.grey,
                indicatorColor: Color(0xFF996536),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  DiarioTab(),
                  MensalTab(),
                  AnualTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiarioTab extends FinancesTab {
  @override
  bool filterData(DateTime saleDate, DateTime referenceDate) {
    return saleDate.year == referenceDate.year &&
        saleDate.month == referenceDate.month &&
        saleDate.day == referenceDate.day;
  }
}

class MensalTab extends FinancesTab {
  @override
  bool filterData(DateTime saleDate, DateTime referenceDate) {
    return saleDate.year == referenceDate.year &&
        saleDate.month == referenceDate.month;
  }
}

class AnualTab extends FinancesTab {
  @override
  bool filterData(DateTime saleDate, DateTime referenceDate) {
    return saleDate.year == referenceDate.year;
  }
}

abstract class FinancesTab extends StatefulWidget {
  @override
  _FinancesTabState createState() => _FinancesTabState();

  bool filterData(DateTime saleDate, DateTime referenceDate);
}

class _FinancesTabState extends State<FinancesTab> {
  double totalSaleValueToday = 0;
  double totalSaleValueYesterday = 0;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8083/sale'));
      if (response.statusCode == 201) {
        final data = json.decode(response.body)['data'] as List;

        // Faturamento do período atual
        final todaySales = data.where((sale) {
          final date = DateTime.parse(sale['date']);
          return widget.filterData(date, today);
        });
        totalSaleValueToday = todaySales.fold(
          0,
              (sum, sale) => sum + sale['amount'],
        );

        // Faturamento do período anterior
        final yesterday = getPreviousPeriod(today);
        final yesterdaySales = data.where((sale) {
          final date = DateTime.parse(sale['date']);
          return widget.filterData(date, yesterday);
        });
        totalSaleValueYesterday = yesterdaySales.fold(
          0,
              (sum, sale) => sum + sale['amount'],
        );

        setState(() {});
      } else {
        throw Exception('Failed to load sales data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  DateTime getPreviousPeriod(DateTime date) {
    if (widget is DiarioTab) {
      return date.subtract(Duration(days: 1));
    } else if (widget is MensalTab) {
      return DateTime(date.year, date.month - 1, date.day);
    } else if (widget is AnualTab) {
      return DateTime(date.year - 1, date.month, date.day);
    } else {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double lucroTaxa = 0.50; // 50%
    final double lucroHoje = totalSaleValueToday * lucroTaxa;
    final double lucroOntem = totalSaleValueYesterday * lucroTaxa;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    'Faturamos',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'R\$${totalSaleValueToday.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF528533),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 100),
              Column(
                children: [
                  Text(
                    'Lucramos',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'R\$${lucroHoje.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF528533),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: (totalSaleValueToday > totalSaleValueYesterday
                    ? totalSaleValueToday
                    : totalSaleValueYesterday) *
                    1.2, // Adiciona uma margem de 20% no topo
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: double.parse(totalSaleValueYesterday.toStringAsFixed(2)),
                        color: Color(0xFFD3B300),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: double.parse(totalSaleValueToday.toStringAsFixed(2)),
                        color: Color(0xFF528533),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text('Atual', style: TextStyle(fontSize: 12));
                          case 1:
                            return Text('Anterior', style: TextStyle(fontSize: 12));
                          default:
                            return Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                backgroundColor: Colors.transparent,
                gridData: FlGridData(show: false),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
