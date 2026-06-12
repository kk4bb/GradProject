using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CampusConnect.Domain.Entities
{
    public class Question
    {
        public int Id { get; set; }

        public int QuizId { get; set; }

        public Quiz Quiz { get; set; }

        public string Text { get; set; }

        public string? ImageUrl { get; set; }

        public bool IsEssay { get; set; } = false;

        public double Points { get; set; } = 1;

        public ICollection<QuestionOption> Options { get; set; }
    }
}
