import 'package:petnest/models/product.dart';
import 'package:petnest/models/service_data.dart';
import 'package:petnest/models/doctor.dart';
import 'package:petnest/models/user_booking.dart';
import 'package:petnest/models/misc.dart';

final List<Product> mockProducts = [
  // --- PETS FOR PURCHASE ---
  Product(id: 1, name: 'Simba', price: 25000, category: 'Pets', image: 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=400&q=80', listingType: 'buy', breed: 'Golden Retriever', age: '2 mos', gender: 'Male', verified: true, description: 'Simba is a playful and friendly Golden Retriever puppy.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4', advancePrice: 5000, breederInfo: {'name': 'Happy Paws Kennel', 'location': 'Koramangala, Bengaluru' }),
  Product(id: 2, name: 'Luna', price: 35000, category: 'Pets', image: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=400&q=80', listingType: 'buy', breed: 'Siberian Husky', age: '3 mos', gender: 'Female', verified: true, description: 'Luna is an energetic Siberian Husky with striking blue eyes.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4', advancePrice: 7000, breederInfo: {'name': 'Arctic Wonders Huskies', 'location': 'Whitefield, Bengaluru' }),
  Product(id: 3, name: 'Leo', price: 18000, category: 'Pets', image: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=400&q=80', listingType: 'buy', breed: 'Persian Cat', age: '4 mos', gender: 'Male', verified: true, description: 'Leo is a calm and affectionate Persian kitten with a long coat.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4', advancePrice: 4000, breederInfo: {'name': 'Royal Paws Cattery', 'location': 'Indiranagar, Bengaluru' }),
  Product(id: 4, name: 'Max', price: 22000, category: 'Pets', image: 'https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?auto=format&fit=crop&w=400&q=80', listingType: 'buy', breed: 'German Shepherd', age: '2 mos', gender: 'Male', verified: true, description: 'Max is an intelligent and highly trainable German Shepherd puppy.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4', advancePrice: 5000, breederInfo: {'name': 'K-9 Guardians', 'location': 'HSR Layout, Bengaluru' }),

  // --- PETS FOR ADOPTION ---
  Product(id: 16, name: 'Buddy', price: 1500, category: 'Pets', image: 'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?auto=format&fit=crop&w=400&q=80', listingType: 'adopt', breed: 'Indie Mix', age: '1 yr', gender: 'Male', verified: true, description: 'A friendly stray looking for a home.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4' ),
  Product(id: 17, name: 'Lucy', price: 1000, category: 'Pets', image: 'https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?auto=format&fit=crop&w=400&q=80', listingType: 'adopt', breed: 'Domestic Short Hair', age: '6 mos', gender: 'Female', verified: true, description: 'Loves to cuddle and play.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4' ),
  Product(id: 18, name: 'Rocky', price: 2000, category: 'Pets', image: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&w=400&q=80', listingType: 'adopt', breed: 'Labrador Mix', age: '2 yrs', gender: 'Male', verified: true, description: 'Loves fetch and long walks.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4' ),
  Product(id: 19, name: 'Misty', price: 1000, category: 'Pets', image: 'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=400&q=80', listingType: 'adopt', breed: 'Calico Cat', age: '1.5 yrs', gender: 'Female', verified: true, description: 'Independent but sweet.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4' ),
  Product(id: 20, name: 'Charlie', price: 0, category: 'Pets', image: 'https://images.pexels.com/photos/4587994/pexels-photo-4587994.jpeg??auto=format&fit=crop&w=400&q=80', listingType: 'adopt', breed: 'Rabbit', age: '5 mos', gender: 'Male', verified: true, description: 'A quiet and gentle house rabbit.', videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4',),

  // --- FOOD & TREATS ---
 Product(id: 5, name: 'Royal Canin Adult Dry Dog Food', price: 2800, mrp: 3000, category: 'Food & Treats', image: 'https://m.media-amazon.com/images/I/71lTI-wW5OL._AC_SL1500_.jpg?auto=format&fit=crop&w=400&q=80', brand: 'Royal Canin', weight: '3kg', deliveryTime: 12, description: 'Balanced nutrition for adult dogs.', rating: 4.8, reviewCount: '5,210', unitPrice: '₹93.33/kg' ),
  Product(id: 7, name: 'Pedigree Pro Puppy Food', price: 650, mrp: 700, category: 'Food & Treats', image: 'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?auto=format&fit=crop&w=400&q=80', brand: 'Pedigree', weight: '1.2kg', deliveryTime: 12, description: 'High protein for growing pups.', rating: 4.7, reviewCount: '11,432', unitPrice: '₹54.16/100g', tags: ['Trending'] ),
 Product(id: 10, name: 'Sheba Cat Food - Tuna in Jelly', price: 55, category: 'Food & Treats', image: 'https://cdn.pixabay.com/photo/2017/03/24/08/24/cat-2170494_1280.jpg?auto=format&fit=crop&w=400&q=80', brand: 'Sheba', weight: '85g', deliveryTime: 15, description: 'Tuna in jelly for adult cats.', rating: 4.9, reviewCount: '8,991', unitPrice: '₹6.47/10g', options: 2 ),
  Product(id: 11, name: 'Himalaya Healthy Pet Food', price: 1200, mrp: 1250, category: 'Food & Treats', image: 'https://himalayawellness.in/cdn/shop/files/HPF-ADULT-1.jpg??auto=format&fit=crop&w=400&q=80', brand: 'Himalaya', weight: '3kg', deliveryTime: 18, description: 'Chicken & rice for all breeds (Dog).', rating: 4.6, reviewCount: '3,104', unitPrice: '₹40.00/100g' ),
  Product(id: 21, name: 'Drools Chicken Dog Food', price: 1500, mrp: 1650, category: 'Food & Treats', image: 'https://m.media-amazon.com/images/I/71g3TZFHPGL._AC_.jpg?auto=format&fit=crop&w=400&q=80', brand: 'Drools', weight: '10kg', deliveryTime: 20, description: 'For active adult dogs.', rating: 4.5, reviewCount: '7,890', unitPrice: '₹15.00/100g' ),
  Product(id: 22, name: 'Me-O Adult Cat Food', price: 450, category: 'Food & Treats', image: 'https://th.bing.com/th/id/OIP.jdTrM6E8OhZETlrrNiq_XAHaJh?auto=format&fit=crop&w=200', brand: 'Me-O', weight: '1.2kg', deliveryTime: 15, description: 'Delicious tuna flavor for cats.', rating: 4.8, reviewCount: '6,543', unitPrice: '₹37.50/100g' ),
  Product(id: 25, name: 'Whiskas Kitten Dry Cat Food', price: 750, mrp: 800, category: 'Food & Treats', image: 'https://th.bing.com/th/id/OIP.zqNGdRHxI53YlLIMkEl1uwHaHa', brand: 'Whiskas', weight: '1.1kg', deliveryTime: 12, description: 'Ocean fish flavor for kittens.', rating: 4.7, reviewCount: '9,876', unitPrice: '₹68.18/100g' ),
  Product(id: 26, name: 'Gnawlers Calcium Milk Bone', price: 350, category: 'Food & Treats', image: 'https://th.bing.com/th/id/OIP.gt8lYVESw2rCdIuKML62kAHaHa?auto=format&fit=crop&w=400', brand: 'Gnawlers', weight: '340g', deliveryTime: 20, description: 'Dental treats for dogs.', rating: 4.6, reviewCount: '5,432', unitPrice: '₹10.29/10g' ),

  // --- TOYS ---
  Product(id: 8, name: 'Squeaky Bone Dog Toy', price: 299, mrp: 349, category: 'Toys', image: 'https://th.bing.com/th/id/OIP.Slr4cTft0kKWH_M-8GgSVAHaHa?auto=format&fit=crop&w=400', brand: 'Bone Toy', weight: '1 pc', deliveryTime: 12, description: 'Durable rubber for heavy chewers.', rating: 4.5, reviewCount: '2,500' ),
  Product(id: 13, name: 'Catnip Feather Wand', price: 249, mrp: 299, category: 'Toys', image: 'https://th.bing.com/th/id/OIP.WtW0M0OIQ9RaPEfIrCG8RAHaHa?auto=format&fit=crop&w=400', brand: 'Cat Wand', weight: '1 pc', deliveryTime: 12, description: 'Interactive toy for playful cats.', rating: 4.8, reviewCount: '4,129' ),
  Product(id: 27, name: 'KONG Classic Dog Toy', price: 899, mrp: 950, category: 'Toys', image: 'https://th.bing.com/th/id/OIP.wTEJD59m8rL2sI0C3as-4QHaFn?auto=format&fit=crop&w=400', brand: 'KONG', weight: '1 pc', deliveryTime: 15, description: 'The gold standard of dog toys.', rating: 4.9, reviewCount: '12,345' ),

  // --- PHARMACY ---
  Product(id: 9, name: 'Flea Guard Spray for Dogs', price: 450, category: 'Pharmacy', image: 'https://images.freshop.com/00032700966058/82f9193ed51713f3e5b91e06ec5ba2fa_large.png?auto=format&fit=crop&w=400&', brand: 'Flea Spray', weight: '200ml', deliveryTime: 12, description: 'Kills fleas, ticks, and lice.', rating: 4.7, reviewCount: '6,721', unitPrice: '₹22.50/10ml' ),
  Product(id: 14, name: 'Furglow Skin Tonic', price: 350, mrp: 375, category: 'Pharmacy', image: 'https://th.bing.com/th/id/OIP.YPDE-7uL3A05wuhD-qu_QQHaHb?auto=format&fit=crop&w=400', brand: 'Furglow', weight: '200ml', deliveryTime: 30, description: 'For a healthy and shiny coat.', rating: 4.8, reviewCount: '9,011', unitPrice: '₹17.50/10ml' ),
  Product(id: 38, name: 'Intas Pomisol Ear Drops', price: 180, mrp: 200, category: 'Pharmacy', image: 'https://th.bing.com/th/id/OIP.qhdsrTbwDQBL5iHUx1iUKwHaHa?auto=format&fit=crop&w=400', brand: 'Intas', weight: '15ml', deliveryTime: 12, description: 'For ear infections in pets.', rating: 4.8, reviewCount: '8,765', unitPrice: '₹120.00/10ml' ),
];

final List<ServiceData> mockServices = [
  ServiceData(id: 1, name: 'Video Call Session', duration: '30 min', price: 1299, icon: 'VideoIcon'),
  ServiceData(id: 2, name: 'Full Grooming', duration: '90 min', price: 1499, icon: 'PawPrintIcon'),
  ServiceData(id: 3, name: 'Dog Walking', duration: '30 min', price: 199, icon: 'UserIcon'),
  ServiceData(id: 4, name: 'Pet Sitting', duration: '1 Day', price: 999, icon: 'HomeIcon'),
];

final List<Doctor> mockDoctors = [
  Doctor(id: 1, name: 'Dr. Sarah Wilson', specialty: 'General Surgeon', experience: 8, distance: 1.2, rating: 4.9, initials: 'SW', clinicPrice: 500, videoCallPrice: 800),
  Doctor(id: 2, name: 'Dr. Amit Patel', specialty: 'Dermatology', experience: 12, distance: 3.5, rating: 4.7, initials: 'AP', clinicPrice: 800, videoCallPrice: 1100),
  Doctor(id: 3, name: 'Dr. Priya Sharma', specialty: 'Nutritionist', experience: 5, distance: 2.1, rating: 4.8, initials: 'PS', clinicPrice: 600, videoCallPrice: 700),
  Doctor(id: 4, name: 'Dr. Rohan Verma', specialty: 'Orthopedics', experience: 15, distance: 5.0, rating: 4.9, initials: 'RV', clinicPrice: 1000, videoCallPrice: 1500),
  Doctor(id: 5, name: 'Dr. Anjali Singh', specialty: 'Cardiology', experience: 10, distance: 4.2, rating: 4.6, initials: 'AS', clinicPrice: 900, videoCallPrice: 1200),
  Doctor(id: 6, name: 'Dr. Vikram Rao', specialty: 'General Physician', experience: 3, distance: 1.8, rating: 4.5, initials: 'VR', clinicPrice: 350, videoCallPrice: 500),
];

final List<UserBooking> mockUserBookings = [
  UserBooking(id: 1, doctorName: 'Dr. Sarah Wilson', serviceName: 'Clinic Visit', date: 'Tomorrow', time: '11:00 AM', status: 'upcoming', doctorInitials: 'SW'),
  UserBooking(id: 2, doctorName: 'Dr. Priya Sharma', serviceName: 'Video Call', date: 'Oct 28', time: '02:00 PM', status: 'upcoming', doctorInitials: 'PS'),
  UserBooking(id: 3, doctorName: 'Dr. Amit Patel', serviceName: 'Clinic Visit', date: 'Sep 15', time: '09:00 AM', status: 'completed', doctorInitials: 'AP'),
  UserBooking(id: 4, doctorName: 'Dr. Sarah Wilson', serviceName: 'Video Call', date: 'Aug 02', time: '04:00 PM', status: 'completed', doctorInitials: 'SW'),
];

final List<Appointment> mockAppointments = [
  Appointment(id: 1, petName: 'Bruno', ownerName: 'John Doe', service: 'Vaccination', time: '10:00 AM', status: 'Confirmed'),
  Appointment(id: 2, petName: 'Milo', ownerName: 'Jane Smith', service: 'Surgery Checkup', time: '11:30 AM', status: 'Pending'),
  Appointment(id: 3, petName: 'Kitty', ownerName: 'Mike Ross', service: 'General Checkup', time: '02:00 PM', status: 'Confirmed'),
];

final List<SellerOrder> mockSellerOrders = [
  SellerOrder(id: 1, orderNumber: '#1001', customerName: 'Alice W.', items: '2x Royal Canin Adult', price: 5600, status: 'New'),
  SellerOrder(id: 2, orderNumber: '#1002', customerName: 'Bob B.', items: '1x Squeaky Bone', price: 299, status: 'Packed'),
];