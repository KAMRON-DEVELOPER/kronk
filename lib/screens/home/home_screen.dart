import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../../provider/profile_mode_provider.dart';
import '../../widgets/drawer_widget.dart';
import '../../widgets/home_widgets/profile_edit.dart';
import '../../widgets/home_widgets/profile_failure.dart';
import '../../widgets/home_widgets/profile_loading.dart';
import '../../widgets/home_widgets/profile_success.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = context.watch<ProfileModeProvider>().isEditMode;

    return buildDrawerWidget(
      context: context,
      appBarTitle: 'Home screen',
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileStateLoading) {
            print('LISTENER ProfileStateLoading');
            if (state.mustRebuild == true) {
              print("LISTENER MUST REBUILD");
              context.read<ProfileBloc>().add(GetProfileEvent());
            }
          } else if (state is ProfileStateSuccess) {
            print(
                'LISTENER ProfileStateSuccess ${state.profileData?.username}');
          } else if (state is ProfileStateFailure) {
            print(
              'LISTENER ProfileStateFailure ${state.profileFailureMessage}',
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileStateSuccess) {
            if (!isEditMode) {
              return buildProfileSuccess(state, context);
            } else {
              return buildProfileEdit(state, context);
            }
          }
          if (state is ProfileStateLoading) {
            return buildProfileLoading(state, context, _lottieController);
          }
          if (state is ProfileStateFailure) {
            return buildProfileError(state, context);
          }
          return const Text(
            'Unexpected state',
            style: TextStyle(
              color: Colors.purpleAccent,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }
}

/*

 Uint8List? _croppedImage;
  DateTime _selectedDate = DateTime.now();

  void _showImageSelector({
    required BuildContext context,
    required int resizeWidth,
    required int resizeHeight,
    required int screenWidth,
    required int screenHeight,
  }) {
    showImageSelector(
      context: context,
      resizeWidth: resizeWidth,
      resizeHeight: resizeHeight,
      screenHeight: screenWidth,
      screenWidth: screenWidth,
      onImageSelected: (croppedImage) {
        croppedImage = croppedImage;
        setState(() {
          _croppedImage = croppedImage;
        });
      },
    );
  }

  void _showDateSelector({required BuildContext context}) {
    showCustomDateSelector(
      context: context,
      onDateSelected: (selectedDate) {
        setState(() {
          _selectedDate = selectedDate!;
        });
      },
    );
  }







/*

   ElevatedButton(
        onPressed: () {
          _showImageSelector(
              context: context,
              screenWidth: screenWidth.floor(),
              screenHeight: screenHeight.floor(),
              resizeWidth: 140,
              resizeHeight: 140);
        },
        child: const Text("Show Photo Selector"),
      ), // Image Picker Button
      ElevatedButton(
        onPressed: () => _showDateSelector(context: context),
        child: const Text("Show Scroll Date Selector"),
      ),

*/



 */
