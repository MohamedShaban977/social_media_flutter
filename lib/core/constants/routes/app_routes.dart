import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/widgets/common/screens/unknown_route_screen.dart';
import 'package:hauui_flutter/features/authentication/forget_password/presentation/screens/forget_password_screen.dart';
import 'package:hauui_flutter/features/authentication/forget_password/presentation/screens/set_new_password_screen.dart';
import 'package:hauui_flutter/features/authentication/register/presentation/screens/register_screen.dart';
import 'package:hauui_flutter/features/authentication/verification/data/models/verification_route_model.dart';
import 'package:hauui_flutter/features/authentication/verification/presentation/screens/verification_screen.dart';
import 'package:hauui_flutter/features/chat/presentation/screens/chat_screen.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/add_edit_event_screen.dart';
import 'package:hauui_flutter/features/event_creation/presentation/screens/edit_date_and_time_screen.dart';
import 'package:hauui_flutter/features/events/presentation/screens/change_city_screen.dart';
import 'package:hauui_flutter/features/events/presentation/screens/event_details_screen.dart';
import 'package:hauui_flutter/features/events/presentation/screens/events_screen.dart';
import 'package:hauui_flutter/features/events/presentation/screens/joiners_screen.dart';
import 'package:hauui_flutter/features/main_layout/presentation/screens/main_layout_screen.dart';
import 'package:hauui_flutter/features/map/presentation/screens/map_screen.dart';
import 'package:hauui_flutter/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/countries_and_cities_screen.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/follow_top_users_screen.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/hobbies_screen.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/levels_screen.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/suggest_hobbies_screen.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/display_media/preview_media_screen.dart';
import 'package:hauui_flutter/features/posts/presentation/screens/posts_list/posts_screen.dart';
import 'package:hauui_flutter/features/post_creation/presentation/screens/post_creation_screen.dart';
import 'package:hauui_flutter/features/profile/presentation/screens/profile_screen.dart';
import 'package:hauui_flutter/features/profile/presentation/screens/ranks_screen.dart';
import 'package:hauui_flutter/features/search/presentation/screens/search_screen.dart';
import 'package:hauui_flutter/features/splash/presentation/screens/splash_screen.dart';

class AppRoutes {
  Route? generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case RoutesNames.initialRoute:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case RoutesNames.mainLayoutRoute:
        return MaterialPageRoute(
          builder: (_) => const MainLayoutScreen(),
        );
      case RoutesNames.postsRoute:
        return MaterialPageRoute(
          builder: (_) => const PostsScreen(),
        );
      case RoutesNames.eventsRoute:
        return MaterialPageRoute(
          builder: (_) => const EventsScreen(),
        );
      case RoutesNames.chatRoute:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
        );
      case RoutesNames.mapRoute:
        return MaterialPageRoute(
          builder: (_) => const MapScreen(),
        );
      case RoutesNames.myProfileRoute:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen.me(),
        );
      case RoutesNames.userProfileRoute:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen.user(
            userId: args?['user_id'],
          ),
        );
      case RoutesNames.ranksRoute:
        return MaterialPageRoute(
          builder: (_) => RanksScreen(
            getRankImage: args?['get_rank_image'],
          ),
        );
      case RoutesNames.notificationsRoute:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
        );
      case RoutesNames.searchRoute:
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );
      case RoutesNames.forgetPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordScreen(),
        );
      case RoutesNames.verificationRoute:
        return MaterialPageRoute(
          builder: (_) => VerificationScreen(
            verificationRouteModel: VerificationRouteModel.fromJson(args![AppConstants.routeVerificationKey]),
          ),
        );
      case RoutesNames.setNewPasswordRoute:
        return MaterialPageRoute(
          builder: (_) => SetNewPasswordScreen(
            resetPasswordCode: args![AppConstants.routeSetNewPasswordKey],
          ),
        );
      case RoutesNames.registerRoute:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      case RoutesNames.levelsRoute:
        return MaterialPageRoute(
          builder: (_) => const LevelsScreen.add(),
        );
      case RoutesNames.onBoardingHobbiesRoute:
        return MaterialPageRoute(
          builder: (_) => HobbiesScreen.onBoarding(
            levelId: args?[AppConstants.routeSelectHobbiesKey],
          ),
        );
      case RoutesNames.postCreationHobbiesRoute:
        return MaterialPageRoute(
          builder: (_) => const HobbiesScreen.postCreation(),
        );
      case RoutesNames.suggestHobbiesRoute:
        return MaterialPageRoute(
          builder: (_) => const SuggestHobbiesScreen(),
        );
      case RoutesNames.countriesAndCitiesRoute:
        return MaterialPageRoute(
          builder: (_) => const CountriesAndCitiesScreen(),
        );
      case RoutesNames.followTopUsersRoute:
        return MaterialPageRoute(
          builder: (_) => const FollowTopUsersScreen(),
        );
      case RoutesNames.createPostRoute:
        return MaterialPageRoute(
          builder: (_) => const PostCreationScreen.create(),
        );
      case RoutesNames.editPostRoute:
        return MaterialPageRoute(
          builder: (_) => const PostCreationScreen.edit(),
        );
      case RoutesNames.changeCityRoute:
        return MaterialPageRoute(
          builder: (_) => const ChangeCityScreen.listEvent(),
        );

      case RoutesNames.eventDetailsRoute:
        return MaterialPageRoute(
          builder: (_) => EventDetailsScreen(
            eventId: args?[AppConstants.routeEventIdKey],
            eventType: args?[AppConstants.routeEventTypeKey],
            index: args?[AppConstants.routeEventIndexKey],
          ),
        );
      case RoutesNames.joinersRoute:
        return MaterialPageRoute(
          builder: (_) => JoinersScreen(
            eventId: args?[AppConstants.routeEventIdKey],
          ),
        );
      case RoutesNames.addEventRoute:
        return MaterialPageRoute(
          builder: (_) => const AddEditEventScreen.add(),
        );
      case RoutesNames.editEventRoute:
        return MaterialPageRoute(
          builder: (_) => AddEditEventScreen.edit(
            eventId: args?[AppConstants.routeEventIdKey],
          ),
        );
      case RoutesNames.editDateAndTimeRoute:
        return MaterialPageRoute(
          builder: (_) => const EditDateAndTimeScreen(),
        );

      case RoutesNames.addLocationRoute:
        return MaterialPageRoute(
          builder: (_) => const ChangeCityScreen.createEvent(),
        );
      case RoutesNames.previewMediaRoute:
        return MaterialPageRoute(
          builder: (_) => PreviewMediaScreen(
            post: args?['post'],
            onLike: args?['onLike'],
            onSave: args?['onSave'],
            resetList: args?['resetList'],
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const UnknownRouteScreen(),
        );
    }
  }
}
