
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utils/NetworkHelper.dart';
import 'network_event.dart';
import 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc._() : super(NetworkInitial()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }

  static final NetworkBloc _instance = NetworkBloc._();

  factory NetworkBloc() => _instance;

  void _observe(event, emit) {
    NetworkHelper.observeNetwork();
  }

  void _notifyStatus(NetworkNotify event, emit) {
    print('eventCheck ${event.isConnected}');
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailure());
  }
}