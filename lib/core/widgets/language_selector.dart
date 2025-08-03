import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final VoidCallback? onLocaleChanged;
  
  const LanguageSelector({super.key, this.onLocaleChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Locale>(
      icon: const Icon(
        Icons.language,
        color: Colors.white,
        size: 24,
      ),
            onSelected: (Locale locale) async {
        await context.setLocale(locale);
        onLocaleChanged?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              locale == const Locale('tr', 'TR') 
                  ? 'Dil Türkçe olarak değiştirildi'
                  : 'Language changed to English',
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<Locale>(
          value: const Locale('tr', 'TR'),
          child: Row(
            children: [
              const Text('🇹🇷'),
              const SizedBox(width: 8),
              Text(
                context.locale == const Locale('tr', 'TR') 
                    ? 'Türkçe (Seçili)' 
                    : 'Türkçe',
                style: TextStyle(
                  fontWeight: context.locale == const Locale('tr', 'TR') 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('en', 'US'),
          child: Row(
            children: [
              const Text('🇺🇸'),
              const SizedBox(width: 8),
              Text(
                context.locale == const Locale('en', 'US') 
                    ? 'English (Selected)' 
                    : 'English',
                style: TextStyle(
                  fontWeight: context.locale == const Locale('en', 'US') 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 