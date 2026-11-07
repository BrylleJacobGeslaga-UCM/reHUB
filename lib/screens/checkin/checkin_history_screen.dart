import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/checkin.dart';
import '../../services/checkin_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/screen_header.dart';

void openCheckInHistory(BuildContext context, User user) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (_) => CheckInHistoryScreen(user: user),
  ));
}

class CheckInHistoryScreen extends StatefulWidget {
  const CheckInHistoryScreen({super.key, required this.user});

  final User user;

  @override
  State<CheckInHistoryScreen> createState() => _CheckInHistoryScreenState();
}

class _CheckInHistoryScreenState extends State<CheckInHistoryScreen> {
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _month.year == now.year && _month.month == now.month;
  }

  void _shift(int by) =>
      setState(() => _month = DateTime(_month.year, _month.month + by));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<CheckIn>>(
        stream: CheckInService.instance.history(widget.user.uid),
        builder: (context, snap) {
          final all = snap.data ?? const <CheckIn>[];
          final byKey = {for (final c in all) c.key: c};
          final inMonth = all
              .where((c) =>
                  c.date.year == _month.year && c.date.month == _month.month)
              .toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ScreenHeader(
                  title: 'Check-in history',
                  subtitle: 'Only you can see this',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppCard(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Previous month',
                                  onPressed: () => _shift(-1),
                                  icon: const Icon(Icons.chevron_left_rounded),
                                ),
                                Expanded(
                                  child: Text(
                                    '${monthNames[_month.month - 1]} ${_month.year}',
                                    textAlign: TextAlign.center,
                                    style: AppText.title,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Next month',
                                  onPressed:
                                      _isCurrentMonth ? null : () => _shift(1),
                                  icon:
                                      const Icon(Icons.chevron_right_rounded),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            _MonthGrid(month: _month, byKey: byKey),
                            const SizedBox(height: 14),
                            const _Legend(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MonthSummary(entries: inMonth),
                      const SizedBox(height: 24),
                      Text('Entries', style: AppText.title),
                      const SizedBox(height: 10),
                      if (!snap.hasData)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.primary),
                          ),
                        )
                      else if (inMonth.isEmpty)
                        const EmptyState(
                          icon: Icons.event_note_outlined,
                          title: 'No check-ins this month',
                          message: 'Your daily check-ins will appear here.',
                        )
                      else
                        for (final c in inMonth)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _EntryRow(entry: c),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.month, required this.byKey});

  final DateTime month;
  final Map<String, CheckIn> byKey;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = DateTime(month.year, month.month, 1).weekday - 1;
    final todayKey = dateKey(DateTime.now());
    final cells = <Widget>[
      for (final d in const ['M', 'T', 'W', 'T', 'F', 'S', 'S'])
        Center(
          child: Text(d,
              style: AppText.label.copyWith(color: AppColors.textSubtle)),
        ),
      for (var i = 0; i < leading; i++) const SizedBox(),
      for (var day = 1; day <= daysInMonth; day++)
        _DayCell(
          day: day,
          entry: byKey[dateKey(DateTime(month.year, month.month, day))],
          isToday:
              dateKey(DateTime(month.year, month.month, day)) == todayKey,
        ),
    ];

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: cells,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.entry, required this.isToday});

  final int day;
  final CheckIn? entry;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final mood = entry?.mood;
    return Semantics(
      label: mood == null ? 'Day $day, no check-in' : 'Day $day, ${mood.label}',
      child: GestureDetector(
        onTap: entry == null ? null : () => _showEntry(context, entry!),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: mood?.color,
            border: isToday
                ? Border.all(color: AppColors.primaryStrong, width: 2)
                : null,
          ),
          child: Text(
            '$day',
            style: AppText.caption.copyWith(
              color: mood?.onColor ?? AppColors.textMuted,
              fontWeight: mood != null ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 6,
      children: [
        for (final m in Mood.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration:
                    BoxDecoration(color: m.color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(m.label,
                  style: AppText.caption.copyWith(color: AppColors.textMuted)),
            ],
          ),
      ],
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.entries});
  final List<CheckIn> entries;

  @override
  Widget build(BuildContext context) {
    int count(Mood m) => entries.where((e) => e.mood == m).length;
    return Row(
      children: [
        _Stat(value: '${entries.length}', label: 'Check-ins'),
        const SizedBox(width: 10),
        for (final m in Mood.values) ...[
          _Stat(value: '${count(m)}', label: m.label, dot: m.color),
          if (m != Mood.values.last) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, this.dot});
  final String value;
  final String label;
  final Color? dot;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Text(value, style: AppText.heading),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (dot != null) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                        BoxDecoration(color: dot, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.label
                          .copyWith(color: AppColors.textMuted)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry});
  final CheckIn entry;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => _showEntry(context, entry),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
                BoxDecoration(color: entry.mood.color, shape: BoxShape.circle),
            child: Icon(entry.mood.icon, color: entry.mood.onColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(longDate(entry.date), style: AppText.bodyStrong),
                Text(
                  entry.note.isEmpty ? entry.mood.label : entry.note,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.caption.copyWith(
                    color: AppColors.textMuted,
                    fontStyle:
                        entry.note.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showEntry(BuildContext context, CheckIn entry) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                      color: entry.mood.color, shape: BoxShape.circle),
                  child: Icon(entry.mood.icon,
                      color: entry.mood.onColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(longDate(entry.date), style: AppText.title),
                      Text('Feeling ${entry.mood.label.toLowerCase()}',
                          style: AppText.caption
                              .copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              entry.note.isEmpty ? 'No note for this day.' : entry.note,
              style: AppText.body.copyWith(
                color: entry.note.isEmpty
                    ? AppColors.textSubtle
                    : AppColors.text,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
