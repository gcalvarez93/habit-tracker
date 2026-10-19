// Path: lib/features/profile/presentation/pages/edit_profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      _nameController.text = authState.user.name ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final name = _nameController.text.trim();
    final profileState = ref.read(profileProvider);
    final p = profileState is ProfileLoaded ? profileState.profile : null;
    final profileNotifier = ref.read(profileProvider.notifier);

    Future<bool> saveProfileName(String value) => profileNotifier.updateProfile(
      name: value,
      language: p?.language ?? 'es',
      notifications: p?.notifications ?? true,
    );

    // Primero la API (fuente de verdad del perfil) y después Firebase. Si
    // Firebase falla, se restaura el nombre anterior en la API para que los
    // dos sistemas no queden con valores distintos.
    var updated = await saveProfileName(name);
    if (updated) {
      updated = await ref.read(authProvider.notifier).updateDisplayName(name);
      if (!updated && p != null) {
        final restored = await saveProfileName(p.name);
        if (!restored) {
          AppLogger.warning(
            'EditProfilePage._save: no se pudo restaurar el nombre anterior',
          );
        }
      }
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated ? l10n.profileUpdatedSuccess : l10n.profileUpdateError,
        ),
        backgroundColor:
        updated ? Theme.of(context).colorScheme.primary : Colors.red,
      ),
    );
    if (updated) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.editProfile),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: colorScheme.primary,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.camera_alt, color: colorScheme.primary),
                  label: Text(l10n.changePhoto,
                      style: TextStyle(color: colorScheme.primary)),
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _nameController,
                  label: l10n.registerName,
                  validator: (value) {
                    if (value == null || value.isEmpty) return l10n.validationRequired;
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.saveChanges,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}