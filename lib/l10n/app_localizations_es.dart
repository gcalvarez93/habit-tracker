// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Habit Tracker';

  @override
  String get navHome => 'Home';

  @override
  String get navHabits => 'Habits';

  @override
  String get navStats => 'Statistics';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginTitle => 'Sign in to continue';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginWithGoogle => 'Continue with Google';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get loginRegister => 'Register';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerName => 'Name';

  @override
  String get registerButton => 'Register';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Invalid email';

  @override
  String get validationPasswordLength => 'Minimum 6 characters';

  @override
  String get logout => 'Sign out';

  @override
  String get save => 'Save';

  @override
  String get saveChanges => 'Save changes';

  @override
  String greeting(Object name) {
    return 'Hello, $name 👋';
  }

  @override
  String get todaySummary => 'Today\'s summary';

  @override
  String get habits => 'Habits';

  @override
  String get addHabit => 'Add habit';

  @override
  String get noHabits => 'No habits yet';

  @override
  String get habitName => 'Habit name';

  @override
  String get habitDescription => 'Description';

  @override
  String get habitFrequency => 'Frequency';

  @override
  String get habitDeleted => 'Habit deleted';

  @override
  String get habitCreated => 'Habit created successfully';

  @override
  String get habitCompleted => 'Habit completed';

  @override
  String get habitUpdated => 'Habit updated successfully';

  @override
  String get streak => 'Streak';

  @override
  String streakDays(Object days) {
    return '$days days';
  }

  @override
  String get completedToday => 'Completed today';

  @override
  String get frequency => 'Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get stats => 'Statistics';

  @override
  String get completionRate => 'Completion rate';

  @override
  String get bestStreak => 'Best streak';

  @override
  String get totalCompleted => 'Total completed';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get notifications => 'Notifications';

  @override
  String get language => 'Language';

  @override
  String get help => 'Help';

  @override
  String get contact => 'Contact';

  @override
  String get version => 'Version';

  @override
  String get faq => 'Frequently asked questions';

  @override
  String get notificationsGeneral => 'Notificaciones generales';

  @override
  String get notificationsGeneralSubtitle => 'Recibe actualizaciones generales de la app';

  @override
  String get profileUpdatedSuccess => 'Perfil actualizado correctamente';

  @override
  String get faq1Question => '¿Cómo añado un hábito?';

  @override
  String get faq1Answer => 'Pulsa el botón + en la pantalla principal o en la pestaña de Hábitos.';

  @override
  String get faq2Question => '¿Cómo completo un hábito?';

  @override
  String get faq2Answer => 'Pulsa el círculo a la derecha del hábito para marcarlo como completado.';

  @override
  String get faq3Question => '¿Qué es la racha?';

  @override
  String get faq3Answer => 'La racha es el número de días consecutivos que has completado un hábito.';

  @override
  String get faq4Question => '¿Mis datos están seguros?';

  @override
  String get faq4Answer => 'Sí, todos los datos se almacenan de forma segura en Firebase.';

  @override
  String get days => 'days';

  @override
  String get habitCompletedSuccess => 'Habit completed!';

  @override
  String get habitCreatedSuccess => 'Habit created successfully';

  @override
  String get habitDeletedSuccess => 'Habit deleted';

  @override
  String get selectColor => 'Color';

  @override
  String get selectIcon => 'Icon';
}
