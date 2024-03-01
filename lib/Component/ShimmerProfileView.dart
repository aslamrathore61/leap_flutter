import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../Utils/constants.dart';

class ShimmerProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ShimmerProfileHeader(),
            SizedBox(
              height: 10,
            ),
            ShimmerDivider(),
            ShimmerSectionTitle(title: "Profile Info."),
            ShimmerInfoRow(),
            ShimmerInfoRow(),
            ShimmerInfoRow(),
            ShimmerInfoRow(),
            ShimmerInfoRow(),
            ShimmerInfoRow(),
            ShimmerDivider(),
            ShimmerSectionTitle(title: "Settings"),
            ShimmerSectionTitle(title: "Settings"),
          ],
        ),
      ),
    );
  }
}

class ShimmerProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[50]!,
              child: Container(
                width: 60, // Adjust the width and height as needed
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[50]!,
                    child: Container(
                      width: double.infinity,
                      height: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[200]!,
                    highlightColor: Colors.grey[50]!,
                    child: Container(
                      width: double.infinity,
                      height: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Icon(
              Icons.edit_note,
              size: 30,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: double.infinity,
        height: 1,
        color: Colors.grey,
      ),
    );
  }
}

class ShimmerSectionTitle extends StatelessWidget {
  final String title;

  const ShimmerSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 15, top: 30),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          child: Container(
            width: 150,
            height: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ShimmerInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Row(
        children: [
          Icon(
            Icons.call,
            size: 22,
            color: Colors.grey[300]!,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[50]!,
                  child: Container(
                    width: 160,
                    height: 15,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Shimmer.fromColors(
                  baseColor: Colors.grey[200]!,
                  highlightColor: Colors.grey[50]!,
                  child: Container(
                    width: 250,
                    height: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
