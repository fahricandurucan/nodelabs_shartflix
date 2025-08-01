import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nodelabs_shartflix/core/constants/app_colors.dart';

class LimitedOfferBottomSheet extends StatefulWidget {
  final String title;
  final String description;

  const LimitedOfferBottomSheet({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<LimitedOfferBottomSheet> createState() => _LimitedOfferBottomSheetState();
}

class _LimitedOfferBottomSheetState extends State<LimitedOfferBottomSheet> {
  int selectedPackageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BLUR & DARK OVERLAY
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // SHEET
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            // margin: const EdgeInsets.only(top: 80),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              gradient: LinearGradient(
                colors: [Color(0xFFB71C1C), Color.fromARGB(255, 10, 10, 10)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Bonuslar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Alacağınız Bonuslar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildBonusItem(Icons.diamond, 'Premium Hesap'),
                              _buildBonusItem(Icons.favorite, 'Daha Fazla Eşleşme'),
                              _buildBonusItem(Icons.trending_up, 'Öne Çıkarma'),
                              _buildBonusItem(Icons.thumb_up, 'Daha Fazla Beğeni'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Paketler
                    const Text(
                      'Kilidi açmak için bir jeton paketi seçin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTokenPackage(
                            index: 0,
                            originalTokens: '200',
                            newTokens: '330',
                            bonus: '+10%',
                            price: '₺99,99',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE50914), Color(0xFFB71C1C)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTokenPackage(
                            index: 1,
                            originalTokens: '2.000',
                            newTokens: '3.375',
                            bonus: '+70%',
                            price: '₺799,99',
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A5AF9), Color(0xFFB388FF)],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTokenPackage(
                            index: 2,
                            originalTokens: '1.000',
                            newTokens: '1.350',
                            bonus: '+35%',
                            price: '₺399,99',
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE50914), Color(0xFFB71C1C)],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Seçilen paket:  {selectedPackageIndex + 1}. Paket satın alınıyor...'),
                              backgroundColor: Color(0xFFE50914),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tüm Jetonları Gör',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBonusItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: Icon(
            icon,
            color: AppColors.red,
            size: 28,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTokenPackage({
    required int index,
    required String originalTokens,
    required String newTokens,
    required String bonus,
    required String price,
    required Gradient gradient,
  }) {
    final isSelected = selectedPackageIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPackageIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            // Bonus Tag
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  bonus,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Original Tokens
            Text(
              originalTokens,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 13,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            // New Tokens
            Text(
              newTokens,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Jeton',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            // Price
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Başına haftalık',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 