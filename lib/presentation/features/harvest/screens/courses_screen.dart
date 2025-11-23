import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../shared_widgets/app_cached_image.dart';

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
        'Introduction to Organic Farming',
        'Soil Health & Preparation',
        'Seed Selection & Planting',
        'Organic Pest Management',
        'Harvest & Storage Techniques',
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
          'Master the art of composting and turn waste into black gold for your garden.',
      modules: [
        'Composting Basics',
        'Brown vs Green Materials',
        'Temperature & Moisture Control',
        'Troubleshooting Common Issues',
        'Using Finished Compost',
      ],
      enrolled: true,
      progress: 65,
      hasCertificate: true,
    ),
    Course(
      title: 'Hydroponic Systems Setup',
      instructor: 'Emma Rodriguez',
      instructorAvatar: 'https://i.pravatar.cc/150?img=3',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=400',
      price: '\$49',
      rating: 4.7,
      studentsCount: 987,
      duration: '6 weeks',
      lessons: 30,
      level: 'Intermediate',
      category: 'Gardening',
      description:
          'Build and maintain your own hydroponic system for year-round growing.',
      modules: [
        'Hydroponic Fundamentals',
        'System Types & Selection',
        'Nutrient Solutions',
        'pH & EC Management',
        'Troubleshooting & Maintenance',
        'Advanced Techniques',
      ],
      enrolled: false,
      progress: 0,
      hasCertificate: true,
    ),
    Course(
      title: 'Natural Pest Control Methods',
      instructor: 'Ahmad Wijaya',
      instructorAvatar: 'https://i.pravatar.cc/150?img=4',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400',
      price: 'Free',
      rating: 4.6,
      studentsCount: 3421,
      duration: '3 weeks',
      lessons: 18,
      level: 'Beginner',
      category: 'Pest Control',
      description:
          'Protect your crops using natural, chemical-free pest control methods.',
      modules: [
        'Understanding Garden Pests',
        'Beneficial Insects',
        'Companion Planting',
        'Organic Sprays & Solutions',
        'Integrated Pest Management',
      ],
      enrolled: true,
      progress: 30,
      hasCertificate: false,
    ),
    Course(
      title: 'Smart Irrigation Techniques',
      instructor: 'David Martinez',
      instructorAvatar: 'https://i.pravatar.cc/150?img=5',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400',
      price: '\$39',
      rating: 4.8,
      studentsCount: 1567,
      duration: '4 weeks',
      lessons: 20,
      level: 'Intermediate',
      category: 'Irrigation',
      description:
          'Maximize water efficiency with modern irrigation systems and techniques.',
      modules: [
        'Water Requirements',
        'Drip Irrigation Systems',
        'Sprinkler Systems',
        'Smart Controllers',
        'Rainwater Harvesting',
      ],
      enrolled: false,
      progress: 0,
      hasCertificate: true,
    ),
    Course(
      title: 'Harvest & Post-Harvest Handling',
      instructor: 'Lisa Wong',
      instructorAvatar: 'https://i.pravatar.cc/150?img=6',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
      price: '\$25',
      rating: 4.9,
      studentsCount: 2103,
      duration: '2 weeks',
      lessons: 15,
      level: 'Beginner',
      category: 'Harvesting',
      description:
          'Learn optimal harvest timing and proper handling to maximize crop quality.',
      modules: [
        'Harvest Timing',
        'Proper Harvest Techniques',
        'Cleaning & Sorting',
        'Storage Methods',
        'Extending Shelf Life',
      ],
      enrolled: false,
      progress: 0,
      hasCertificate: true,
    ),
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
      appBar: AppBar(
        title: const Text('Courses & Workshops'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Courses'),
            Tab(text: 'My Learning'),
          ],
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
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                ),
              );
            },
          ),
        ),

        // Courses List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredCourses.length,
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
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No courses enrolled yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Start learning by enrolling in a course',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: enrolledCourses.length,
      itemBuilder: (context, index) {
        return _buildEnrolledCourseCard(enrolledCourses[index]);
      },
    );
  }

  Widget _buildCourseCard(Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showCourseDetails(course);
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  AppCachedImage(
                    imageUrl: course.thumbnailUrl,
                    width: double.infinity,
                    height: 180,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: course.price == 'Free'
                            ? Colors.green
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course.level,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(course.instructorAvatar),
                        radius: 12,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          course.instructor,
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.studentsCount}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        course.duration,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.play_circle_outline,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${course.lessons} lessons',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      if (course.hasCertificate) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.workspace_premium,
                            size: 16, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(
                          'Certificate',
                          style:
                              TextStyle(fontSize: 13, color: Colors.amber[700]),
                        ),
                      ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          _showCourseDetails(course);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppCachedImage(
                      imageUrl: course.thumbnailUrl,
                      width: 80,
                      height: 80,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course.instructor,
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${course.progress}% Complete',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: course.progress / 100,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Continue learning...')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Continue Learning'),
              ),
            ],
          ),
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
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCachedImage(
                  imageUrl: course.thumbnailUrl,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                course.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(course.instructorAvatar),
                    radius: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    course.instructor,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildInfoChip(Icons.star, '${course.rating}', Colors.amber),
                  _buildInfoChip(Icons.people,
                      '${course.studentsCount} students', Colors.blue),
                  _buildInfoChip(
                      Icons.access_time, course.duration, Colors.green),
                  _buildInfoChip(Icons.play_circle, '${course.lessons} lessons',
                      Colors.purple),
                  _buildInfoChip(
                    Icons.signal_cellular_alt,
                    course.level,
                    course.level == 'Beginner'
                        ? Colors.green
                        : course.level == 'Intermediate'
                            ? Colors.orange
                            : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                course.description,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
              const SizedBox(height: 24),
              const Text(
                'Course Modules',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...course.modules.asMap().entries.map((entry) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    course.enrolled = !course.enrolled;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        course.enrolled
                            ? 'Enrolled successfully!'
                            : 'Unenrolled from course',
                      ),
                    ),
                  );
                },
                icon: Icon(
                    course.enrolled ? Icons.check_circle : Icons.add_circle),
                label: Text(course.enrolled ? 'Enrolled' : 'Enroll Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor:
                      course.enrolled ? Colors.grey : AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

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
