// lib/services/mock_data_service.dart
// Provides sample watch data for demo (no real Firebase needed for UI)
import '../models/watch_model.dart';

class MockDataService {
  static List<WatchModel> getSampleWatches() {
    return [
      WatchModel(
        id: '1',
        name: 'Royal Oak Automatic',
        brand: 'Audemars Piguet',
        category: 'Luxury',
        price: 450000,
        discountPrice: 399000,
        rating: 4.9,
        reviewCount: 128,
        images: [
          'https://images.unsplash.com/photo-1547996160-81dfa63595aa?w=800',
          'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=800',
        ],
        description:
            'The Royal Oak Automatic is a masterpiece of Swiss watchmaking. Featuring the iconic octagonal bezel and integrated bracelet, this watch combines sportiness with luxury.',
        isNew: false,
        isFeatured: true,
        isBestSeller: true,
        stock: 5,
        specs: {
          'Movement': 'Self-winding mechanical',
          'Case Material': 'Stainless Steel',
          'Dial Color': 'Blue tapisserie',
          'Water Resistance': '50m',
          'Case Diameter': '41mm',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      WatchModel(
        id: '2',
        name: 'Submariner Date',
        brand: 'Rolex',
        category: "Men's",
        price: 850000,
        rating: 5.0,
        reviewCount: 256,
        images: [
          'https://images.unsplash.com/photo-1587836374828-4dbafa94cf0e?w=800',
          'https://images.unsplash.com/photo-1548169874-53e85f753f1e?w=800',
        ],
        description:
            'The Submariner Date is the reference of reference among divers\' watches. Waterproof to a depth of 300m, it features a unidirectional rotatable bezel and is equipped with the Calibre 3235 movement.',
        isFeatured: true,
        isBestSeller: true,
        stock: 3,
        specs: {
          'Movement': 'Calibre 3235',
          'Case Material': 'Oystersteel',
          'Dial Color': 'Black',
          'Water Resistance': '300m',
          'Case Diameter': '41mm',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      WatchModel(
        id: '3',
        name: 'Speedmaster Moonwatch',
        brand: 'Omega',
        category: "Men's",
        price: 320000,
        discountPrice: 285000,
        rating: 4.8,
        reviewCount: 189,
        images: [
          'https://images.unsplash.com/photo-1609587312208-cea54be969e7?w=800',
          'https://images.unsplash.com/photo-1624620389630-1d7c11b0d3c7?w=800',
        ],
        description:
            'The watch that went to the Moon. The Omega Speedmaster Professional Moonwatch is a legendary timepiece with Co-Axial Master Chronometer chronograph movement.',
        isNew: true,
        isFeatured: true,
        stock: 8,
        specs: {
          'Movement': 'Co-Axial Master Chronometer',
          'Case Material': 'Stainless Steel',
          'Dial Color': 'Black',
          'Water Resistance': '50m',
          'Case Diameter': '42mm',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      WatchModel(
        id: '4',
        name: 'Aquanaut',
        brand: 'Patek Philippe',
        category: 'Luxury',
        price: 1200000,
        rating: 4.9,
        reviewCount: 75,
        images: [
          'https://images.unsplash.com/photo-1612817288484-6f916006741a?w=800',
          'https://images.unsplash.com/photo-1542496658-e33a6d0d56f4?w=800',
        ],
        description:
            'The Patek Philippe Aquanaut embodies the spirit of active elegance. With its contemporary design and outstanding technical features, it is the ideal companion for an active lifestyle.',
        isFeatured: true,
        stock: 2,
        specs: {
          'Movement': 'Calibre 324 S C',
          'Case Material': 'White Gold',
          'Dial Color': 'Khaki',
          'Water Resistance': '120m',
          'Case Diameter': '40mm',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      WatchModel(
        id: '5',
        name: 'Apple Watch Ultra 2',
        brand: 'Apple',
        category: 'Smart',
        price: 125000,
        discountPrice: 109000,
        rating: 4.7,
        reviewCount: 512,
        images: [
          'https://images.unsplash.com/photo-1579586337278-3befd40fd17a?w=800',
          'https://images.unsplash.com/photo-1434056886845-dac89ffe9b56?w=800',
        ],
        description:
            'Apple Watch Ultra 2. The most capable and rugged Apple Watch yet. Designed for athletes and adventurers with the brightest Apple Watch display ever.',
        isNew: true,
        isBestSeller: true,
        stock: 20,
        specs: {
          'Chip': 'S9 SiP',
          'Case Material': 'Titanium',
          'Display': 'Always-On Retina',
          'Water Resistance': '100m WR50',
          'Battery': '60 hours',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      WatchModel(
        id: '6',
        name: 'Datejust 36',
        brand: 'Rolex',
        category: "Women's",
        price: 650000,
        rating: 4.9,
        reviewCount: 143,
        images: [
          'https://images.unsplash.com/photo-1580469386196-7c4a2f1f4bed?w=800',
          'https://images.unsplash.com/photo-1594534475808-b18fc33b045e?w=800',
        ],
        description:
            'The Rolex Datejust 36 is an iconic watch featuring a fluted bezel and Jubilee bracelet. Its mop dial with diamond hour markers radiates timeless elegance.',
        isFeatured: true,
        stock: 4,
        specs: {
          'Movement': 'Calibre 3235',
          'Case Material': 'Rolesor',
          'Dial Color': 'MOP with diamonds',
          'Water Resistance': '100m',
          'Case Diameter': '36mm',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      WatchModel(
        id: '7',
        name: 'G-Shock GA-2100',
        brand: 'Casio',
        category: "Men's",
        price: 15000,
        discountPrice: 12500,
        rating: 4.5,
        reviewCount: 892,
        images: [
          'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=800',
          'https://images.unsplash.com/photo-1591154669695-5f2a8d20c089?w=800',
        ],
        description:
            'The G-SHOCK GA-2100 "CasiOak" is an ultra-thin Carbon Core Guard watch with an octagonal bezel design inspired by high-end luxury watches.',
        isNew: true,
        isBestSeller: true,
        stock: 50,
        specs: {
          'Movement': 'Quartz',
          'Case Material': 'Carbon Core Guard',
          'Shock Resistance': 'Yes',
          'Water Resistance': '200m',
          'Case Thickness': '11.8mm',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      WatchModel(
        id: '8',
        name: 'Galaxy Watch 6',
        brand: 'Samsung',
        category: 'Smart',
        price: 45000,
        discountPrice: 38000,
        rating: 4.6,
        reviewCount: 320,
        images: [
          'https://images.unsplash.com/photo-1523475496153-3e0fce5a3f7b?w=800',
          'https://images.unsplash.com/photo-1461141346587-763ab02bced9?w=800',
        ],
        description:
            'Samsung Galaxy Watch 6 features an Advanced Health Monitor, bright AMOLED display, and a sleek redesigned case for a premium smart watch experience.',
        isNew: true,
        stock: 25,
        specs: {
          'OS': 'Wear OS',
          'Display': 'Super AMOLED',
          'RAM': '2GB',
          'Storage': '16GB',
          'Water Resistance': '5ATM + MIL-STD-810H',
        },
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  static List<String> getCategories() {
    return ["Men's", "Women's", 'Smart', 'Luxury', 'Casual', 'Sport'];
  }

  static List<String> getBrands() {
    return [
      'Rolex',
      'Omega',
      'Patek Philippe',
      'Audemars Piguet',
      'Apple',
      'Samsung',
      'Casio',
      'Tag Heuer',
      'Seiko',
      'Guess',
    ];
  }
}
