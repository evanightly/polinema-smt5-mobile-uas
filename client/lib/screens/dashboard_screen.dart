import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          height: 140,
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/images/dashboard_drawer.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 6, bottom: 6),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              color: Colors.black54,
            ),
            child: Text(
              'New Arrival',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
