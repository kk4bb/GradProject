using System;

namespace CampusConnect.Application.Dtos.Grades
{
    public class UpdateGradeDto
    {
        public double? QuizzesTotal { get; set; }
        public double? AssignmentsTotal { get; set; }
        public double? AttendanceTotal { get; set; }
        public double? ProjectGrade { get; set; }
        public double? Midterm1 { get; set; }
        public double? Midterm2 { get; set; }
        public double? FinalExam { get; set; }
    }
}
