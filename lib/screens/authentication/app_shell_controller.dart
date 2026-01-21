
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petnest/providers/user_provider.dart';
import 'package:petnest/screens/authentication/customer_shell.dart';
import 'package:petnest/screens/authentication/dashboard_screen.dart';
import 'package:petnest/widgets/professional_bottom_nav.dart';
import 'package:petnest/widgets/main_app_bar.dart';

class AppShellController extends StatelessWidget {
  const AppShellController({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.role == UserRole.customer) {
      return const CustomerShell();
    } else {

      return Scaffold(
        appBar: const MainAppBar(),
        body: const DashboardScreen(),
        bottomNavigationBar: const ProfessionalBottomNav(),
      );
    }
  }
}
