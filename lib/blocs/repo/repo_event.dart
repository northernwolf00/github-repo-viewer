abstract class RepoEvent {}

class LoadUserRepos extends RepoEvent {
  final String username;
  LoadUserRepos(this.username);
}
