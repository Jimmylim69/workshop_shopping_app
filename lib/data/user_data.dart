import '../models/user.dart';

// We create a single 'user' variable here.
// In your pages, you are importing this file and accessing 'user.name', etc.

final User user = User(
  name: "Jimmy",
  email: "jimmy@gmail.com",
  // A placeholder image that actually works
  photoUrl: "assets/profile.jpg",
  address: "123 Taman ABC Kemaman Terengganu",
);