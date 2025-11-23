import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../shared_widgets/app_cached_image.dart';
import 'recipe_detail_screen.dart';
import 'article_detail_screen.dart';
import 'seasonal_calendar_screen.dart';
import 'courses_screen.dart';
import 'farming_tips_screen.dart';

// Data Models
class Season {
  final String name;
  final String icon;
  final Color color;
  final Color backgroundColor;
  final List<String> months;
  final bool isAvailable; // For regions without 4 seasons

  Season({
    required this.name,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.months,
    this.isAvailable = true,
  });
}

class Climate {
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  Climate({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class SeasonalProduce {
  final String name;
  final String category;
  final String imageUrl;
  final String season;
  final String harvestTime;
  final List<String> benefits;
  final String bestPractice;
  final List<String> suitableClimates; // Tropical, Subtropical, Temperate, etc

  SeasonalProduce({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.season,
    required this.harvestTime,
    required this.benefits,
    required this.bestPractice,
    this.suitableClimates = const ['All'],
  });
}

class Recipe {
  final String name;
  final String imageUrl;
  final String difficulty;
  final String time;
  final int servings;
  final List<String> ingredients;
  final List<String> instructions;
  final String category;
  final double rating;
  final String cuisine;
  final int calories;

  Recipe({
    required this.name,
    required this.imageUrl,
    required this.difficulty,
    required this.time,
    required this.servings,
    required this.ingredients,
    required this.instructions,
    required this.category,
    required this.rating,
    required this.cuisine,
    required this.calories,
  });
}

class LearningArticle {
  final String title;
  final String excerpt;
  final String imageUrl;
  final String category;
  final int readTime;
  final String author;
  final DateTime publishDate;

  LearningArticle({
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    required this.category,
    required this.readTime,
    required this.author,
    required this.publishDate,
  });
}

class VideoTutorial {
  final String title;
  final String thumbnailUrl;
  final String duration;
  final String category;
  final int views;
  final double rating;

  VideoTutorial({
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.category,
    required this.views,
    required this.rating,
  });
}

class FarmingTip {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;

  FarmingTip({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
  });
}

class HarvestCalendar {
  final String month;
  final List<String> vegetables;
  final List<String> fruits;
  final List<String> herbs;

  HarvestCalendar({
    required this.month,
    required this.vegetables,
    required this.fruits,
    required this.herbs,
  });
}

class HarvestScreen extends ConsumerStatefulWidget {
  const HarvestScreen({super.key});

  @override
  ConsumerState<HarvestScreen> createState() => _HarvestScreenState();
}

class _HarvestScreenState extends ConsumerState<HarvestScreen> {
  String selectedSeason = 'Year-Round'; // Changed from 'Spring'
  String selectedCategory = 'All';
  String selectedClimate = 'Tropical'; // For users to select their climate

  final List<Climate> climates = [
    Climate(
      name: 'Tropical',
      description: 'Hot and humid year-round (Indonesia, Philippines, Brazil)',
      icon: Icons.wb_sunny,
      color: const Color(0xFFF59E0B),
    ),
    Climate(
      name: 'Subtropical',
      description: 'Mild winters, hot summers (Southern US, parts of China)',
      icon: Icons.cloud,
      color: const Color(0xFF10B981),
    ),
    Climate(
      name: 'Temperate',
      description: 'Four distinct seasons (Europe, Northern US, Japan)',
      icon: Icons.ac_unit,
      color: const Color(0xFF3B82F6),
    ),
    Climate(
      name: 'Arid',
      description: 'Dry climate (Middle East, parts of Australia)',
      icon: Icons.landscape,
      color: const Color(0xFFDC2626),
    ),
  ];

  final List<Season> seasons = [
    Season(
      name: 'Year-Round',
      icon: '🌏',
      color: const Color(0xFF059669),
      backgroundColor: const Color(0xFFD1FAE5),
      months: ['All Months'],
      isAvailable: true,
    ),
    Season(
      name: 'Dry Season',
      icon: '☀️',
      color: const Color(0xFFF59E0B),
      backgroundColor: const Color(0xFFFEF3C7),
      months: ['May - October'],
      isAvailable: true,
    ),
    Season(
      name: 'Wet Season',
      icon: '🌧️',
      color: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFFDBEAFE),
      months: ['November - April'],
      isAvailable: true,
    ),
    Season(
      name: 'Spring',
      icon: '🌸',
      color: const Color(0xFFEC4899),
      backgroundColor: const Color(0xFFFCE7F3),
      months: ['March', 'April', 'May'],
    ),
    Season(
      name: 'Summer',
      icon: '☀️',
      color: const Color(0xFFF59E0B),
      backgroundColor: const Color(0xFFFEF3C7),
      months: ['June', 'July', 'August'],
    ),
    Season(
      name: 'Fall',
      icon: '🍂',
      color: const Color(0xFFEF4444),
      backgroundColor: const Color(0xFFFEE2E2),
      months: ['September', 'October', 'November'],
    ),
    Season(
      name: 'Winter',
      icon: '❄️',
      color: const Color(0xFF3B82F6),
      backgroundColor: const Color(0xFFDBEAFE),
      months: ['December', 'January', 'February'],
    ),
  ];

  final List<SeasonalProduce> yearRoundProduce = [
    SeasonalProduce(
      name: 'Papaya',
      category: 'Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1617112848923-cc2234396a8d?w=400',
      season: 'Year-Round',
      harvestTime: 'All Year',
      benefits: [
        'Rich in vitamin C and A',
        'Aids digestion with papain enzyme',
        'Supports immune system'
      ],
      bestPractice:
          'Harvest when fruit turns yellow-orange and slightly soft to touch',
      suitableClimates: ['Tropical', 'Subtropical'],
    ),
    SeasonalProduce(
      name: 'Banana',
      category: 'Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
      season: 'Year-Round',
      harvestTime: 'All Year',
      benefits: [
        'High in potassium',
        'Natural energy source',
        'Supports heart health'
      ],
      bestPractice:
          'Cut entire bunch when bananas are still green, ripen at room temperature',
      suitableClimates: ['Tropical', 'Subtropical'],
    ),
    SeasonalProduce(
      name: 'Kangkung (Water Spinach)',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      season: 'Year-Round',
      harvestTime: 'All Year',
      benefits: [
        'High in iron and vitamins',
        'Low calorie vegetable',
        'Supports eye health'
      ],
      bestPractice: 'Cut 5-6 inches from growing tip, regrows in 10-14 days',
      suitableClimates: ['Tropical', 'Subtropical'],
    ),
    SeasonalProduce(
      name: 'Chili Peppers',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1583058492096-393bd78a6e46?w=400',
      season: 'Year-Round',
      harvestTime: 'All Year',
      benefits: [
        'Boosts metabolism',
        'Rich in vitamin C',
        'Natural pain relief'
      ],
      bestPractice:
          'Pick when fully colored, regular harvesting promotes more fruiting',
      suitableClimates: ['Tropical', 'Subtropical', 'Temperate'],
    ),
    SeasonalProduce(
      name: 'Mango',
      category: 'Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1605616385733-64db1b0b1dea?w=400',
      season: 'Dry Season',
      harvestTime: 'May - September',
      benefits: [
        'Rich in vitamin A and C',
        'High in antioxidants',
        'Supports digestion'
      ],
      bestPractice:
          'Harvest when fruit develops fragrance and yields to gentle pressure',
      suitableClimates: ['Tropical', 'Subtropical'],
    ),
    SeasonalProduce(
      name: 'Cassava',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1590165482129-1b8b27698780?w=400',
      season: 'Year-Round',
      harvestTime: '8-12 months after planting',
      benefits: [
        'Good source of carbohydrates',
        'Gluten-free alternative',
        'Rich in vitamin C'
      ],
      bestPractice: 'Harvest when leaves start yellowing, use within 2-3 days',
      suitableClimates: ['Tropical', 'Subtropical'],
    ),
    SeasonalProduce(
      name: 'Pakcoy (Bok Choy)',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1598030280061-83f0384273a1?w=400',
      season: 'Year-Round',
      harvestTime: '30-45 days',
      benefits: [
        'High in vitamins A, C, and K',
        'Low calorie',
        'Supports bone health'
      ],
      bestPractice:
          'Harvest when leaves are 6-10 inches tall, best in cooler weather',
      suitableClimates: ['Tropical', 'Subtropical', 'Temperate'],
    ),
    SeasonalProduce(
      name: 'Eggplant (Terong)',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1585838512715-46a0b91c7c12?w=400',
      season: 'Year-Round',
      harvestTime: 'All Year',
      benefits: [
        'Rich in antioxidants',
        'Supports brain function',
        'Good for heart health'
      ],
      bestPractice:
          'Pick when skin is glossy and firm, before seeds turn brown',
      suitableClimates: ['Tropical', 'Subtropical', 'Temperate'],
    ),
  ];

  final List<SeasonalProduce> springProduce = [
    SeasonalProduce(
      name: 'Strawberries',
      category: 'Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400',
      season: 'Spring',
      harvestTime: 'March - May',
      benefits: [
        'Rich in Vitamin C',
        'High in antioxidants',
        'Supports heart health'
      ],
      bestPractice:
          'Harvest in the morning when cool, pick only fully red berries',
    ),
    SeasonalProduce(
      name: 'Asparagus',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1596097635846-4df173c2f0d8?w=400',
      season: 'Spring',
      harvestTime: 'April - June',
      benefits: ['High in folate', 'Good source of fiber', 'Anti-inflammatory'],
      bestPractice:
          'Harvest when spears are 6-8 inches tall, cut at soil level',
    ),
    SeasonalProduce(
      name: 'Lettuce',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=400',
      season: 'Spring',
      harvestTime: 'March - June',
      benefits: ['Low calorie', 'Hydrating', 'Contains vitamins A and K'],
      bestPractice:
          'Harvest outer leaves first, keep harvesting for continuous growth',
    ),
    SeasonalProduce(
      name: 'Peas',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=400',
      season: 'Spring',
      harvestTime: 'April - July',
      benefits: ['High in protein', 'Rich in vitamins', 'Good fiber source'],
      bestPractice: 'Pick when pods are plump but before they harden',
    ),
  ];

  final List<SeasonalProduce> summerProduce = [
    SeasonalProduce(
      name: 'Tomatoes',
      category: 'Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=400',
      season: 'Summer',
      harvestTime: 'June - September',
      benefits: [
        'Rich in lycopene',
        'High in Vitamin C',
        'Supports skin health'
      ],
      bestPractice: 'Harvest when fully colored, store at room temperature',
    ),
    SeasonalProduce(
      name: 'Cucumber',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1604977042946-1eecc30f269e?w=400',
      season: 'Summer',
      harvestTime: 'July - August',
      benefits: [
        '95% water content',
        'Low in calories',
        'Contains antioxidants'
      ],
      bestPractice:
          'Pick when 6-8 inches long, harvest frequently for more production',
    ),
    SeasonalProduce(
      name: 'Bell Peppers',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=400',
      season: 'Summer',
      harvestTime: 'July - October',
      benefits: [
        'High in Vitamin C',
        'Supports eye health',
        'Anti-inflammatory'
      ],
      bestPractice:
          'Cut from plant when firm and fully sized, allow to ripen for color',
    ),
    SeasonalProduce(
      name: 'Zucchini',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1597362925123-77861d3fbac7?w=400',
      season: 'Summer',
      harvestTime: 'June - August',
      benefits: ['Low in carbs', 'High in potassium', 'Supports digestion'],
      bestPractice: 'Harvest when 6-8 inches long for best flavor and texture',
    ),
  ];

  final List<SeasonalProduce> fallProduce = [
    SeasonalProduce(
      name: 'Pumpkin',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1570043788514-ced0d4a45a98?w=400',
      season: 'Fall',
      harvestTime: 'September - November',
      benefits: ['Rich in beta-carotene', 'High in fiber', 'Supports immunity'],
      bestPractice:
          'Harvest when skin is hard and fully colored, leave 3-4 inch stem',
    ),
    SeasonalProduce(
      name: 'Apples',
      category: 'Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
      season: 'Fall',
      harvestTime: 'August - October',
      benefits: [
        'High in fiber',
        'Rich in antioxidants',
        'Supports heart health'
      ],
      bestPractice: 'Twist and lift when apples separate easily from branch',
    ),
    SeasonalProduce(
      name: 'Brussels Sprouts',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1588165842959-c1f27bda75eb?w=400',
      season: 'Fall',
      harvestTime: 'September - February',
      benefits: [
        'High in Vitamin K',
        'Cancer-fighting compounds',
        'Anti-inflammatory'
      ],
      bestPractice: 'Harvest from bottom up when 1-1.5 inches in diameter',
    ),
    SeasonalProduce(
      name: 'Sweet Potato',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1590165482129-1b8b27698780?w=400',
      season: 'Fall',
      harvestTime: 'September - November',
      benefits: [
        'High in Vitamin A',
        'Complex carbohydrates',
        'Supports gut health'
      ],
      bestPractice: 'Dig carefully before first frost, cure for 10-14 days',
    ),
  ];

  final List<SeasonalProduce> winterProduce = [
    SeasonalProduce(
      name: 'Kale',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400',
      season: 'Winter',
      harvestTime: 'November - March',
      benefits: [
        'Superfood status',
        'High in vitamins A, C, K',
        'Supports bone health'
      ],
      bestPractice: 'Harvest outer leaves, sweeter after light frost',
    ),
    SeasonalProduce(
      name: 'Carrots',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400',
      season: 'Winter',
      harvestTime: 'November - April',
      benefits: [
        'Rich in beta-carotene',
        'Supports eye health',
        'High in fiber'
      ],
      bestPractice: 'Can overwinter in ground with mulch, sweeter after frost',
    ),
    SeasonalProduce(
      name: 'Cabbage',
      category: 'Vegetable',
      imageUrl:
          'https://images.unsplash.com/photo-1594282270197-751000043b4e?w=400',
      season: 'Winter',
      harvestTime: 'December - March',
      benefits: [
        'High in Vitamin C',
        'Supports digestion',
        'Anti-inflammatory'
      ],
      bestPractice: 'Harvest when heads are firm and dense, can tolerate frost',
    ),
    SeasonalProduce(
      name: 'Citrus Fruits',
      category: 'Fruit',
      imageUrl:
          'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
      season: 'Winter',
      harvestTime: 'December - March',
      benefits: ['Vitamin C powerhouse', 'Boosts immunity', 'Hydrating'],
      bestPractice:
          'Test for ripeness by taste, citrus doesn\'t ripen after picking',
    ),
  ];

  final List<Recipe> recipes = [
    Recipe(
      name: 'Fresh Strawberry Salad',
      imageUrl:
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
      difficulty: 'Easy',
      time: '15 min',
      servings: 4,
      ingredients: [
        'Fresh strawberries 2 cups',
        'Baby spinach 4 cups',
        'Feta cheese 1/2 cup',
        'Balsamic vinegar 3 tbsp',
        'Walnuts 1/3 cup',
        'Olive oil 2 tbsp',
        'Honey 1 tbsp'
      ],
      instructions: [
        'Wash and slice strawberries',
        'Toast walnuts in a dry pan for 3-4 minutes',
        'Combine spinach, strawberries, and walnuts in a large bowl',
        'Whisk together balsamic vinegar, olive oil, and honey',
        'Toss salad with dressing and top with crumbled feta',
        'Serve immediately for best freshness'
      ],
      category: 'Salad',
      rating: 4.8,
      cuisine: 'International',
      calories: 245,
    ),
    Recipe(
      name: 'Roasted Tomato Pasta',
      imageUrl:
          'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400',
      difficulty: 'Medium',
      time: '35 min',
      servings: 6,
      ingredients: [
        'Cherry tomatoes 4 cups',
        'Pasta 1 lb',
        'Garlic 6 cloves',
        'Fresh basil 1 cup',
        'Olive oil 1/4 cup',
        'Parmesan cheese 1/2 cup',
        'Salt and pepper to taste'
      ],
      instructions: [
        'Preheat oven to 400°F (200°C)',
        'Toss tomatoes with olive oil, minced garlic, salt, and pepper',
        'Roast tomatoes for 20-25 minutes until bursting',
        'Cook pasta according to package directions',
        'Combine pasta with roasted tomatoes and their juices',
        'Tear in fresh basil and mix well',
        'Top with grated Parmesan before serving'
      ],
      category: 'Main Course',
      rating: 4.9,
      cuisine: 'Italian',
      calories: 380,
    ),
    Recipe(
      name: 'Indonesian Gado-Gado',
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      difficulty: 'Medium',
      time: '30 min',
      servings: 4,
      ingredients: [
        'Mixed vegetables 4 cups',
        'Peanut butter 1/2 cup',
        'Tamarind paste 2 tbsp',
        'Palm sugar 2 tbsp',
        'Garlic 3 cloves',
        'Chili 2 pieces',
        'Hard-boiled eggs 4',
        'Fried tofu 200g'
      ],
      instructions: [
        'Blanch vegetables (cabbage, bean sprouts, long beans)',
        'Boil eggs and cut into halves',
        'Blend peanut butter, tamarind, palm sugar, garlic, chili with water',
        'Heat peanut sauce until thickened',
        'Arrange vegetables, tofu, and eggs on plate',
        'Pour warm peanut sauce over vegetables',
        'Garnish with crispy shallots and prawn crackers'
      ],
      category: 'Main Course',
      rating: 4.9,
      cuisine: 'Indonesian',
      calories: 425,
    ),
    Recipe(
      name: 'Grilled Vegetables Mix',
      imageUrl:
          'https://images.unsplash.com/photo-1607305387299-a3d9611cd469?w=400',
      difficulty: 'Easy',
      time: '20 min',
      servings: 4,
      ingredients: [
        'Zucchini 2 pieces',
        'Bell peppers 3 colors',
        'Eggplant 1 large',
        'Olive oil 3 tbsp',
        'Mixed herbs 2 tbsp',
        'Lemon juice 2 tbsp',
        'Salt and pepper to taste'
      ],
      instructions: [
        'Preheat grill to medium-high heat',
        'Slice vegetables into 1/2 inch thick pieces',
        'Brush vegetables with olive oil and season',
        'Grill for 4-5 minutes per side until char marks appear',
        'Remove from grill and sprinkle with fresh herbs',
        'Drizzle with lemon juice before serving'
      ],
      category: 'Side Dish',
      rating: 4.7,
      cuisine: 'Mediterranean',
      calories: 180,
    ),
    Recipe(
      name: 'Pumpkin Soup',
      imageUrl:
          'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400',
      difficulty: 'Easy',
      time: '40 min',
      servings: 6,
      ingredients: [
        'Pumpkin 2 lbs',
        'Onion 1 large',
        'Heavy cream 1 cup',
        'Vegetable broth 4 cups',
        'Nutmeg 1/4 tsp',
        'Cinnamon 1/4 tsp',
        'Butter 2 tbsp',
        'Salt and pepper to taste'
      ],
      instructions: [
        'Peel and cube pumpkin into 1-inch pieces',
        'Sauté diced onion in butter until translucent',
        'Add pumpkin cubes and cook for 5 minutes',
        'Pour in vegetable broth and bring to boil',
        'Simmer for 20 minutes until pumpkin is tender',
        'Blend soup until smooth using immersion blender',
        'Stir in cream, nutmeg, and cinnamon',
        'Season with salt and pepper, serve warm'
      ],
      category: 'Soup',
      rating: 4.9,
      cuisine: 'American',
      calories: 220,
    ),
    Recipe(
      name: 'Thai Green Curry',
      imageUrl:
          'https://images.unsplash.com/photo-1455619452474-d2be8b1e70cd?w=400',
      difficulty: 'Medium',
      time: '35 min',
      servings: 4,
      ingredients: [
        'Green curry paste 3 tbsp',
        'Coconut milk 2 cans',
        'Chicken 1 lb',
        'Thai eggplant 2 cups',
        'Thai basil 1 cup',
        'Fish sauce 2 tbsp',
        'Palm sugar 1 tbsp',
        'Kaffir lime leaves 4'
      ],
      instructions: [
        'Heat 1/4 cup thick coconut cream in wok',
        'Fry curry paste until fragrant (2-3 minutes)',
        'Add chicken pieces and stir-fry until coated',
        'Pour remaining coconut milk and bring to simmer',
        'Add eggplant and cook for 10 minutes',
        'Season with fish sauce and palm sugar',
        'Add Thai basil and kaffir lime leaves',
        'Serve hot with jasmine rice'
      ],
      category: 'Main Course',
      rating: 4.8,
      cuisine: 'Thai',
      calories: 465,
    ),
  ];

  final List<LearningArticle> articles = [
    LearningArticle(
      title: 'Sustainable Farming Practices for Small-Scale Farmers',
      excerpt:
          'Learn how to implement eco-friendly farming methods that increase yield while protecting the environment...',
      imageUrl:
          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=400',
      category: 'Sustainability',
      readTime: 8,
      author: 'Dr. Sarah Green',
      publishDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    LearningArticle(
      title: 'Organic Pest Control: Natural Solutions That Work',
      excerpt:
          'Discover effective organic methods to protect your crops without harmful chemicals...',
      imageUrl:
          'https://images.unsplash.com/photo-1464226184884-fa280b87c399?w=400',
      category: 'Pest Management',
      readTime: 6,
      author: 'Michael Chen',
      publishDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    LearningArticle(
      title: 'Hydroponics for Beginners: Growing Without Soil',
      excerpt:
          'Step-by-step guide to setting up your first hydroponic system at home...',
      imageUrl:
          'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=400',
      category: 'Innovation',
      readTime: 10,
      author: 'Emma Rodriguez',
      publishDate: DateTime.now().subtract(const Duration(days: 7)),
    ),
    LearningArticle(
      title: 'Maximizing Yield in Tropical Climates',
      excerpt:
          'Best practices for farming in hot and humid conditions common in Southeast Asia...',
      imageUrl:
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400',
      category: 'Climate',
      readTime: 7,
      author: 'Ahmad Wijaya',
      publishDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  final List<VideoTutorial> videos = [
    VideoTutorial(
      title: 'How to Build a Raised Garden Bed',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400',
      duration: '12:45',
      category: 'DIY',
      views: 145000,
      rating: 4.9,
    ),
    VideoTutorial(
      title: 'Composting 101: Turn Waste into Gold',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1597308680537-3541ac6b7a8e?w=400',
      duration: '8:30',
      category: 'Sustainability',
      views: 89000,
      rating: 4.7,
    ),
    VideoTutorial(
      title: 'Drip Irrigation System Installation',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2?w=400',
      duration: '15:20',
      category: 'Irrigation',
      views: 67000,
      rating: 4.8,
    ),
    VideoTutorial(
      title: 'Pruning Tomato Plants for Maximum Yield',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1592841200221-a6898f307baa?w=400',
      duration: '6:15',
      category: 'Plant Care',
      views: 234000,
      rating: 4.9,
    ),
  ];

  final List<FarmingTip> farmingTips = [
    FarmingTip(
      title: 'Companion Planting',
      description:
          'Plant tomatoes with basil to improve flavor and repel pests naturally',
      category: 'Pest Control',
      icon: Icons.bug_report,
      color: const Color(0xFF22C55E),
    ),
    FarmingTip(
      title: 'Crop Rotation',
      description:
          'Rotate crops each season to maintain soil nutrients and prevent disease',
      category: 'Soil Health',
      icon: Icons.recycling,
      color: const Color(0xFF8B5CF6),
    ),
    FarmingTip(
      title: 'Watering Schedule',
      description:
          'Water deeply but less frequently to encourage strong root development',
      category: 'Irrigation',
      icon: Icons.water_drop,
      color: const Color(0xFF3B82F6),
    ),
    FarmingTip(
      title: 'Mulching Benefits',
      description:
          'Apply 2-3 inches of mulch to retain moisture and suppress weeds',
      category: 'Maintenance',
      icon: Icons.grass,
      color: const Color(0xFFF59E0B),
    ),
    FarmingTip(
      title: 'Pruning Techniques',
      description:
          'Remove suckers from tomato plants to direct energy to fruit production',
      category: 'Plant Care',
      icon: Icons.content_cut,
      color: const Color(0xFFEC4899),
    ),
    FarmingTip(
      title: 'Composting',
      description:
          'Create nutrient-rich soil by composting kitchen scraps and yard waste',
      category: 'Soil Health',
      icon: Icons.compost,
      color: const Color(0xFF059669),
    ),
  ];

  List<SeasonalProduce> get currentSeasonProduce {
    switch (selectedSeason) {
      case 'Year-Round':
        return yearRoundProduce;
      case 'Dry Season':
        return summerProduce; // Can be customized for tropical dry season
      case 'Wet Season':
        return springProduce; // Can be customized for tropical wet season
      case 'Spring':
        return springProduce;
      case 'Summer':
        return summerProduce;
      case 'Fall':
        return fallProduce;
      case 'Winter':
        return winterProduce;
      default:
        return yearRoundProduce;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Learn & Explore',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search coming soon')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved items coming soon')),
                  );
                },
              ),
            ],
          ),

          // Season Selector
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Season',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: seasons.length,
                      itemBuilder: (context, index) {
                        final season = seasons[index];
                        final isSelected = selectedSeason == season.name;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSeason = season.name;
                            });
                          },
                          child: Container(
                            width: 85,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? season.color
                                  : season.backgroundColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: season.color.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  season.icon,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  season.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : season.color,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quick Access Features
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Access',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAccessCard(
                          icon: Icons.calendar_month,
                          title: 'Seasonal\nCalendar',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SeasonalCalendarScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAccessCard(
                          icon: Icons.school,
                          title: 'Courses &\nWorkshops',
                          color: Colors.purple,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CoursesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAccessCard(
                          icon: Icons.lightbulb,
                          title: 'Farming\nTips',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FarmingTipsScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAccessCard(
                          icon: Icons.restaurant_menu,
                          title: 'Recipe\nCollection',
                          color: Colors.green,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Recipe collection coming soon')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Seasonal Produce Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$selectedSeason Harvest',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('View all coming soon')),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),

          // Produce Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final produce = currentSeasonProduce[index];
                  return _buildProduceCard(produce);
                },
                childCount: currentSeasonProduce.length,
              ),
            ),
          ),

          // Recipes Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.restaurant_menu,
                          color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Fresh Recipes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('All recipes coming soon')),
                      );
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return _buildRecipeCard(recipes[index]);
                },
              ),
            ),
          ),

          // Farming Tips Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Farming Tips',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildFarmingTipCard(farmingTips[index]);
                },
                childCount: farmingTips.length,
              ),
            ),
          ),

          // Learning Articles Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.article_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Latest Articles',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildArticleCard(articles[index]);
                },
                childCount: articles.length,
              ),
            ),
          ),

          // Video Tutorials Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.play_circle_outline,
                      color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Video Tutorials',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  return _buildVideoCard(videos[index]);
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildProduceCard(SeasonalProduce produce) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            _showProduceDetails(produce);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: AppCachedImage(
                  imageUrl: produce.imageUrl,
                  height: 120,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produce.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: produce.category == 'Fruit'
                            ? Colors.orange[50]
                            : Colors.green[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        produce.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: produce.category == 'Fruit'
                              ? Colors.orange[700]
                              : Colors.green[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            produce.harvestTime,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(
                  recipeName: recipe.name,
                  recipeImageUrl: recipe.imageUrl,
                  difficulty: recipe.difficulty,
                  time: recipe.time,
                  servings: recipe.servings,
                  ingredients: recipe.ingredients,
                  instructions: recipe.instructions,
                  category: recipe.category,
                  rating: recipe.rating,
                  cuisine: recipe.cuisine,
                  calories: recipe.calories,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with difficulty badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AppCachedImage(
                      imageUrl: recipe.imageUrl,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: recipe.difficulty == 'Easy'
                            ? Colors.green
                            : recipe.difficulty == 'Medium'
                                ? Colors.orange
                                : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        recipe.difficulty,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          recipe.time,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          recipe.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.restaurant,
                            size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.servings} servings',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFarmingTipCard(FarmingTip tip) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${tip.title} details coming soon')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tip.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    tip.icon,
                    color: tip.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tip.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProduceDetails(SeasonalProduce produce) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
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
                  imageUrl: produce.imageUrl,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                produce.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: produce.category == 'Fruit'
                          ? Colors.orange[50]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      produce.category,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: produce.category == 'Fruit'
                            ? Colors.orange[700]
                            : Colors.green[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: Colors.blue[700]),
                        const SizedBox(width: 4),
                        Text(
                          produce.harvestTime,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Health Benefits',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...produce.benefits.map((benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            benefit,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[800]),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              const Text(
                'Best Practice',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        produce.bestPractice,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(LearningArticle article) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(
                  title: article.title,
                  imageUrl: article.imageUrl,
                  category: article.category,
                  readTime: article.readTime,
                  author: article.author,
                  publishDate: article.publishDate,
                ),
              ),
            );
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(16)),
                child: AppCachedImage(
                  imageUrl: article.imageUrl,
                  width: 100,
                  height: 120,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          article.category,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.excerpt,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            '${article.readTime} min read',
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.person_outline,
                              size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              article.author,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey[600]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(VideoTutorial video) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${video.title} - Video player coming soon')),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: AppCachedImage(
                      imageUrl: video.thumbnailUrl,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video.duration,
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
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.visibility,
                            size: 12, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${(video.views / 1000).toStringAsFixed(0)}K views',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          video.rating.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRecipeDetails(Recipe recipe) {
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
                  imageUrl: recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                recipe.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildRecipeInfoChip(
                      Icons.restaurant_menu, recipe.cuisine, Colors.purple),
                  _buildRecipeInfoChip(
                      Icons.access_time, recipe.time, Colors.blue),
                  _buildRecipeInfoChip(Icons.people,
                      '${recipe.servings} servings', Colors.green),
                  _buildRecipeInfoChip(Icons.local_fire_department,
                      '${recipe.calories} cal', Colors.orange),
                  _buildRecipeInfoChip(
                      Icons.bar_chart,
                      recipe.difficulty,
                      recipe.difficulty == 'Easy'
                          ? Colors.green
                          : recipe.difficulty == 'Medium'
                              ? Colors.orange
                              : Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    recipe.rating.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(Based on reviews)',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...recipe.ingredients.map((ingredient) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ingredient,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              const Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...recipe.instructions.asMap().entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              '${entry.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
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
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Save recipe feature coming soon')),
                  );
                },
                icon: const Icon(Icons.bookmark_border),
                label: const Text('Save Recipe'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildRecipeInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
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

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
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
