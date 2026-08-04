class Explore {
  final List<ExploreLiveStream> liveStreams;
  final List<ExploreInSeason> inSeason;
  final List<ExploreGroupBuy> groupBuys;
  final List<ExploreNearbyFarmer> nearbyFarmers;
  final List<ExplorePreOrder> activePreorders;
  final List<ExploreExperience> experiences;

  const Explore({
    required this.liveStreams,
    required this.inSeason,
    required this.groupBuys,
    required this.nearbyFarmers,
    required this.activePreorders,
    required this.experiences,
  });
}

class ExploreLiveStream {
  final String id;
  final String farmerName;
  final String title;
  final String thumbnail;
  final int viewers;
  final String streamUrl;

  const ExploreLiveStream({
    required this.id,
    required this.farmerName,
    required this.title,
    required this.thumbnail,
    required this.viewers,
    required this.streamUrl,
  });
}

class ExploreInSeason {
  final String id;
  final String title;
  final String image;
  final int farmsCount;

  const ExploreInSeason({
    required this.id,
    required this.title,
    required this.image,
    required this.farmsCount,
  });
}

class ExploreGroupBuy {
  final String id;
  final String title;
  final String farmName;
  final double price;
  final double originalPrice;
  final String image;
  final int joinedCount;
  final int targetCount;

  const ExploreGroupBuy({
    required this.id,
    required this.title,
    required this.farmName,
    required this.price,
    required this.originalPrice,
    required this.image,
    required this.joinedCount,
    required this.targetCount,
  });
}

class ExploreNearbyFarmer {
  final String id;
  final String name;
  final String coverImage;
  final double rating;
  final double distanceKm;
  final List<String> specialties;

  const ExploreNearbyFarmer({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.rating,
    required this.distanceKm,
    required this.specialties,
  });
}

class ExplorePreOrder {
  final String id;
  final String title;
  final String farmerName;
  final String image;
  final double progressPercentage;
  final int daysLeft;

  const ExplorePreOrder({
    required this.id,
    required this.title,
    required this.farmerName,
    required this.image,
    required this.progressPercentage,
    required this.daysLeft,
  });
}

class ExploreExperience {
  final String id;
  final String title;
  final String location;
  final String dateString;
  final double price;
  final String image;

  const ExploreExperience({
    required this.id,
    required this.title,
    required this.location,
    required this.dateString,
    required this.price,
    required this.image,
  });
}
