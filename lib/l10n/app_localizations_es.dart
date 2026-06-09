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
  String get navHome => 'Inicio';

  @override
  String get navHabits => 'Hábitos';

  @override
  String get navStats => 'Estadísticas';

  @override
  String get navProfile => 'Perfil';

  @override
  String get loginTitle => 'Inicia sesión para continuar';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Contraseña';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get loginWithGoogle => 'Continuar con Google';

  @override
  String get loginNoAccount => '¿No tienes cuenta?';

  @override
  String get loginRegister => 'Regístrate';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerName => 'Nombre';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get validationRequired => 'Este campo es obligatorio';

  @override
  String get validationEmail => 'Email no válido';

  @override
  String get validationPasswordLength => 'Mínimo 6 caracteres';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get save => 'Guardar';

  @override
  String get saveChanges => 'Guardar cambios';

  @override
  String greeting(Object name) {
    return 'Hola, $name 👋';
  }

  @override
  String get todaySummary => 'Resumen de hoy';

  @override
  String get habits => 'Hábitos';

  @override
  String get addHabit => 'Añadir hábito';

  @override
  String get noHabits => 'No hay hábitos aún';

  @override
  String get habitName => 'Nombre del hábito';

  @override
  String get habitDescription => 'Descripción';

  @override
  String get habitFrequency => 'Frecuencia';

  @override
  String get habitDeleted => 'Hábito eliminado';

  @override
  String get habitCreated => 'Hábito creado correctamente';

  @override
  String get habitCompleted => 'Hábito completado';

  @override
  String get habitUpdated => 'Hábito actualizado correctamente';

  @override
  String get streak => 'Racha';

  @override
  String streakDays(Object days) {
    return '$days días';
  }

  @override
  String get completedToday => 'Completados hoy';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get daily => 'Diario';

  @override
  String get weekly => 'Semanal';

  @override
  String get stats => 'Estadísticas';

  @override
  String get completionRate => 'Tasa de completado';

  @override
  String get bestStreak => 'Mejor racha';

  @override
  String get totalCompleted => 'Total completados';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get changePhoto => 'Cambiar foto';

  @override
  String get profileUpdated => 'Perfil actualizado correctamente';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get language => 'Idioma';

  @override
  String get help => 'Ayuda';

  @override
  String get contact => 'Contacto';

  @override
  String get version => 'Versión';

  @override
  String get faq => 'Preguntas frecuentes';

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
  String get days => 'días';

  @override
  String get habitCompletedSuccess => '¡Hábito completado!';

  @override
  String get habitCreatedSuccess => 'Hábito creado correctamente';

  @override
  String get habitDeletedSuccess => 'Hábito eliminado';

  @override
  String get selectColor => 'Color';

  @override
  String get selectIcon => 'Icono';
}
