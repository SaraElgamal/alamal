import 'package:charity_app/features/admin/presentation/cubit/admin_cases_cubit.dart';
import 'package:charity_app/features/user/presentation/pages/case_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/admin_cases_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    //context.read<AdminCasesCubit>().loadCases();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminCasesCubit(addCase: null, getCases: null, exportCases: null),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة التحكم'),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {
                context.read<AdminCasesCubit>().exportToExcel();
              },
              tooltip: 'تصدير إلى Excel',
            ),
          ],
        ),
        body: BlocConsumer<AdminCasesCubit, AdminCasesState>(
          listener: (context, state) {
            if (state.successMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.successMessage!)));
            }
            if (state.status == AdminCasesStatus.error &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
          },
          builder: (context, state) {
            if (state.status == AdminCasesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.status == AdminCasesStatus.success) {
              if (state.cases.isEmpty) {
                return const Center(child: Text('لا توجد حالات مسجلة'));
              }
              return ListView.builder(
                itemCount: state.cases.length,
                itemBuilder: (context, index) {
                  final caseItem = state.cases[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(caseItem.applicant.name),
                      subtitle: Text(caseItem.caseDescription),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CaseDetailsScreen(caseEntity: caseItem),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
