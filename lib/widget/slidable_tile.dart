import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ConfirmDismissCallback;
import 'package:flutter_slidable/flutter_slidable.dart';

import '../app/l10n/generated/l10n.dart';
import '../app/theme/app_theme.dart';
import '../contacts/unicode.dart';
import '../extensions/extensions.dart';
import '../model/models.dart';
import '../screen/drawer/home_drawer.dart';
import '../utils/dialog_utils.dart';
import '../utils/html_parse_utils.dart';
import 'article.dart';
import 'dismissible_slidable_action.dart';
import 'gap.dart';

class SlidableTile extends StatelessWidget {
  const SlidableTile.collectedArticle({
    required CollectedArticleModel this.collectedArticle,
    required this.onDismissed,
    required this.confirmCallback,
    required this.onTap,
    required VoidCallback this.onEditTap,
    super.key,
  })  : collectedWebsite = null,
        article = null,
        isCollectedArticle = true,
        isCollectedWebsite = false,
        isShareArticle = false;

  const SlidableTile.collectedWebsite({
    required CollectedWebsiteModel this.collectedWebsite,
    required this.onDismissed,
    required this.confirmCallback,
    required this.onTap,
    required VoidCallback this.onEditTap,
    super.key,
  })  : collectedArticle = null,
        article = null,
        isCollectedArticle = false,
        isCollectedWebsite = true,
        isShareArticle = false;

  const SlidableTile.shareArticle({
    required ArticleModel this.article,
    required this.onDismissed,
    required this.confirmCallback,
    super.key,
  })  : collectedArticle = null,
        collectedWebsite = null,
        onTap = null,
        onEditTap = null,
        isCollectedArticle = false,
        isCollectedWebsite = false,
        isShareArticle = true;

  final CollectedArticleModel? collectedArticle;
  final CollectedWebsiteModel? collectedWebsite;
  final ArticleModel? article;
  final VoidCallback onDismissed;
  final ConfirmDismissCallback confirmCallback;
  final VoidCallback? onTap;
  final VoidCallback? onEditTap;
  final bool isCollectedArticle;
  final bool isCollectedWebsite;
  final bool isShareArticle;

  @override
  Widget build(BuildContext context) {
    late String groupTag;
    late String removeTips;
    late Widget child;

    if (isShareArticle) {
      groupTag = 'share_article';

      removeTips = S.of(context).removeShareTips;

      child = ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: ArticleTile(
          article: article!,
          authorTextOrShareUserTextCanOnTap: false,
        ),
      );
    } else {
      const TextSpan textSpace = TextSpan(
        text: '${Unicode.halfWidthSpace}•${Unicode.halfWidthSpace}',
        style: TextStyle(
          wordSpacing: kStyleUint / 2,
        ),
      );

      groupTag = isCollectedArticle
          ? CollectionType.article.name
          : CollectionType.website.name;

      removeTips = isCollectedArticle
          ? S.of(context).removeArticleTips
          : S.of(context).removeWebsiteTips;

      child = isCollectedArticle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: context.theme.textTheme.bodyMedium,
                    children: <TextSpan>[
                      if (collectedArticle!.author.strictValue != null)
                        TextSpan(text: collectedArticle!.author.strictValue),
                      TextSpan(text: collectedArticle!.niceDate),
                      if (collectedArticle!.chapterName.strictValue != null)
                        TextSpan(
                          text: collectedArticle!.chapterName.strictValue,
                        ),
                    ].fold<List<TextSpan>>(
                      <TextSpan>[],
                      (List<TextSpan> children, TextSpan child) =>
                          <TextSpan>[...children, child, textSpace],
                    )..removeLast(),
                  ),
                ),
                Gap.v(value: AppTheme.bodyPadding.top),
                Text(
                  HTMLParseUtils.unescapeHTML(collectedArticle!.title) ??
                      S.of(context).unknown,
                  style: context.theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          : Text(
              HTMLParseUtils.unescapeHTML(collectedWebsite!.name) ??
                  S.of(context).unknown,
              style: context.theme.textTheme.titleSmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            );

      child = ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          minHeight: 76.0,
        ),
        child: Material(
          child: Ink(
            decoration: BoxDecoration(
              border: Border(bottom: Divider.createBorderSide(context)),
            ),
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: AppTheme.bodyPadding,
                child: child,
              ),
            ),
          ),
        ),
      );
    }

    return Slidable(
      key: key,
      groupTag: groupTag,
      dragStartBehavior: DragStartBehavior.start,
      endActionPane: ActionPane(
        extentRatio: isShareArticle ? 0.45 : 0.25,
        motion: const StretchMotion(),
        dismissible: DismissiblePane(
          closeOnCancel: true,
          dismissThreshold: 0.65,
          dismissalDuration: const Duration(milliseconds: 500),
          onDismissed: onDismissed,
          confirmDismiss: () async {
            final bool? result = await DialogUtils.confirm<bool>(
              isDanger: true,
              builder: (BuildContext context) => Text(removeTips),
              confirmCallback: confirmCallback,
            );

            return result ?? false;
          },
        ),
        children: <Widget>[
          DismissibleSlidableAction(
            slidableExtentRatio: 0.25,
            dismissiblePaneThreshold: 0.65,
            label: onEditTap != null ? S.of(context).edit : '',
            color:
                onEditTap == null ? context.theme.colorScheme.tertiary : null,
            onTap: onEditTap ?? () {},
          ),
        ],
      ),
      child: child,
    );
  }
}
