abstract class AuthEvent {}

class UsernameSubmitted extends AuthEvent {
  final String username;
  UsernameSubmitted(this.username);
}
