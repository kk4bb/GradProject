using System;

namespace CampusConnect.Application.Dtos.Grades
{
    public class GradeRecordDto
    {
        public int Id { get; set; }
        public string StudentId { get; set; }
        public string StudentName { get; set; }
        public string? StudentAvatarUrl { get; set; }
        public int CourseId { get; set; }
        public double QuizzesTotal { get; set; }
        public double AssignmentsTotal { get; set; }
        public double AttendanceTotal { get; set; }
        public double ProjectGrade { get; set; }
        public double Midterm1 { get; set; }
        public double Midterm2 { get; set; }
        public double FinalExam { get; set; }
        public bool IsTermWorkPublished { get; set; }
        public double TotalGrade { get; set; }
    }
}
