import '../models/nearby_place.dart';

class MockNearbyPlaces {
  static const places = <NearbyPlace>[
    // ─────────────────────────────────────────
    // TOURIST / FAMOUS PLACES
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'tourist_bangalore_palace',
      name: 'Bangalore Palace',
      category: 'Tourist',
      address: 'Vasanth Nagar, Bengaluru, Karnataka',
      latitude: 13.0035,
      longitude: 77.5891,
      description:
          'Historic Tudor-style palace and one of Bengaluru’s most famous landmarks.',
      icon: 'tourist',
    ),

    NearbyPlace(
      id: 'tourist_cubbon_park',
      name: 'Cubbon Park',
      category: 'Tourist',
      address: 'Kasturba Road, Bengaluru, Karnataka',
      latitude: 12.9763,
      longitude: 77.5929,
      description:
          'A major green space in the heart of Bengaluru.',
      icon: 'park',
    ),

    NearbyPlace(
      id: 'tourist_vidhana_soudha',
      name: 'Vidhana Soudha',
      category: 'Tourist',
      address: 'Dr Ambedkar Veedhi, Bengaluru, Karnataka',
      latitude: 12.9797,
      longitude: 77.5907,
      description:
          'Iconic Bengaluru landmark and seat of the Karnataka legislature.',
      icon: 'government',
    ),

    NearbyPlace(
      id: 'tourist_lalbagh',
      name: 'Lalbagh Botanical Garden',
      category: 'Tourist',
      address: 'Mavalli, Bengaluru, Karnataka',
      latitude: 12.9507,
      longitude: 77.5848,
      description:
          'Historic botanical garden famous for its glass house and diverse plants.',
      icon: 'park',
    ),

    NearbyPlace(
      id: 'tourist_iskcon',
      name: 'ISKCON Temple Bengaluru',
      category: 'Tourist',
      address: 'Rajajinagar, Bengaluru, Karnataka',
      latitude: 13.0098,
      longitude: 77.5511,
      description:
          'Major cultural and spiritual destination in Bengaluru.',
      icon: 'temple',
    ),

    // ─────────────────────────────────────────
    // PETROL
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'petrol_1',
      name: 'Bharat Petroleum',
      category: 'Petrol',
      address: 'Near Vasanth Nagar, Bengaluru',
      latitude: 12.9995,
      longitude: 77.5905,
      description:
          'Petrol and fuel station near the current area.',
      icon: 'petrol',
    ),

    NearbyPlace(
      id: 'petrol_2',
      name: 'IndianOil Fuel Station',
      category: 'Petrol',
      address: 'Cunningham Road, Bengaluru',
      latitude: 12.9971,
      longitude: 77.5948,
      description:
          'Fuel station providing petrol and diesel services.',
      icon: 'petrol',
    ),

    // ─────────────────────────────────────────
    // COLLEGES
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'college_1',
      name: 'Mount Carmel College',
      category: 'College',
      address: 'Vasanth Nagar, Bengaluru',
      latitude: 12.9909,
      longitude: 77.5862,
      description:
          'Higher education institution in central Bengaluru.',
      icon: 'college',
    ),

    NearbyPlace(
      id: 'college_2',
      name: 'Bangalore Institute of Technology',
      category: 'College',
      address: 'VV Puram, Bengaluru',
      latitude: 12.9484,
      longitude: 77.5742,
      description:
          'Engineering institution in Bengaluru.',
      icon: 'college',
    ),

    // ─────────────────────────────────────────
    // SCHOOLS
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'school_1',
      name: 'Bishop Cotton Boys School',
      category: 'School',
      address: 'St. Mark’s Road, Bengaluru',
      latitude: 12.9678,
      longitude: 77.5981,
      description:
          'Established educational institution in central Bengaluru.',
      icon: 'school',
    ),

    NearbyPlace(
      id: 'school_2',
      name: 'National Public School',
      category: 'School',
      address: 'Indiranagar, Bengaluru',
      latitude: 12.9784,
      longitude: 77.6408,
      description:
          'School located in Bengaluru.',
      icon: 'school',
    ),

    // ─────────────────────────────────────────
    // TEMPLES
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'temple_1',
      name: 'Bull Temple',
      category: 'Temple',
      address: 'Basavanagudi, Bengaluru',
      latitude: 12.9410,
      longitude: 77.5692,
      description:
          'Historic temple dedicated to Nandi.',
      icon: 'temple',
    ),

    NearbyPlace(
      id: 'temple_2',
      name: 'Dodda Ganapathi Temple',
      category: 'Temple',
      address: 'Basavanagudi, Bengaluru',
      latitude: 12.9419,
      longitude: 77.5697,
      description:
          'Popular Ganesha temple in Basavanagudi.',
      icon: 'temple',
    ),

    // ─────────────────────────────────────────
    // HOSPITALS
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'hospital_1',
      name: 'Mallya Hospital',
      category: 'Hospital',
      address: 'Vittal Mallya Road, Bengaluru',
      latitude: 12.9698,
      longitude: 77.5947,
      description:
          'Hospital providing a range of medical services.',
      icon: 'hospital',
    ),

    NearbyPlace(
      id: 'hospital_2',
      name: 'Bowring and Lady Curzon Hospital',
      category: 'Hospital',
      address: 'Shivajinagar, Bengaluru',
      latitude: 12.9826,
      longitude: 77.6050,
      description:
          'Major government hospital in Bengaluru.',
      icon: 'hospital',
    ),

    // ─────────────────────────────────────────
    // RESTAURANTS
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'restaurant_1',
      name: 'MTR',
      category: 'Restaurant',
      address: 'Lalbagh Road, Bengaluru',
      latitude: 12.9551,
      longitude: 77.5842,
      description:
          'Well-known South Indian restaurant.',
      icon: 'restaurant',
    ),

    NearbyPlace(
      id: 'restaurant_2',
      name: 'Vidyarthi Bhavan',
      category: 'Restaurant',
      address: 'Basavanagudi, Bengaluru',
      latitude: 12.9452,
      longitude: 77.5714,
      description:
          'Popular Bengaluru restaurant known for South Indian breakfast.',
      icon: 'restaurant',
    ),

    // ─────────────────────────────────────────
    // ATM
    // ─────────────────────────────────────────

    NearbyPlace(
      id: 'atm_1',
      name: 'HDFC Bank ATM',
      category: 'ATM',
      address: 'Cunningham Road, Bengaluru',
      latitude: 12.9983,
      longitude: 77.5942,
      description:
          'ATM facility available near the current area.',
      icon: 'atm',
    ),

    NearbyPlace(
      id: 'atm_2',
      name: 'ICICI Bank ATM',
      category: 'ATM',
      address: 'Vasanth Nagar, Bengaluru',
      latitude: 12.9957,
      longitude: 77.5887,
      description:
          'ATM facility available nearby.',
      icon: 'atm',
    ),
  ];
}