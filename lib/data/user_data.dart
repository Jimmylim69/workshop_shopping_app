import '../models/user.dart';

// We create a single 'user' variable here.
// In your pages, you are importing this file and accessing 'user.name', etc.

final User user = User(
  name: "Jimmy",
  email: "jimmy@gmail.com",
  // A placeholder image that actually works
  photoUrl: "https://i.pinimg.com/736x/91/92/20/91922097072461019672027202027961.jpg",
  address: "123 Taman ABC Kemaman Terengganu",
);