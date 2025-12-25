import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../domain/entities/farmer.dart';

// Constants
const kDarkGreen = Color(0xFF1A2F25);
const kTextGrey = Color(0xFF6E7A75);
const kPillGrey = Color(0xFFF0F2F0);
const kAccentOrange = Color(0xFFE86A33);

class FarmerCard extends StatelessWidget {
  final Farmer farmer;
  final VoidCallback onTap;

  const FarmerCard({
    super.key,
    required this.farmer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24), // Highly rounded
          border: Border.all(color: kPillGrey),
          boxShadow: [
            BoxShadow(
              color: kDarkGreen.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGE HEADER with Overlapping Avatar
            SizedBox(
              height: 160,
              child: Stack(
                children: [
                  // Cover Image
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(24)),
                    child: CachedNetworkImage(
                      imageUrl: farmer.coverImage,
                      height:
                          140, // Leaves 20px space at bottom for avatar overlap
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: kPillGrey),
                    ),
                  ),
                  // Verified Badge Top Right
                  if (farmer.isVerified)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified,
                                size: 14, color: Color(0xFF22C55E)),
                            const SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: GoogleFonts.dmSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkGreen),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Avatar (Overlapping)
                  Positioned(
                    left: 20,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: kPillGrey,
                        backgroundImage:
                            CachedNetworkImageProvider(farmer.profileImage),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. INFO CONTENT
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          farmer.name,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9E6), // Creamy yellow
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 16, color: Color(0xFFD97706)),
                            const SizedBox(width: 4),
                            Text(
                              farmer.rating.toStringAsFixed(1),
                              style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: const Color(0xFF92400E)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Location & Distance
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: kTextGrey),
                      const SizedBox(width: 4),
                      Text(
                        '${farmer.city}, ${farmer.state} • ${farmer.distance.toStringAsFixed(1)} km away',
                        style:
                            GoogleFonts.dmSans(color: kTextGrey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Specialties (Scrollable)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: farmer.specialties.take(4).map((tag) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: kPillGrey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.dmSans(
                                color: kDarkGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
