import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../provider/data_repository.dart';
import '../../services/users_api.dart';
import '../connectivity/connectivity_bloc.dart';
import '../connectivity/connectivity_state.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ConnectivityBloc connectivityBloc;
  late StreamSubscription connectivitySubscription;

  late DataRepository dataRepository;
  late AuthApiService authApiService;

  ProfileBloc({required this.connectivityBloc})
      : super(const ProfileStateLoading()) {
    on<GetProfileEvent>(_getProfileEvent);
    on<GetCashedProfileEvent>(_getCachedProfileEvent);
    on<UpdateProfileEvent>(
      (event, emit) {
        _updateProfileEvent(event, emit, event.updateData);
      },
    );
    authApiService = AuthApiService();
    dataRepository = DataRepository();

    listenToConnectivityBloc();
  }

  void listenToConnectivityBloc() {
    connectivitySubscription = connectivityBloc.stream.listen(
      (state) {
        if (state is ConnectivitySuccess) {
          add(GetProfileEvent());
        } else if (state is ConnectivityFailure) {
          add(GetCashedProfileEvent());
        }
      },
    );
  }

  Future<void> _getCachedProfileEvent(
      ProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      Profile? profile = await dataRepository.getProfile();
      print('profile _getCacheProfileEvent >> $profile');
      if (profile != null) {
        emit(ProfileStateSuccess(profileData: profile));
      } else {
        emit(
          const ProfileStateFailure(
            profileFailureMessage: "No cached your data available",
          ),
        );
      }
    } catch (e) {
      emit(
        ProfileStateFailure(
          profileFailureMessage: "catch _getCachedProfileEvent >> $e",
        ),
      );
    }
  }

  Future<void> _getProfileEvent(
      ProfileEvent event, Emitter<ProfileState> emit) async {
    try {
      bool isAuthenticated = await dataRepository.getIsAuthenticated();
      if (isAuthenticated) {
        String? access = await dataRepository.getAccessToken();
        Profile? profile = await authApiService.fetchUserProfile(
          accessToken: access,
        );
        await dataRepository.setProfile(profile);
        print('isAuthenticated >>>> true, profile >> $profile');
        emit(ProfileStateSuccess(profileData: profile));
      } else {
        emit(
          const ProfileStateFailure(
            profileFailureMessage: "You are not authenticated!",
          ),
        );
      }
    } catch (e) {
      emit(
        ProfileStateFailure(
            profileFailureMessage: "catch _getProfileEvent catch $e"),
      );
    }
  }

  Future<void> _updateProfileEvent(
      ProfileEvent event, Emitter<ProfileState> emit, Profile? updateData) async {
    try {
      bool isAuthenticated = await dataRepository.getIsAuthenticated();
      if (isAuthenticated) {
        String? access = await dataRepository.getAccessToken();
        bool isUpdated = await authApiService.fetchUpdateUserProfile(
          accessToken: access,
          updateData: updateData,
        );
        print('_updateProfileEvent isUpdated >> $isUpdated');
        if (isUpdated) {
          Profile? profileData = await dataRepository.getProfile();
          emit(ProfileStateSuccess(profileData: profileData));
        } else {
          print('your data not updated >> _updateProfileEvent');
          emit(
            const ProfileStateFailure(
              profileFailureMessage: "Your data not updated",
            ),
          );
        }
      } else {
        emit(
          const ProfileStateFailure(
            profileFailureMessage:
                "You are not authenticated. Please, login or register",
          ),
        );
      }
    } catch (e) {
      emit(
        ProfileStateFailure(
          profileFailureMessage: "catch _updateProfileEvent >> $e",
        ),
      );
    }
  }
}
