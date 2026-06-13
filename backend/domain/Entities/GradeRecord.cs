using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CampusConnect.Domain.Entities
{
    public class GradeRecord
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string StudentId { get; set; }

        [Required]
        public int CourseId { get; set; }

        public Course Course { get; set; }

        // Term Work (Managed by TAs/Instructors) - Max 30 marks total
        public double QuizzesTotal { get; set; }
        public double AssignmentsTotal { get; set; }
        public double AttendanceTotal { get; set; }
        public double ProjectGrade { get; set; }

        // Exams (Managed by Instructors) - Max 70 marks total
        public double Midterm1 { get; set; }
        public double Midterm2 { get; set; }
        public double FinalExam { get; set; }

        // Lock flag
        public bool IsTermWorkPublished { get; set; }

        // Total
        public double TotalGrade => QuizzesTotal + AssignmentsTotal + AttendanceTotal + ProjectGrade + Midterm1 + Midterm2 + FinalExam;
    }
}
