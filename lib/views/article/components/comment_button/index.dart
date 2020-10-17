import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moegirl_viewer/views/article/components/comment_button/components/animation.dart';

import 'components/ripple_animation_layer.dart';

class ArticlePageCommentButton extends StatefulWidget {
  final String text;
  final void Function(ArticlePageCommentButtonAnimationMainController) emitController;
  final Function onPressed;
  
  ArticlePageCommentButton({
    this.text,
    this.emitController,
    this.onPressed,
    Key key
  }) : super(key: key);

  @override
  _ArticlePageCommentButtonState createState() => _ArticlePageCommentButtonState();
}

class _ArticlePageCommentButtonState extends State<ArticlePageCommentButton> {
  final buttonAnimationControllerCompleter = Completer<ArticlePageCommentButtonAnimationControler>();
  final rippleLayerAnimationControllerCompleter = Completer<ArticlePageCommentButtonRippleAnimationController>();

  @override
  void initState() { 
    super.initState();
    
    Future.wait([
      buttonAnimationControllerCompleter.future,
      rippleLayerAnimationControllerCompleter.future
    ])
      .then((controllers) {
        final ArticlePageCommentButtonAnimationControler buttonController = controllers[0];
        final ArticlePageCommentButtonRippleAnimationController rippleContorller = controllers[1];

        widget.emitController(ArticlePageCommentButtonAnimationMainController(
          buttonController.show,
          buttonController.hide,
          rippleContorller.show
        ));
      });
  }

  @override
  Widget build(BuildContext context) {
    return ArticlePageCommentButtonAnimation(
      emitController: buttonAnimationControllerCompleter.complete,
      child: Stack(
        children: [
          ArticlePageCommentButtonRippleAnimationLayer(
            emitController: rippleLayerAnimationControllerCompleter.complete,
          ),
          Material(
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: widget.onPressed,
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: SizedBox.expand(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment, size: 28, color: Colors.white),
                        Text(widget.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13
                          ),
                        )
                      ]
                    ),
                  )
                ),
              ),
            )
          )
        ],
      )
    );
  }
}

class ArticlePageCommentButtonAnimationMainController {
  final Future<void> Function() show;
  final Future<void> Function() hide;
  final Future<void> Function() ripple;

  ArticlePageCommentButtonAnimationMainController(this.show, this.hide, this.ripple);  
}