
import 'package:flutter/material.dart';
import '../models/student_model.dart';

class CommonAppHeader extends StatelessWidget {
  final StudentModel? student;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;

  const CommonAppHeader({
    super.key,
    required this.student,
    required this.isLoading,
    this.errorMessage,
    this.onMenuPressed,
    this.onNotificationPressed,
  });

  static const Color navy = Color(0xFF173B5E);
  static const Color darkNavy = Color(0xFF0F2942);
  static const Color red = Color(0xFFD9534F);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        25,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            navy,
            darkNavy,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onMenuPressed,
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                  tooltip: 'Menu',
                ),
              ),

              const SizedBox(width: 12),

              _buildProfileImage(),

              const SizedBox(width: 14),

              Expanded(
                child: isLoading
                    ? _buildLoadingHeader()
                    : Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good morning 👋',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      student?.name ?? 'Student',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      student == null
                          ? 'Student profile'
                          : '${student!.className ?? ''}'
                          '${student!.sectionName != null ? ' - ${student!.sectionName}' : ''}'
                          '${student!.studentId.isNotEmpty ? '  •  ${student!.studentId}' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: onNotificationPressed,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          if (errorMessage != null) ...[
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: red.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              child: Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    final imageUrl = student?.profileImageUrl;

    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl.isNotEmpty
            ? Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _defaultProfileImage();
          },
        )
            : _defaultProfileImage(),
      ),
    );
  }

  Widget _defaultProfileImage() {
    return Container(
      color: Colors.white,
      child: const Icon(
        Icons.person_rounded,
        color: navy,
        size: 32,
      ),
    );
  }

  Widget _buildLoadingHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 110,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(6),
          ),
        ),

        const SizedBox(height: 7),

        Container(
          width: 145,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(6),
          ),
        ),

        const SizedBox(height: 7),

        Container(
          width: 125,
          height: 11,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}
