// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<void> {
  const AuthRoute({List<PageRouteInfo>? children})
    : super(AuthRoute.name, initialChildren: children);

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AuthScreen();
    },
  );
}

/// generated route for
/// [ChatListScreen]
class ChatListRoute extends PageRouteInfo<void> {
  const ChatListRoute({List<PageRouteInfo>? children})
    : super(ChatListRoute.name, initialChildren: children);

  static const String name = 'ChatListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatListScreen();
    },
  );
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({Key? key, required String chatId, List<PageRouteInfo>? children})
    : super(
        ChatRoute.name,
        args: ChatRouteArgs(key: key, chatId: chatId),
        initialChildren: children,
      );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return ChatScreen(key: args.key, chatId: args.chatId);
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({this.key, required this.chatId});

  final Key? key;

  final String chatId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, chatId: $chatId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ChatRouteArgs) return false;
    return key == other.key && chatId == other.chatId;
  }

  @override
  int get hashCode => key.hashCode ^ chatId.hashCode;
}

/// generated route for
/// [CreateHeroScreen]
class CreateHeroRoute extends PageRouteInfo<void> {
  const CreateHeroRoute({List<PageRouteInfo>? children})
    : super(CreateHeroRoute.name, initialChildren: children);

  static const String name = 'CreateHeroRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateHeroScreen();
    },
  );
}

/// generated route for
/// [CreateNoteScreen]
class CreateNoteRoute extends PageRouteInfo<void> {
  const CreateNoteRoute({List<PageRouteInfo>? children})
    : super(CreateNoteRoute.name, initialChildren: children);

  static const String name = 'CreateNoteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateNoteScreen();
    },
  );
}

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardScreen();
    },
  );
}

/// generated route for
/// [EditNoteScreen]
class EditNoteRoute extends PageRouteInfo<EditNoteRouteArgs> {
  EditNoteRoute({
    Key? key,
    required String noteId,
    List<PageRouteInfo>? children,
  }) : super(
         EditNoteRoute.name,
         args: EditNoteRouteArgs(key: key, noteId: noteId),
         initialChildren: children,
       );

  static const String name = 'EditNoteRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditNoteRouteArgs>();
      return EditNoteScreen(key: args.key, noteId: args.noteId);
    },
  );
}

class EditNoteRouteArgs {
  const EditNoteRouteArgs({this.key, required this.noteId});

  final Key? key;

  final String noteId;

  @override
  String toString() {
    return 'EditNoteRouteArgs{key: $key, noteId: $noteId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditNoteRouteArgs) return false;
    return key == other.key && noteId == other.noteId;
  }

  @override
  int get hashCode => key.hashCode ^ noteId.hashCode;
}

/// generated route for
/// [FeaturesStatusScreen]
class FeaturesStatusRoute extends PageRouteInfo<void> {
  const FeaturesStatusRoute({List<PageRouteInfo>? children})
    : super(FeaturesStatusRoute.name, initialChildren: children);

  static const String name = 'FeaturesStatusRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FeaturesStatusScreen();
    },
  );
}

/// generated route for
/// [GalarionMapScreen]
class GalarionMapRoute extends PageRouteInfo<void> {
  const GalarionMapRoute({List<PageRouteInfo>? children})
    : super(GalarionMapRoute.name, initialChildren: children);

  static const String name = 'GalarionMapRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GalarionMapScreen();
    },
  );
}

/// generated route for
/// [GlossaryScreen]
class GlossaryRoute extends PageRouteInfo<void> {
  const GlossaryRoute({List<PageRouteInfo>? children})
    : super(GlossaryRoute.name, initialChildren: children);

  static const String name = 'GlossaryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GlossaryScreen();
    },
  );
}

/// generated route for
/// [HeroDetailScreen]
class HeroDetailRoute extends PageRouteInfo<HeroDetailRouteArgs> {
  HeroDetailRoute({
    Key? key,
    required HeroModel hero,
    List<PageRouteInfo>? children,
  }) : super(
         HeroDetailRoute.name,
         args: HeroDetailRouteArgs(key: key, hero: hero),
         initialChildren: children,
       );

  static const String name = 'HeroDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HeroDetailRouteArgs>();
      return HeroDetailScreen(key: args.key, hero: args.hero);
    },
  );
}

class HeroDetailRouteArgs {
  const HeroDetailRouteArgs({this.key, required this.hero});

  final Key? key;

  final HeroModel hero;

  @override
  String toString() {
    return 'HeroDetailRouteArgs{key: $key, hero: $hero}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HeroDetailRouteArgs) return false;
    return key == other.key && hero == other.hero;
  }

  @override
  int get hashCode => key.hashCode ^ hero.hashCode;
}

/// generated route for
/// [HeroListScreen]
class HeroListRoute extends PageRouteInfo<void> {
  const HeroListRoute({List<PageRouteInfo>? children})
    : super(HeroListRoute.name, initialChildren: children);

  static const String name = 'HeroListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HeroListScreen();
    },
  );
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScreen();
    },
  );
}

/// generated route for
/// [NotesListScreen]
class NotesListRoute extends PageRouteInfo<void> {
  const NotesListRoute({List<PageRouteInfo>? children})
    : super(NotesListRoute.name, initialChildren: children);

  static const String name = 'NotesListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotesListScreen();
    },
  );
}

/// generated route for
/// [ProfileEditScreen]
class ProfileEditRoute extends PageRouteInfo<void> {
  const ProfileEditRoute({List<PageRouteInfo>? children})
    : super(ProfileEditRoute.name, initialChildren: children);

  static const String name = 'ProfileEditRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileEditScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [ResetPasswordScreen]
class ResetPasswordRoute extends PageRouteInfo<void> {
  const ResetPasswordRoute({List<PageRouteInfo>? children})
    : super(ResetPasswordRoute.name, initialChildren: children);

  static const String name = 'ResetPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [ShopScreen]
class ShopRoute extends PageRouteInfo<void> {
  const ShopRoute({List<PageRouteInfo>? children})
    : super(ShopRoute.name, initialChildren: children);

  static const String name = 'ShopRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShopScreen();
    },
  );
}

/// generated route for
/// [StartScreen]
class StartRoute extends PageRouteInfo<void> {
  const StartRoute({List<PageRouteInfo>? children})
    : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StartScreen();
    },
  );
}

/// generated route for
/// [WelcomeScreen]
class WelcomeRoute extends PageRouteInfo<void> {
  const WelcomeRoute({List<PageRouteInfo>? children})
    : super(WelcomeRoute.name, initialChildren: children);

  static const String name = 'WelcomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WelcomeScreen();
    },
  );
}
