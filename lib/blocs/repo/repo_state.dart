abstract class RepoState {}

class RepoInitial extends RepoState {}

class RepoLoading extends RepoState {}

class RepoLoaded extends RepoState {
  final List repos;
  RepoLoaded(this.repos);
}

class RepoError extends RepoState {
  final String message;
  RepoError(this.message);
}
