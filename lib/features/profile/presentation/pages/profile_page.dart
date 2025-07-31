import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFFE50914),
                          backgroundImage: state.user.profileImage != null
                              ? NetworkImage(state.user.profileImage!)
                              : null,
                          child: state.user.profileImage == null
                              ? Text(
                                  state.user.name.isNotEmpty
                                      ? state.user.name[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        
                        // User Name
                        Text(
                          state.user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        // User Email
                        Text(
                          state.user.email,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  
                  // Profile Options
                  _buildProfileOption(
                    icon: Icons.favorite,
                    title: 'Favori Filmlerim',
                    subtitle: 'Favori filmlerinizi görüntüleyin',
                    onTap: () {
                      // TODO: Navigate to favorites
                    },
                  ),
                  
                  _buildProfileOption(
                    icon: Icons.history,
                    title: 'İzleme Geçmişi',
                    subtitle: 'Daha önce izlediğiniz filmler',
                    onTap: () {
                      // TODO: Navigate to watch history
                    },
                  ),
                  
                  _buildProfileOption(
                    icon: Icons.settings,
                    title: 'Ayarlar',
                    subtitle: 'Uygulama ayarlarını düzenleyin',
                    onTap: () {
                      // TODO: Navigate to settings
                    },
                  ),
                  
                  _buildProfileOption(
                    icon: Icons.help,
                    title: 'Yardım',
                    subtitle: 'Sık sorulan sorular ve destek',
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  
                  _buildProfileOption(
                    icon: Icons.info,
                    title: 'Hakkında',
                    subtitle: 'Uygulama bilgileri',
                    onTap: () {
                      // TODO: Navigate to about
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Çıkış Yap',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'Kullanıcı bilgileri yüklenemedi',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF2A2A2A),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFFE50914),
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
} 