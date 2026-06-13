using CampusConnect.Application.Dtos.Calendar;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CampusConnect.Application.Interfaces
{
    public interface ICalendarService
    {
        Task<List<CalendarEventDto>> GetCalendarEventsAsync(string userId, DateTime startDate, DateTime endDate);
    }
}
