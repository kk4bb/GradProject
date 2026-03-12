using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class QuizAttempt
    {
        public int Id { get; set; }

        public int QuizId { get; set; }

        public string StudentId { get; set; }

        public double Score { get; set; }
    }
}
