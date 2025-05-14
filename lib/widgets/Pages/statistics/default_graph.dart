import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DefaultGraph extends StatefulWidget {
  final List<FlSpot> spots;
  final double? minY;
  final double? maxY;
  final double? minX;
  final double? maxX;
  final Color borderColor;
  final Color textColor;
  final Color tooltipBackground;
  final Color gradientColorStart;
  final Color gradientColorEnd;
  final String topTitle;
  final List<String>? bottomTitlesList;
  final String leftTitle;
  final String rightTitle;

  const DefaultGraph({
    super.key,
    required this.spots,
    this.minY,
    this.maxY,
    this.minX,
    this.maxX,
    this.borderColor = Colors.white,
    this.textColor = Colors.white,
    this.tooltipBackground = Colors.blueGrey,
    this.gradientColorStart = Colors.blueAccent,
    this.gradientColorEnd = Colors.cyan,
    this.topTitle = "Placeholder: top",
    this.bottomTitlesList = null,
    this.leftTitle = "Placeholder: left",
    this.rightTitle = "Placeholder: right",
  });

  @override
  State<DefaultGraph> createState() => _DefaultGraphState();
}

class _DefaultGraphState extends State<DefaultGraph> {
  final List<int> selected = [];

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [LineChartBarData(
      showingIndicators: selected,
        spots: widget.spots,
        isCurved: true,
        dotData: FlDotData(show: true),
        barWidth: 4,
        shadow: const Shadow(blurRadius: 8),
        gradient: LinearGradient(
          colors: [widget.gradientColorStart, widget.gradientColorEnd],
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              widget.gradientColorStart.withValues(alpha: 0.4),
              widget.gradientColorEnd.withValues(alpha: 0.4),
            ],
          ),
        ),
      ),
    ];

    final flTitlesData = FlTitlesData(
      leftTitles: AxisTitles(
        axisNameWidget: Text(widget.rightTitle, style: TextStyle(color: widget.textColor)),
        axisNameSize: 24,
        sideTitles: SideTitles(showTitles: false, reservedSize: 0),
      ),
      rightTitles: AxisTitles(
        axisNameWidget: Text(widget.leftTitle, style: TextStyle(color: widget.textColor)),
        axisNameSize: 24,
        sideTitles: SideTitles(showTitles: false, reservedSize: 0),
      ),
      topTitles: AxisTitles(
        axisNameWidget: Text(widget.topTitle, textAlign: TextAlign.left, style: TextStyle(color: widget.textColor)),
        sideTitles: SideTitles(showTitles: true, reservedSize: 4),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) => getTitle(value, meta),
          reservedSize: 30,
        ),
      ),
    );
    
    final lineTouchData = LineTouchData(
      enabled: true,
      handleBuiltInTouches: false,
      touchCallback: (event, response) {
        if(response == null || response.lineBarSpots == null) {
          return;
        }
        
        if(event is FlTapUpEvent) {
          final spotIndex = response.lineBarSpots!.first.spotIndex;
          setState(() {
            if(selected.contains(spotIndex)) {
              selected.remove(spotIndex);
            } else {
              selected.add(spotIndex);
            }
          });
        }
        
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (touchedSpot) => widget.tooltipBackground,
        tooltipBorderRadius: BorderRadius.circular(8),
        tooltipBorder: BorderSide(width: 2, color: widget.borderColor),
        getTooltipItems: (lineBarsSpot) {
          return lineBarsSpot.map((lineBarSpot) {
            return LineTooltipItem(
              lineBarSpot.y.toString(),
              TextStyle(color: widget.textColor, fontWeight: FontWeight.bold),
            );
          }).toList();
        },
      ),
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((e) {
          return TouchedSpotIndicatorData(
            FlLine(color: widget.borderColor),
            FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => 
              FlDotCirclePainter(
                radius: 8,
                strokeWidth: 2,
                color: Color.lerp(widget.gradientColorStart, widget.gradientColorEnd, percent / 100)!,
                strokeColor: widget.borderColor
              ),
            )
          );
        },).toList();
      },
    );

    return LineChart(
      LineChartData(
        showingTooltipIndicators: selected.map((e) {
              return ShowingTooltipIndicators([
                LineBarSpot(lineBarsData[0], 0, widget.spots[e]),
              ]);
        },).toList(),
        lineBarsData: lineBarsData,
        lineTouchData: lineTouchData,
        minY: widget.minY,
        maxY: widget.maxY,
        minX: widget.minX,
        maxX: widget.maxX,
        gridData: FlGridData(show: false),
        titlesData: flTitlesData,
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: widget.borderColor
          )
        )
      )
    );
  }

  Widget getTitle(double value, TitleMeta meta) {
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'Digital',
      color: widget.textColor,
    );
    
    final key = value.toInt();
    if ((widget.bottomTitlesList?.length ?? 0) > key) {
      return SideTitleWidget(
        meta: meta,
        child: Text(widget.bottomTitlesList![key], style: style,),
      );
    }
    return Container();
  }
}