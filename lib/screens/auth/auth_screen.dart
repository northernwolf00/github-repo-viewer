import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_repo/blocs/auth/auth_bloc.dart';
import 'package:github_repo/blocs/auth/auth_event.dart';
import 'package:github_repo/blocs/auth/auth_state.dart';

import '../repo/repo_screen.dart';

class AuthScreen extends StatelessWidget {
  final _controller = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('GitHub Username'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => RepoScreen(username: state.username),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png',
                  height: 80,
                  width: 80,
                ),
                const SizedBox(height: 30),

                Text(
                  'Enter your GitHub username',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'GitHub username',
                    labelStyle: TextStyle(color: Colors.deepPurple.shade300),
                    hintText: 'e.g. northernwolf00',
                    filled: true,
                    fillColor: Colors.deepPurple.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.deepPurple,
                    ),
                  ),
                  style: const TextStyle(fontSize: 18),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    context.read<AuthBloc>().add(
                      UsernameSubmitted(_controller.text),
                    );
                  },
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        context.read<AuthBloc>().add(
                          UsernameSubmitted(_controller.text.trim()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a username'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      shadowColor: Colors.deepPurpleAccent.withOpacity(0.6),
                    ),
                    child: const Text(
                      'Load Repositories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
