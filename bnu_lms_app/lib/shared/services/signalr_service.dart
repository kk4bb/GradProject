import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import 'dart:async';
import 'dart:convert';

@singleton
class SignalRService {
  HubConnection? _assignmentHubConnection;
  HubConnection? _forumHubConnection;
  HubConnection? _quizHubConnection;
  HubConnection? _gradeHubConnection;
  HubConnection? _notificationHubConnection;

  // Assignments Streams
  final _assignmentController = StreamController<Map<String, dynamic>>.broadcast();
  final _submissionGradedController = StreamController<int>.broadcast();

  // Forums Streams
  final _newDiscussionController = StreamController<Map<String, dynamic>>.broadcast();
  final _newPostController = StreamController<Map<String, dynamic>>.broadcast();
  final _voteUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _correctAnswerController = StreamController<Map<String, dynamic>>.broadcast();

  // Quizzes Streams
  final _newQuizController = StreamController<Map<String, dynamic>>.broadcast();

  // Grades Streams
  final _gradeUpdateController = StreamController<Map<String, dynamic>>.broadcast();

  // Notifications Streams
  final _newNotificationController = StreamController<Map<String, dynamic>>.broadcast();
  final _announcementUpdatedController = StreamController<Map<String, dynamic>>.broadcast();
  final _announcementDeletedController = StreamController<int>.broadcast();

  Stream<Map<String, dynamic>> get assignmentStream => _assignmentController.stream;
  Stream<int> get submissionGradedStream => _submissionGradedController.stream;

  Stream<Map<String, dynamic>> get newDiscussionStream => _newDiscussionController.stream;
  Stream<Map<String, dynamic>> get newPostStream => _newPostController.stream;
  Stream<Map<String, dynamic>> get voteUpdateStream => _voteUpdateController.stream;
  Stream<Map<String, dynamic>> get correctAnswerStream => _correctAnswerController.stream;

  Stream<Map<String, dynamic>> get quizStream => _newQuizController.stream;
  Stream<Map<String, dynamic>> get gradeUpdateStream => _gradeUpdateController.stream;
  Stream<Map<String, dynamic>> get newNotificationStream => _newNotificationController.stream;
  Stream<Map<String, dynamic>> get announcementUpdatedStream => _announcementUpdatedController.stream;
  Stream<int> get announcementDeletedStream => _announcementDeletedController.stream;

  Future<void> init(String token) async {
    final options = HttpConnectionOptions(accessTokenFactory: () async => token);

    // Extract userId from JWT token claims (sub claim)
    String? userId;
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final decoded = utf8.decode(base64Url.decode(normalized));
        final Map<String, dynamic> claims = json.decode(decoded);
        userId = claims['sub'] as String? ??
                  claims['nameid'] as String? ??
                  claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] as String?;
        
      }
    } catch (e) {
      
    }

    // 1. Assignment Hub
    if (_assignmentHubConnection == null) {
      final assignmentUrl = ApiConstants.hubUrl('assignmentHub');
      
      _assignmentHubConnection = HubConnectionBuilder()
          .withUrl(assignmentUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _assignmentHubConnection!.on('NewAssignmentAdded', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          _assignmentController.add(arguments[0] as Map<String, dynamic>);
        }
      });

      _assignmentHubConnection!.on('SubmissionGraded', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          final data = arguments[0] as Map<String, dynamic>;
          if (data.containsKey('AssignmentId')) {
            _submissionGradedController.add(data['AssignmentId'] as int);
          } else if (data.containsKey('assignmentId')) {
            _submissionGradedController.add(data['assignmentId'] as int);
          }
        }
      });

      try {
        await _assignmentHubConnection!.start();
        
      } catch (e) {
        
      }
    }

    // 2. Forum Hub
    if (_forumHubConnection == null) {
      final forumUrl = ApiConstants.hubUrl('forumHub');
      

      _forumHubConnection = HubConnectionBuilder()
          .withUrl(forumUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _forumHubConnection!.on('ReceiveNewDiscussion', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _newDiscussionController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) {  }
        }
      });

      _forumHubConnection!.on('ReceiveNewPost', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _newPostController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) {  }
        }
      });

      _forumHubConnection!.on('ReceiveVoteUpdate', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _voteUpdateController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) {  }
        }
      });

      _forumHubConnection!.on('ReceiveCorrectAnswer', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _correctAnswerController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch(e) {  }
        }
      });

      try {
        await _forumHubConnection!.start();
        
      } catch (e) {
        
      }
    }

    // 3. Quiz Hub
    if (_quizHubConnection == null) {
      final quizUrl = ApiConstants.hubUrl('quizHub');
      

      _quizHubConnection = HubConnectionBuilder()
          .withUrl(quizUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _quizHubConnection!.on('ReceiveNewQuiz', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _newQuizController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            
          }
        }
      });

      try {
        await _quizHubConnection!.start();
        
      } catch (e) {
        
      }
    }

    // 4. Grade Hub
    if (_gradeHubConnection == null) {
      final gradeUrl = ApiConstants.hubUrl('gradeHub');
      
      
      _gradeHubConnection = HubConnectionBuilder()
          .withUrl(gradeUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _gradeHubConnection!.on('ReceiveGradeUpdate', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            _gradeUpdateController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            
          }
        }
      });

      _gradeHubConnection!.on('TermWorkPublished', (arguments) {
        _gradeUpdateController.add({"event": "TermWorkPublished"});
      });

      _gradeHubConnection!.on('TermWorkUnlocked', (arguments) {
        _gradeUpdateController.add({"event": "TermWorkUnlocked"});
      });

      try {
        await _gradeHubConnection!.start();
        
      } catch (e) {
        
      }
    }

    // 5. Notification Hub
    if (_notificationHubConnection == null) {
      final notificationUrl = ApiConstants.hubUrl('notificationHub');
      
      
      _notificationHubConnection = HubConnectionBuilder()
          .withUrl(notificationUrl, options: options)
          .withAutomaticReconnect()
          .build();

      _notificationHubConnection!.on('ReceiveNotification', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _newNotificationController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            
          }
        }
      });

      _notificationHubConnection!.on('AnnouncementUpdated', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _announcementUpdatedController.add(Map<String, dynamic>.from(arguments.first as Map));
          } catch (e) {
            
          }
        }
      });

      _notificationHubConnection!.on('AnnouncementDeleted', (arguments) {
        if (arguments != null && arguments.isNotEmpty) {
          try {
            
            _announcementDeletedController.add(arguments.first as int);
          } catch (e) {
            
          }
        }
      });

      try {
        await _notificationHubConnection!.start();
        
        // CRITICAL: Join the personal group so Clients.Group("User_{id}") reaches this client
        if (userId != null) {
          await _notificationHubConnection!.invoke('JoinPersonalGroup', args: [userId]);
          
        } else {
          
        }
      } catch (e) {
        
      }
    }
  }

  Future<void> joinCourse(int courseId) async {
    

    if (_assignmentHubConnection?.state == HubConnectionState.Connected) {
      await _assignmentHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
      
    } else {
      
    }

    if (_forumHubConnection?.state == HubConnectionState.Connected) {
      await _forumHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
      
    } else {
      
    }

    if (_quizHubConnection?.state == HubConnectionState.Connected) {
      await _quizHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
      
    } else {
      
    }

    if (_gradeHubConnection?.state == HubConnectionState.Connected) {
      await _gradeHubConnection!.invoke('JoinCourseGroup', args: [courseId.toString()]);
      
    } else {
      
    }
  }

  Future<void> leaveCourse(int courseId) async {
    if (_assignmentHubConnection?.state == HubConnectionState.Connected) {
      await _assignmentHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
    if (_forumHubConnection?.state == HubConnectionState.Connected) {
      await _forumHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
    if (_quizHubConnection?.state == HubConnectionState.Connected) {
      await _quizHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
    if (_gradeHubConnection?.state == HubConnectionState.Connected) {
      await _gradeHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
    if (_quizHubConnection?.state == HubConnectionState.Connected) {
      await _quizHubConnection!.invoke('LeaveCourseGroup', args: [courseId.toString()]);
    }
  }

  void dispose() {
    _assignmentHubConnection?.stop();
    _forumHubConnection?.stop();
    _assignmentController.close();
    _submissionGradedController.close();
    _newDiscussionController.close();
    _newPostController.close();
    _voteUpdateController.close();
    _correctAnswerController.close();
    _newQuizController.close();
    _gradeHubConnection?.stop();
    _gradeUpdateController.close();
    _notificationHubConnection?.stop();
    _newNotificationController.close();
    _announcementUpdatedController.close();
    _announcementDeletedController.close();
  }
}