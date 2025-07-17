import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo/data/github_api.dart';
import 'repo_event.dart';
import 'repo_state.dart';


class RepoBloc extends Bloc<RepoEvent, RepoState> {
  final GitHubApi _api = GitHubApi();

  RepoBloc() : super(RepoInitial()) {
    on<LoadUserRepos>((event, emit) async {
      emit(RepoLoading());
      try {
        final repos = await _api.fetchUserRepos(event.username);
        emit(RepoLoaded(repos));
      } catch (e) {
        emit(RepoError(e.toString()));
      }
    });
  }
}
