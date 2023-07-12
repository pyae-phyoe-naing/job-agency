import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_agency/bloc/worker/worker_cubit.dart';
import 'package:job_agency/global.dart';
import 'package:job_agency/model/worker_model.dart';
import 'package:job_agency/route/route.dart';
import 'package:job_agency/utils/theme.dart';
import 'package:job_agency/widget/box/box.dart';
import 'package:job_agency/widget/worker_components/worker_card.dart';
import 'package:starlight_search_bar/starlight_search_bar.dart';
import 'package:starlight_utils/starlight_utils.dart';

class WorkerSearchButton extends StatelessWidget {
  const WorkerSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WorkerModel> workers =
        context.read<WorkerCubit>().state.workerList;
    return IconButton(
      onPressed: () {
        StarlightSearchBar.searchBar(
          context: context,
          data: workers,
          onSearch: (List<WorkerModel> workers, String search) => workers
              .where((worker) =>
                  (worker.displayName ?? worker.email!.split('@')[0])
                      .toLowerCase()
                      .contains(search.toLowerCase()) ||
                      (worker.city ?? '')
                      .toLowerCase()
                      .contains(search.toLowerCase())
                      )
              .toList(),
          // Show Ui Click Search Button
          buildResult: (WorkerModel worker) => BlocProvider(
            create: (_) => watchProExpCubit,
            child: WorkerCard(workerModel: worker),
          ),
          // Show Suggestion of All Data List
          buildSuggestion: (WorkerModel worker) => ListTile(
            onTap: () => Navigator.pushNamed(
                      context, RouteName.workerDetail,
                      arguments: worker),dense: true,
            title: Text(worker.displayName ?? 'Not Set'),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Box(title: worker.city ?? 'Not Set'),
                Text("${worker.price.currencyFormat}MMK")
              ],
            ),
          ),
        );
      },
      splashRadius: 20,
      icon: const Icon(
        Icons.search,
        color: ThemeUtils.buttonColor,
      ),
    );
  }
}
