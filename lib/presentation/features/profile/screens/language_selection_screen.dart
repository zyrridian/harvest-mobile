import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../providers/profile_providers.dart';

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
    final currentLanguage = ref.watch(languageProvider);
    final availableLanguages = ref.watch(availableLanguagesProvider);

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Language',
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kDarkGreen.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kDarkGreen.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: kDarkGreen, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Select your preferred language. The app will restart to apply changes.',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: kDarkGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Language List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: availableLanguages.length,
              itemBuilder: (context, index) {
                final language = availableLanguages[index];
                final isSelected = currentLanguage == language['name'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? kDarkGreen : kPillGrey,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: kDarkGreen.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ref.read(languageProvider.notifier).state =
                            language['name']!;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Language changed to ${language['name']}',
                              style: GoogleFonts.dmSans(),
                            ),
                            backgroundColor: kDarkGreen,
                            duration: const Duration(seconds: 2),
                          ),
                        );

                        // Delay navigation to show snackbar
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // Flag Emoji
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: kPillGrey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                language['flag']!,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Language Name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    language['name']!,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: kDarkGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    language['code']!.toUpperCase(),
                                    style: GoogleFonts.dmSans(
                                      fontSize: 12,
                                      color: kTextGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Selected Indicator
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: kDarkGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            else
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: kPillGrey, width: 2),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Info
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'More languages coming soon!',
              style: GoogleFonts.dmSans(
                color: kTextGrey,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
