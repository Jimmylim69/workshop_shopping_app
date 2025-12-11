import '../models/user.dart';

// We create a single 'user' variable here.
// In your pages, you are importing this file and accessing 'user.name', etc.

final User user = User(
  name: "Ali bin Abu",
  email: "ali.abu@example.com",
  // A placeholder image that actually works
  photoUrl: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-4.0.3&auto=format&fit=crop&w=880&q=80",
  address: "No. 12, Jalan Teknologi, Kota Damansara, 47810 Petaling Jaya, Selangor",
);