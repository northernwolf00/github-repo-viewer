import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo/blocs/repo/repo_bloc.dart';
import 'package:github_repo/blocs/repo/repo_event.dart';
import 'package:github_repo/blocs/repo/repo_state.dart';

class RepoScreen extends StatelessWidget {
  final String username;
  const RepoScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RepoBloc()..add(LoadUserRepos(username)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('$username\'s Repositories'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          elevation: 4,
        ),
        body: BlocBuilder<RepoBloc, RepoState>(
          builder: (context, state) {
            if (state is RepoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RepoLoaded) {
              if (state.repos.isEmpty) {
                return _buildEmptyState();
              }
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<RepoBloc>().add(LoadUserRepos(username));
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.repos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final repo = state.repos[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      shadowColor: Colors.deepPurple.withOpacity(0.4),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        title: Text(
                          repo['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            repo['description'] ?? 'No description provided',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.deepPurple,
                        ),
                        
                      ),
                    );
                  },
                ),
              );
            } else if (state is RepoError) {
              return _buildErrorState(state.message);
            }
            return const Center(
              child: Text(
                'Enter username to load repositories',
                style: TextStyle(fontSize: 16),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.folder_open, size: 60, color: Colors.deepPurpleAccent),
          SizedBox(height: 12),
          Text(
            'No repositories found',
            style: TextStyle(fontSize: 18, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text(
              'Oops! Something went wrong.\n$message',
              style: const TextStyle(fontSize: 18, color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
