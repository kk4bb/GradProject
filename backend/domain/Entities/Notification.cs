using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Notification
    {
        public int Id { get; set; }

        public string Title { get; set; }

        public string Message { get; set; }

        public string? UserId { get; set; }

        public bool IsRead { get; set; } = false;

        public bool IsAnnouncement { get; set; } = false;

        public DateTime CreatedAt { get; set; }
    }
}
