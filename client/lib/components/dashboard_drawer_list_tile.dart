import 'package:flutter/material.dart';

class DashboardDrawerListTile extends StatelessWidget {
  const DashboardDrawerListTile(
      {required this.icon,
      required this.title,
      this.isSelected = false,
      this.onTap,
      super.key});

  final bool isSelected;
  final IconData icon;
  final String title;
  final void Function()? onTap;
  // final Widget? navigateTo; // Use id/widget?

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        dense: true,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadiusDirectional.horizontal(
            start: Radius.circular(2),
            end: Radius.circular(2),
          ),
        ),
        tileColor: isSelected
            ? Theme.of(context).colorScheme.primary.withOpacity(.2)
            : null,
        iconColor: isSelected ? Theme.of(context).colorScheme.primary : null,
        leading: Icon(icon),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : null,
                color:
                    isSelected ? Theme.of(context).colorScheme.primary : null,
              ),
        ),
        onTap: onTap,
      ),
    );
  }
}
