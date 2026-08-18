import 'package:flutter/material.dart';
import '../app_state.dart';
import '../models/call_record.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';

/// A log of past Safe Calls (persisted).
class CallHistoryScreen extends StatelessWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.callHistoryTitle)),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) {
          final history = appState.callHistory;
          if (history.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  context.l10n.callHistoryEmpty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _RecordTile(record: history[i]),
          );
        },
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final CallRecord record;
  const _RecordTile({required this.record});

  String _when() {
    if (record.startedAtMs == 0) return '';
    final d = DateTime.fromMillisecondsSinceEpoch(record.startedAtMs);
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final hh = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd · $hh:$min';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: record.policeAdded
                ? AppColors.danger.withValues(alpha: 0.12)
                : AppColors.lavenderCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            record.policeAdded ? Icons.local_police_outlined : Icons.shield,
            color: record.policeAdded ? AppColors.danger : AppColors.primaryDark,
          ),
        ),
        title: Text(record.typeLabel,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            '${record.guardianCount} guardians · ${record.durationLabel} · ${_when()}'),
        trailing: record.policeAdded
            ? Text(context.l10n.callHistoryPolice,
                style: const TextStyle(
                    color: AppColors.danger, fontWeight: FontWeight.w600))
            : null,
      ),
    );
  }
}
