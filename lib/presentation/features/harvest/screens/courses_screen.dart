import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../shared_widgets/app_cached_image.dart';
// import '../../../../core/config/theme/app_colors.dart';

// --- DESIGN CONSTANTS ---
const kBgColor = Color(0xFFFAFAF8);
const kDarkGreen = Color(0xFF1A2F25);
const kAccentOrange = Color(0xFFE86A33);
const kPillGrey = Color(0xFFF0F2F0);
const kTextGrey = Color(0xFF6E7A75);

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Gardening',
    'Composting',
    'Pest Control',
    'Irrigation',
    'Harvesting',
  ];

  // Mock Data (Kept from your snippet)
  final List<Course> courses = [
    Course(
      title: 'Organic Farming Fundamentals',
      instructor: 'Dr. Sarah Green',
      instructorAvatar: 'https://i.pravatar.cc/150?img=1',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=400',
      price: 'Free',
      rating: 4.8,
      studentsCount: 2456,
      duration: '4 weeks',
      lessons: 24,
      level: 'Beginner',
      category: 'Gardening',
      description:
          'Learn the fundamentals of organic farming from soil preparation to harvest.',
      modules: [
        'Introduction',
        'Soil Health',
        'Seed Selection',
        'Pest Mgmt',
        'Harvest'
      ],
      enrolled: false,
      progress: 0,
      hasCertificate: true,
    ),
    Course(
      title: 'Composting Masterclass',
      instructor: 'Michael Chen',
      instructorAvatar: 'https://i.pravatar.cc/150?img=2',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1597308680537-3541ac6b7a8e?w=400',
      price: '\$29',
      rating: 4.9,
      studentsCount: 1823,
      duration: '2 weeks',
      lessons: 12,
      level: 'Beginner',
      category: 'Composting',
      description:
          'Master the art of composting and turn waste into black gold.',
      modules: ['Basics', 'Materials', 'Temperature', 'Troubleshooting'],
      enrolled: true,
      progress: 65,
      hasCertificate: true,
    ),
    // ... add more from your original list if needed
  ];

  List<Course> get filteredCourses {
    if (selectedCategory == 'All') return courses;
    return courses.where((c) => c.category == selectedCategory).toList();
  }

  List<Course> get enrolledCourses {
    return courses.where((c) => c.enrolled).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkGreen),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Courses',
          style: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kDarkGreen,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: kPillGrey,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: kDarkGreen,
                borderRadius: BorderRadius.circular(30),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: kTextGrey,
              dividerColor: Colors.transparent,
              labelStyle:
                  GoogleFonts.dmSans(fontWeight: FontWeight.bold, fontSize: 14),
              tabs: const [
                Tab(text: 'Discover'),
                Tab(text: 'My Learning'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllCoursesTab(),
          _buildMyLearningTab(),
        ],
      ),
    );
  }

  Widget _buildAllCoursesTab() {
    return Column(
      children: [
        // Category Filter
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              return _buildCategoryChip(
                label: category,
                isSelected: isSelected,
                onTap: () => setState(() => selectedCategory = category),
              );
            },
          ),
        ),

        // Courses List
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: filteredCourses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              return _buildCourseCard(filteredCourses[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyLearningTab() {
    if (enrolledCourses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                  color: Color(0xFFFFF9E6), shape: BoxShape.circle),
              child: const Icon(Icons.school_outlined,
                  size: 48, color: Color(0xFFD97706)),
            ),
            const SizedBox(height: 16),
            Text(
              'No courses yet',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 20, fontWeight: FontWeight.bold, color: kDarkGreen),
            ),
            const SizedBox(height: 8),
            Text(
              'Enroll in a course to start learning.',
              style: GoogleFonts.dmSans(color: kTextGrey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: enrolledCourses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return _buildEnrolledCourseCard(enrolledCourses[index]);
      },
    );
  }

  // --- WIDGETS ---

  Widget _buildCategoryChip(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kDarkGreen : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? kDarkGreen : kPillGrey),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            color: isSelected ? Colors.white : kTextGrey,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Course course) {
    return GestureDetector(
      onTap: () => _showCourseDetails(course),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
            // Thumbnail
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AppCachedImage(
                    imageUrl: course.thumbnailUrl,
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: course.price == 'Free'
                          ? const Color(0xFF22C55E)
                          : kDarkGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      course.price,
                      style: GoogleFonts.dmSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Level
                  Row(
                    children: [
                      Text(
                        course.category.toUpperCase(),
                        style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: kAccentOrange),
                      ),
                      const SizedBox(width: 8),
                      Container(
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                              color: kPillGrey, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        course.level,
                        style:
                            GoogleFonts.dmSans(fontSize: 11, color: kTextGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.title,
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Instructor & Rating
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(course.instructorAvatar),
                        radius: 10,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        course.instructor,
                        style:
                            GoogleFonts.dmSans(fontSize: 12, color: kTextGrey),
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnrolledCourseCard(Course course) {
    return GestureDetector(
      onTap: () => _showCourseDetails(course),
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AppCachedImage(
                imageUrl: course.thumbnailUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: kDarkGreen),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: course.progress / 100,
                      minHeight: 6,
                      backgroundColor: kPillGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF22C55E)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${course.progress}% Complete',
                        style: GoogleFonts.dmSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen),
                      ),
                      Text(
                        '${course.lessons} Lessons',
                        style:
                            GoogleFonts.dmSans(fontSize: 11, color: kTextGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCourseDetails(Course course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                  child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: kPillGrey,
                          borderRadius: BorderRadius.circular(2)))),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Detail Header
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AppCachedImage(
                        imageUrl: course.thumbnailUrl,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      course.title,
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: kDarkGreen),
                    ),
                    const SizedBox(height: 16),

                    // Instructor Row
                    Row(
                      children: [
                        CircleAvatar(
                            backgroundImage:
                                NetworkImage(course.instructorAvatar)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.instructor,
                                style: GoogleFonts.dmSans(
                                    fontWeight: FontWeight.bold,
                                    color: kDarkGreen)),
                            Text('Instructor',
                                style: GoogleFonts.dmSans(
                                    fontSize: 12, color: kTextGrey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Info Grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDetailInfo(Icons.play_circle_outline,
                            '${course.lessons} Lessons'),
                        _buildDetailInfo(Icons.access_time, course.duration),
                        _buildDetailInfo(
                            Icons.star_rounded, '${course.rating} Rating'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: kPillGrey),
                    const SizedBox(height: 16),

                    // Description
                    Text('About Course',
                        style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen)),
                    const SizedBox(height: 8),
                    Text(
                      course.description,
                      style: GoogleFonts.dmSans(
                          fontSize: 15, color: kTextGrey, height: 1.6),
                    ),
                    const SizedBox(height: 24),

                    // Syllabus
                    Text('Syllabus',
                        style: GoogleFonts.dmSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkGreen)),
                    const SizedBox(height: 12),
                    ...course.modules.asMap().entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                    color: kPillGrey, shape: BoxShape.circle),
                                child: Center(
                                    child: Text('${entry.key + 1}',
                                        style: GoogleFonts.dmSans(
                                            fontWeight: FontWeight.bold,
                                            color: kDarkGreen))),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(entry.value,
                                      style: GoogleFonts.dmSans(
                                          fontSize: 15, color: kDarkGreen))),
                              Icon(Icons.lock_outline,
                                  size: 16, color: kTextGrey),
                            ],
                          ),
                        )),
                  ],
                ),
              ),

              // Bottom Action
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => course.enrolled = !course.enrolled);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            course.enrolled ? kPillGrey : kDarkGreen,
                        foregroundColor:
                            course.enrolled ? kDarkGreen : Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        course.enrolled ? 'Continue Learning' : 'Enroll Now',
                        style: GoogleFonts.dmSans(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailInfo(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: kAccentOrange, size: 20),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.dmSans(
                fontWeight: FontWeight.w600, color: kDarkGreen)),
      ],
    );
  }
}

// Model Class
class Course {
  final String title;
  final String instructor;
  final String instructorAvatar;
  final String thumbnailUrl;
  final String price;
  final double rating;
  final int studentsCount;
  final String duration;
  final int lessons;
  final String level;
  final String category;
  final String description;
  final List<String> modules;
  bool enrolled;
  final int progress;
  final bool hasCertificate;

  Course({
    required this.title,
    required this.instructor,
    required this.instructorAvatar,
    required this.thumbnailUrl,
    required this.price,
    required this.rating,
    required this.studentsCount,
    required this.duration,
    required this.lessons,
    required this.level,
    required this.category,
    required this.description,
    required this.modules,
    this.enrolled = false,
    this.progress = 0,
    this.hasCertificate = false,
  });
}
