import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:testemu/core/utils/log/app_log.dart';
import 'package:testemu/core/utils/log/error_log.dart';

class SocketService {
  SocketService._privateConstructor();
  static final SocketService _instance = SocketService._privateConstructor();
  static SocketService get instance => _instance;

  IO.Socket? _socket;

  /// 🔹 Callback when socket connects
  Function? _onConnectedCallback;

  /// 🔹 Check connection status
  bool get isConnected => _socket?.connected ?? false;

  /// 🔹 Initialize socket (NO url, NO token)
  void initSocket({Function? onConnected}) {
    if (_socket != null) {
      appLog('🔄 Disposing existing socket');
      _socket?.dispose();
      _socket = null;
    }

    _onConnectedCallback = onConnected;
    appLog('🔧 Socket initialized (URL will be provided on connect)');
  }

  /// 🔹 Connect socket with URL
  void connect(String url) {
    if (_socket != null && isConnected) {
      appLog('⚠️ Socket already connected');
      return;
    }

    appLog('🌐 Connecting socket with URL');

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _registerDefaultListeners();
    _socket!.connect();
  }

  /// 🔹 Default listeners
  void _registerDefaultListeners() {
    _socket?.onConnect((_) {
      appLog('🟢 Socket CONNECTED');

      if (_onConnectedCallback != null) {
        appLog('📞 Executing onConnected callback');
        _onConnectedCallback!();
      }
    });

    _socket?.onDisconnect((_) {
      appLog('🔴 Socket DISCONNECTED');
    });

    _socket?.onConnectError((error) {
      errorLog('🔥 Socket CONNECT ERROR $error');
    });

    _socket?.onError((error) {
      errorLog('⚠️ Socket ERROR $error');
    });
  }

  /// 🔹 Listen socket event
  void onEvent(String eventName, Function(dynamic data) callback) {
    _socket?.on(eventName, (data) {
      appLog('Socket Event → $eventName $data');
      callback(data);
    });
  }

  /// 🔹 Emit event
  void emit(String eventName, dynamic data) {
    if (!isConnected) {
      errorLog('Socket not connected');
      return;
    }

    appLog('Emit Event → $eventName $data');
    _socket?.emit(eventName, data);
  }

  /// 🔹 Disconnect socket
  void disconnect() {
    if (_socket == null) return;

    appLog('Disconnecting socket...');
    _socket?.disconnect();
  }

  /// 🔹 Dispose socket
  void dispose() {
    appLog('Disposing socket');
    _socket?.dispose();
    _socket = null;
    _onConnectedCallback = null;
  }
}
