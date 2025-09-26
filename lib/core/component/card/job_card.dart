import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:testemu/core/component/image/common_image.dart';
import 'package:testemu/core/utils/extensions/extension.dart';

class JobCard extends StatefulWidget {
  final String companyName;
  final String location;
  final String jobTitle;
  final String salaryRange;
  final String? timePosted;
  final bool isFullTime;
  final String companyLogo;
  final String? totalapply;
  final bool isApplied;
  final VoidCallback onTap;
  const JobCard({
    super.key,
    required this.companyName,
    required this.location,
    required this.jobTitle,
    required this.salaryRange,
    this.timePosted = '',
    required this.isFullTime,
    required this.companyLogo,
    this.totalapply = '',
    this.isApplied = false,
    required this.onTap,
  });

  @override
  State<JobCard> createState() => JobCardState();
}

class JobCardState extends State<JobCard> {
  bool isFavorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF083E4B), Color(0xFF074E5E), Color(0xFF0288A6)],
            stops: [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row - Company info and favorite button
            Row(
              children: [
                // Company Logo
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CommonImage(imageSrc: widget.companyLogo),
                ),
                10.width,
                // Company Name and Location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.companyName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      4.height,
                      Text(
                        widget.location,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Favorite Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isFavorited = !isFavorited;
                    });
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0x30FFFFFF), Color(0x10FFFFFF)],
                          ),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: isFavorited ? Colors.red : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            6.height,
            // Job Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.jobTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (widget.isFullTime)
                  Text(
                    'Full Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (!widget.isFullTime)
                  Text(
                    'Part Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            6.height,
            // Bottom Row - Salary, Full Time, and Time Posted
            Row(
              children: [
                // Salary
                Text(
                  widget.salaryRange,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Time Posted
                Text(
                  widget.isApplied
                      ? widget.totalapply ?? ''
                      : widget.timePosted ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
