import 'package:signalr_netcore/signalr_client.dart';
import 'package:injectable/injectable.dart';

abstract class QuizSignalrDataSource {
  Future<void> connect(String url, String token);
  Future<void> disconnect();
  Future<void> joinCourseGroup(String courseId);
  Future<void> leaveCourseGroup(String courseId);
  void onNewQuizReceived(Function(dynamic) callback);
}

@LazySingleton(as: QuizSignalrDataSource)
class QuizSignalrDataSourceImpl implements QuizSignalrDataSource {
  HubConnection? _hubConnection;

  @override
  Future<void> connect(String url, String token) async {
    

    _hubConnection = HubConnectionBuilder()
        .withUrl(url, options: HttpConnectionOptions(accessTokenFactory: () async => token))
        .withAutomaticReconnect()
        .build();
    
    try {
      await _hubConnection?.start();
      
    } catch (e) {
      
    }
  }

  @override
  Future<void> disconnect() async {
    await _hubConnection?.stop();
  }

  @override
  Future<void> joinCourseGroup(String courseId) async {
    await _hubConnection?.invoke('JoinCourseGroup', args: [courseId]);
  }

  @override
  Future<void> leaveCourseGroup(String courseId) async {
    await _hubConnection?.invoke('LeaveCourseGroup', args: [courseId]);
  }

  @override
  void onNewQuizReceived(Function(dynamic) callback) {
    _hubConnection?.on('ReceiveNewQuiz', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        try {
          
          callback(arguments.first);
        } catch(e) { 
           
        }
      }
    });
  }
}
