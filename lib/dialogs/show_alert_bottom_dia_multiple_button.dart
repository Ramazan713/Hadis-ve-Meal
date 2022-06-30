import 'package:flutter/material.dart';

void showAlertDiaWithMultipleButton(BuildContext context,{String? title, String? content,
  required List<Widget>buttons}){

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        List<Widget> getChildren() {
          List<Widget> children = [];
          if (title != null) {
            children.add(Padding(
                padding: const EdgeInsets.only(top: 13,bottom: 7),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                )));
          }
          if (content != null) {
            children.add(Padding(
                padding: const EdgeInsets.only(bottom: 19,top: 19),
                child: Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText1,
                )));
          }
          children.add(Padding(
            padding: const EdgeInsets.only(bottom: 7,top: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons,
            ),
          ));
          return children;
        }

        return SingleChildScrollView(
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getChildren(),
            ),
          ),
        );
      });
}