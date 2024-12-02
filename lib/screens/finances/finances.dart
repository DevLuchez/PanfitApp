import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FinancesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            // Colocando a TabBar mais próxima do topo
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

class DiarioTab extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {"label": "Pães", "value": 50, "color": Color(0xFF644325)},
    {"label": "Bolos", "value": 30, "color": Color(0xFFAA7845)},
    {"label": "Tortas", "value": 20, "color": Color(0xFFC4A580)},
  ];

  final List<Map<String, dynamic>> payment_methods = [
    {"label": "Crédito", "value": 40, "color": Color(0xFF644325)},
    {"label": "Débito", "value": 18, "color": Color(0xFFC4A580)},
    {"label": "Dinheiro", "value": 7, "color": Color(0xFFDACBB5)},
    {"label": "Pix", "value": 35, "color": Color(0xFFAA7845)},
  ];

  @override
  Widget build(BuildContext context) {
    final double totalSaleValueToday = 3200.0;
    final double totalSaleValueYesterday = 1500.0;

    final double lucroTaxa = 0.30; // 30%
    final double lucroHoje = totalSaleValueToday * lucroTaxa;
    final double lucroOntem = totalSaleValueYesterday * lucroTaxa;

    final double lucroDiferenca = lucroHoje - lucroOntem; // Diferença de lucro

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Resumo Rápido

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Valor total de vendas
              Column(
                children: [
                  Text(
                    'Faturamos',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                    ),
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

              // Lucro
              Column(
                children: [
                  Text(
                    'Lucramos',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'R\$${lucroDiferenca.toStringAsFixed(2)}',
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

          // Título com o lucro
          Text(
            'Total de vendas entre 01/10/2024 e 02/10/2024',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
            ),
          ),
          SizedBox(height: 70),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: (totalSaleValueToday > totalSaleValueYesterday ? totalSaleValueToday : totalSaleValueYesterday),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: totalSaleValueYesterday,
                        color: Color(0xFFD3B300),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: totalSaleValueToday,
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
                            return Text('Ontem', style: TextStyle(fontSize: 12));
                          case 1:
                            return Text('Hoje', style: TextStyle(fontSize: 12));
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

class MensalTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Total de vendas: 1587,25',
        style: TextStyle(fontFamily: 'Poppins', fontSize: 24),
      ),
    );
  }
}

class AnualTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Total de vendas: 1587,25',
        style: TextStyle(fontFamily: 'Poppins', fontSize: 24),
      ),
    );
  }
}
