import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../shared/providers/theme_provider.dart';
import '../../../../../shared/resources/colors_manager.dart';

class DateSelectorWidget extends StatefulWidget {
  final DateTime focusedMonth;
  final DateTime selectedDay;
  final void Function(DateTime day) onDaySelected;

  const DateSelectorWidget({
    super.key,
    required this.focusedMonth,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  State<DateSelectorWidget> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  late DateTime _displayedMonth;
  final ScrollController _scrollController = ScrollController();

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const List<String> _weekdays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
  ];

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(widget.focusedMonth.year, widget.focusedMonth.month, 1);
    
    // Scroll to the selected day after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDay(animate: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedDay({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    // Each item is 46 wide with a 6 separator = 52 total per item
    // We want to scroll so the selected day is roughly in the middle of the screen
    final double itemWidth = 52;
    final double scrollOffset = (widget.selectedDay.day - 1) * itemWidth;
    
    // Subtract some offset to center it (optional, but makes it look better)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double centeredOffset = scrollOffset - (screenWidth / 2) + (itemWidth / 2);
    
    // Clamp the offset
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double finalOffset = centeredOffset.clamp(0.0, maxScroll);

    if (animate) {
      _scrollController.animateTo(
        finalOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(finalOffset);
    }
  }

  @override
  void didUpdateWidget(DateSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the focused month changed externally, update the internal displayed month
    if (widget.focusedMonth.year != oldWidget.focusedMonth.year ||
        widget.focusedMonth.month != oldWidget.focusedMonth.month) {
      setState(() {
        _displayedMonth = DateTime(widget.focusedMonth.year, widget.focusedMonth.month, 1);
      });
      // Scroll to the new selected day after the month changes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedDay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Provider.of<ThemeProvider>(context).isLightTheme();
    final today = DateTime.now();
    
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 20, left: 20, right: 20),
      decoration: BoxDecoration(
        color: isLight ? ColorsManager.white : ColorsManager.darkSurface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Month Navigation Row ──────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
                  });
                },
              ),
              Text(
                '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.blue,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: isLight ? ColorsManager.black : ColorsManager.darkTextPrimary,
                ),
                onPressed: () {
                  setState(() {
                    _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          // ── Days List View ──────────────────────────────────────────────
          SizedBox(
            height: 68,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: daysInMonth,
              separatorBuilder: (_, __) => SizedBox(width: 6),
              itemBuilder: (context, index) {
                final day = DateTime(_displayedMonth.year, _displayedMonth.month, index + 1);
                
                // HIGHLIGHT LOGIC: Mark as selected if it matches the current selectedDay
                // On initial load, widget.selectedDay is DateTime.now() from CalendarScreen
                final isSelected = day.year == widget.selectedDay.year &&
                    day.month == widget.selectedDay.month &&
                    day.day == widget.selectedDay.day;
                
                final isToday = day.year == today.year &&
                    day.month == today.month &&
                    day.day == today.day;

                return GestureDetector(
                  onTap: () => widget.onDaySelected(day),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 46,
                    decoration: BoxDecoration(
                      color: isSelected ? ColorsManager.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isToday && !isSelected
                          ? Border.all(color: ColorsManager.blue, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekdays[day.weekday - 1],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : ColorsManager.grayMedium,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : (isLight
                                    ? ColorsManager.black
                                    : ColorsManager.darkTextPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
