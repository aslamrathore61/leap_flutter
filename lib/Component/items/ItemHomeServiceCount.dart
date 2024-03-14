import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/constants.dart';

class ItemHomeServiceCount extends StatelessWidget {
  final String title;
  final String unPaidTitle;
  final String unPaidMaxLimit;
  final int count;
  final String colorCode;
  final Widget icon;
  final VoidCallback onAddPress;
  final VoidCallback onViewPress;

  const ItemHomeServiceCount({
    Key? key,
    required this.title,
    required this.unPaidTitle,
    required this.unPaidMaxLimit,
    required this.count,
    required this.colorCode,
    required this.icon,
    required this.onAddPress,
    required this.onViewPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: onViewPress,
        child: Card(
          elevation: 0.2,
          color: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color:
                            Color(int.parse(colorCode.replaceAll('#', '0xFF'))),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200.0),
                            topLeft: Radius.circular(200.0))),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: titleColor.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                          ),
                          SizedBox(height: 4,),
                          Text.rich(
                            TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: titleColor.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                              text: '$unPaidMaxLimit',
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' $unPaidTitle',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: titleColor.withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$count Completed',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: titleColor.withOpacity(0.6),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  flex: 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(int.parse(colorCode.replaceAll('#', '0xFF'))).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 6.0, right: 6.0),
                          child: icon,
                        ),
                      ),
                      InkWell(
                        onTap: onAddPress,
                        child: Row(
                            children: [
                              Icon(Icons.add, color: primaryColor,),
                              Text('Add', style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),)

                            ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
