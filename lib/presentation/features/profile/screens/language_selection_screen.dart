import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/localization/language_constants.dart';
import '../../../../core/providers/language_provider.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    final currentLanguageCode = currentLocale.languageCode;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select Language',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Description
          Text(
            'Choose your preferred language for the app',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: kTextGrey,
            ),
          ),
          const SizedBox(height: 24),

          // Language List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPillGrey),
              boxShadow: [
                BoxShadow(
                  color: kDarkGreen.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'en',
                  isSelected: currentLanguageCode == 'en',
                ),
                _buildDivider(),
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'id',
                  isSelected: currentLanguageCode == 'id',
                ),
                _buildDivider(),
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'es',
                  isSelected: currentLanguageCode == 'es',
                ),
                _buildDivider(),
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'fr',
                  isSelected: currentLanguageCode == 'fr',
                ),
                _buildDivider(),
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'de',
                  isSelected: currentLanguageCode == 'de',
                ),
                _buildDivider(),
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'ja',
                  isSelected: currentLanguageCode == 'ja',
                ),
                _buildDivider(),
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'ko',
                  isSelected: currentLanguageCode == 'ko',
                ),
                _buildDivider(),
                _buildLanguageItem(
                  context: context,
                  ref: ref,
                  languageCode: 'zh',
                  isSelected: currentLanguageCode == 'zh',
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kDarkGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kDarkGreen.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: kDarkGreen, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'The app will restart to apply the new language',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: kDarkGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem({
    required BuildContext context,
    required WidgetRef ref,
    required String languageCode,
    required bool isSelected,
  }) {
    final languageName = LanguageConstants.getLanguageName(languageCode);
    final flag = LanguageConstants.getFlag(languageCode);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await ref.read(languageProvider.notifier).setLanguage(languageCode);
          
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Language changed to $languageName',
                  style: GoogleFonts.inter(),
                ),
                backgroundColor: kDarkGreen,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
            
            // Pop back to profile screen
            Navigator.of(context).pop();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Flag
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: kPillGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    flag,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Language Name
              Expanded(
                child: Text(
                  languageName,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? kDarkGreen : kDarkGreen.withOpacity(0.7),
                  ),
                ),
              ),
              
              // Selected Indicator
              if (isSelected)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: kDarkGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: kPillGrey,
      indent: 84,
      endIndent: 20,
    );
  }
}
