import 'package:flutter/material.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallPhone = size.width < 360;
    final horizontalPadding = size.width * 0.06;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: size.height * 0.03),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                    SizedBox(width: size.width * 0.04),
                    Text(
                      "User Details",
                      style: TextStyle(
                        fontSize: isSmallPhone ? 22 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.04),

                /// Avatar + User Info with Animation
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScaleTransition(
                        scale: _scaleAnimation,
                        child: _avatar(size, isSmallPhone)),
                    SizedBox(width: size.width * 0.05),
                    Expanded(
                        child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: _userInfo(size, isSmallPhone))),
                  ],
                ),

                SizedBox(height: size.height * 0.05),

                /// Locations Header
                SizedBox(
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Locations List",
                        style: TextStyle(
                          fontSize: isSmallPhone ? 20 : 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: isSmallPhone ? 16 : 22,
                              vertical: isSmallPhone ? 8 : 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E5B2D),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Add More Locations",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: isSmallPhone ? 12 : 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                /// Locations List with Animation
                Column(
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.02),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _locationCard(size, isSmallPhone),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar(Size size, bool isSmallPhone) {
    final double avatarSize = isSmallPhone ? 120 : 170;
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF1E5B2D),
          width: 6,
        ),
      ),
      child: Icon(
        Icons.person_outline,
        size: isSmallPhone ? 70 : 95,
        color: const Color(0xFF1E5B2D),
      ),
    );
  }

  Widget _userInfo(Size size, bool isSmallPhone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User No.#",
          style: TextStyle(
            fontSize: isSmallPhone ? 24 : 30,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E5B2D),
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "Details",
          style: TextStyle(
            fontSize: isSmallPhone ? 16 : 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: size.height * 0.01),
        Text(
          "Worem ipsum dolor sit amet, consectetur adipiscing elit. "
          "Nunc vulputate libero et velit interdum, ac aliquet odio mattis.",
          style: TextStyle(
            fontSize: isSmallPhone ? 13 : 15,
            color: Colors.grey,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _locationCard(Size size, bool isSmallPhone) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallPhone ? 20 : 28,
        vertical: isSmallPhone ? 16 : 24,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1F0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Location Name",
                style: TextStyle(
                  fontSize: isSmallPhone ? 16 : 19,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E5B2D),
                ),
              ),
              SizedBox(height: size.height * 0.005),
              Text(
                "ipsum dolo / ipsum dolo",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isSmallPhone ? 12 : 14,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // حذف الموقع أو أي وظيفة أخرى
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: isSmallPhone ? 14 : 26,
                  vertical: isSmallPhone ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmallPhone ? 12 : 14,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
