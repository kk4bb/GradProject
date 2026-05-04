class ApiEndpoints {
  // Auth
  static const String login = "auth/login";
  static const String register = "auth/register";

  // Student
  static const String studentDashboard = "student/me";
  static const String studentProfile = "student/profile/me";
  static const String studentProfileById = "student/profile/"; // + {id}

  // Courses
  static const String enrolledCourses = "course/enrolled";
  static const String assignedCourses = "course/assigned";
  static const String courseDetails = "course/"; // + {id}
  static const String createModule = "course/"; // + {id}/module
  static const String addLesson = "course/module/"; // + {id}/lesson
  static const String addContent = "course/lesson/"; // + {id}/content

  // Assignments
  static const String courseAssignments = "assignment/course/"; // + {courseId}
  static const String assignmentDetails = "assignment/"; // + {id}
  static const String submitAssignment = "assignment/"; // + {id}/submit
  static const String createAssignment = "assignment/course/"; // + {courseId}/create
  static const String viewSubmissions = "assignment/"; // + {id}/submissions
  static const String gradeSubmission = "assignment/submission/"; // + {id}/grade

  // Quizzes
  static const String courseQuizzes = "quiz/course/"; // + {courseId}
  static const String takeQuiz = "quiz/"; // + {id}/take
  static const String submitQuiz = "quiz/"; // + {id}/submit

  static const String aiChat = "ai/chat";

  // Forums
  static const String courseDiscussions = "forum/course/"; // + {courseId}
  static const String discussionPosts = "forum/discussion/"; // + {id}
  static const String createPost = "forum/discussion/"; // + {id}/post
  static const String createComment = "forum/post/"; // + {id}/comment
  static const String createDiscussion = "forum/course/"; // + {courseId}/discussion

  // Attendance
  static const String createAttendanceSession = "attendance/session";
  static const String markAttendance = "attendance/mark";
  static const String courseAttendanceReport = "attendance/course/"; // + {courseId}
  static const String myAttendance = "attendance/my/"; // + {courseId}

  // Notifications
  static const String notifications = "notification";
  static const String markNotificationRead = "notification/"; // + {id}/read
  static const String markAllNotificationsRead = "notification/read-all";
}
