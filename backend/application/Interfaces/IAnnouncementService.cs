using System.Collections.Generic;
using System.Threading.Tasks;
using CampusConnect.Application.Dtos.Announcement;

namespace CampusConnect.Application.Interfaces
{
    public interface IAnnouncementService
    {
        Task<AnnouncementDto> CreateAnnouncementAsync(string authorId, AnnouncementCreateDto dto);
        Task<IEnumerable<AnnouncementDto>> GetCourseAnnouncementsAsync(int courseId);
        Task<IEnumerable<AnnouncementDto>> GetManageCourseAnnouncementsAsync(int courseId, string authorId);
        Task<AnnouncementDto> UpdateAnnouncementAsync(int id, string authorId, AnnouncementUpdateDto dto);
        Task<bool> DeleteAnnouncementAsync(int id, string authorId);
    }
}
