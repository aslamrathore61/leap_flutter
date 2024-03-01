// home simmer
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerContainer(double height, double width, double borderRadius) {
  return Container(
    height: height,
    width: width,
    child: Shimmer.fromColors(
      baseColor: Colors.grey[200]!,
      highlightColor: Colors.grey[50]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}

Widget ShimmerHomeLoading() => SingleChildScrollView(
  child: Container(
        margin: EdgeInsets.only(top: 18, left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildShimmerContainer(5, 200, 4.0),
            SizedBox(height: 15),
            buildShimmerContainer(150, double.infinity, 10.0),
            SizedBox(height: 15),
            buildShimmerContainer(150, double.infinity, 10.0),
            SizedBox(height: 20),
            buildShimmerContainer(5, 200, 4.0),
            SizedBox(height: 15),
            buildShimmerContainer(150, double.infinity, 10.0),
            SizedBox(height: 15),
            buildShimmerContainer(150, double.infinity, 10.0),
          ],
        ),
      ),
);

Widget _buildShimmerContainer() {
  return Expanded(
    child: Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    ),
  );
}

Widget buildShimmerMyRequestListing() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Container(
          width: 300,
          height: 8,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        _buildShimmerContainer(),
        SizedBox(height: 15),
        _buildShimmerContainer(),
        SizedBox(height: 15),
        _buildShimmerContainer(),
        SizedBox(height: 15),
        _buildShimmerContainer(),
        SizedBox(height: 15),
        _buildShimmerContainer(),
        SizedBox(height: 15),
      ],
    ),
  );
}
