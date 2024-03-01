import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/constants.dart';

class ItemMyRequestBusinessCard extends StatelessWidget {
  final String cardName;
  final String date;
  final String statusName;
  final String requestQuantity;
  final String statusColor;
  final VoidCallback onEditPress;
  final VoidCallback onDeletePress;

  const ItemMyRequestBusinessCard({
    Key? key,
    required this.cardName,
    required this.date,
    required this.statusName,
    required this.requestQuantity,
    required this.statusColor,
    required this.onEditPress,
    required this.onDeletePress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: borderColor.withOpacity(0.5),
              width: 1.0,
            )),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: titleColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  text: "Card name: ",
                  children: <TextSpan>[
                    TextSpan(
                      text: '$cardName',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: titleColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  text: "Date: ",
                  children: <TextSpan>[
                    TextSpan(
                      text: '$date',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: titleColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  text: "Requested Quantity: ",
                  children: <TextSpan>[
                    TextSpan(
                      text: '$requestQuantity',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                      child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Color(int.parse(statusColor.replaceAll('#', '0xFF'))),
                      ),
                      SizedBox(
                        width: 5,
                      ),

                      Text(
                        '$statusName',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Color(int.parse(statusColor.replaceAll('#', '0xFF'))),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      )
                    ],
                  )),
                  Expanded(
                    flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: onDeletePress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 6.0, right: 6.0),
                            child: Icon(
                              Icons.delete_forever,
                              color: Colors.red.shade900,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: onEditPress,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5.0, bottom: 5.0, left: 6.0, right: 6.0),
                            child: Icon(
                              Icons.edit,
                              color: titleColor,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
                ],
              )
            ],
          ),
        ),
    );
  }
}
