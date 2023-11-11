import 'package:client/providers/admins.dart';
import 'package:client/providers/users.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminMainScreen extends ConsumerWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admins = ref.watch(adminsProvider);
    final users = ref.watch(usersProvider);
    return ListView(
      itemExtent: 200,
      shrinkWrap: true,
      children: [
        LineChart(
          curve: Curves.bounceIn,
          LineChartData(
            titlesData: const FlTitlesData(
              //// -----------------------------------------------
              bottomTitles: AxisTitles(
                axisNameWidget: Text('2023'),
              ),
              //// -----------------------------------------------
              topTitles: AxisTitles(
                axisNameWidget: Text('Marketing Analysis'),
              ),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            gridData: FlGridData(
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(.4),
                  strokeWidth: 1,
                );
              },
              show: true,
              drawVerticalLine: false,
            ),
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                gradient: LinearGradient(
                  transform: const GradientRotation(400),
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3),
                  FlSpot(11, 4),
                ],
                isCurved: false,
                shadow: Shadow(
                  blurRadius: 6,
                  color: Theme.of(context).colorScheme.primary.withOpacity(.3),
                  offset: const Offset(0, 3),
                ),
                color: Theme.of(context).colorScheme.primary,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(
                  show: false,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  spotsLine: BarAreaSpotsLine(
                    show: true,
                    flLineStyle: FlLine(
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 2,
                    ),
                  ),
                  color: const Color(0x00aa4cfc),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(.3),
                      Theme.of(context).colorScheme.secondary.withOpacity(.3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 140,
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.supervised_user_circle,
                            size: 35,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                             admins.asData?.value.length.toString() ?? '0',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Admins',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 140,
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.people,
                            size: 35,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            users.asData?.value.length.toString() ?? '0',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Users',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Container(
        //   height: 140,
        //   alignment: Alignment.bottomCenter,
        //   margin: const EdgeInsets.all(15),
        //   decoration: BoxDecoration(
        //     image: const DecorationImage(
        //       image: AssetImage('assets/images/dashboard_drawer.jpg'),
        //       fit: BoxFit.cover,
        //     ),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Container(
        //     width: double.infinity,
        //     padding: const EdgeInsets.only(top: 6, bottom: 6),
        //     decoration: const BoxDecoration(
        //       borderRadius: BorderRadius.only(
        //         bottomLeft: Radius.circular(12),
        //         bottomRight: Radius.circular(12),
        //       ),
        //       color: Colors.black54,
        //     ),
        //     child: Text(
        //       'New Arrival',
        //       textAlign: TextAlign.center,
        //       style: Theme.of(context)
        //           .textTheme
        //           .bodyMedium
        //           ?.copyWith(color: Colors.white),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
