import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../shared/di/injection.dart';
import '../../../../shared/providers/theme_provider.dart';
import '../../../../shared/resources/colors_manager.dart';
import '../cubit/calendar_cubit.dart';
import '../cubit/calendar_state.dart';
import '../widgets/date_selector_widget.dart';
import '../widgets/timeline_widget.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) {
        final now = DateTime.now();
        final start = DateTime(now.year, now.month - 1, 1);
        final end = DateTime(now.year, now.month + 3, 0);
        return getIt<CalendarCubit>()..fetchEvents(startDate: start, endDate: end);
      },
      child: Scaffold(
        backgroundColor:
            isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        appBar: AppBar(
          backgroundColor: isLight ? ColorsManager.white : ColorsManager.darkSurface,
          elevation: 0,
          centerTitle: true,
          title: Text(
            localizations.calendar,
            style: isLight
                ? AppLightTextStyles.headlineSmall
                : AppDarkTextStyles.headlineSmall,
          ),
          actions: [
            BlocBuilder<CalendarCubit, CalendarState>(
              builder: (context, state) => IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
                ),
                onPressed: () {
                  final now = DateTime.now();
                  context.read<CalendarCubit>().fetchEvents(
                    startDate: DateTime(now.year, now.month - 1, 1),
                    endDate: DateTime(now.year, now.month + 3, 0),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // ── Date Selector ────────────────────────────────────────────────
            DateSelectorWidget(
              focusedMonth: _selectedDay,
              selectedDay: _selectedDay,
              onDaySelected: (day) => setState(() => _selectedDay = day),
            ),
            SizedBox(height: 16),

            // ── Legend Row ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _LegendDot(color: ColorsManager.blue, label: 'Assignment'),
                  SizedBox(width: 16),
                  _LegendDot(color: ColorsManager.yellow, label: 'Quiz'),
                ],
              ),
            ),
            SizedBox(height: 12),

            // ── Timeline ──────────────────────────────────────────────────────
            Expanded(
              child: BlocBuilder<CalendarCubit, CalendarState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (allEvents) {
                      final dayEvents = context
                          .read<CalendarCubit>()
                          .eventsForDay(allEvents, _selectedDay);
                      return TimelineWidget(events: dayEvents);
                    },
                    error: (message) => Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_off_outlined,
                                size: 48, color: ColorsManager.red),
                            SizedBox(height: 12),
                            Text(
                              message,
                              style: (isLight
                                      ? AppLightTextStyles.bodyMedium
                                      : AppDarkTextStyles.bodyMedium)
                                  .copyWith(color: ColorsManager.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isLight ? ColorsManager.grayDark : ColorsManager.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
