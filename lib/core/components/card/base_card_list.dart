import 'package:falletter_mobile_admin/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class BaseCardList extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? badge;
  final Widget? meta;
  final Widget? body;
  final Widget? footer;
  final Widget? trailing;

  final List<PopupMenuEntry>? menuItems;
  final void Function(dynamic value)? onMenuSelected;

  final Color? backgroundColor;
  final double radius;

  const BaseCardList({
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.onTap,
    this.leading,
    this.title,
    this.subtitle,
    this.badge,
    this.meta,
    this.body,
    this.footer,
    this.trailing,
    this.menuItems,
    this.onMenuSelected,
    this.backgroundColor,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor ?? FalletterColor.middleWhite,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 12)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderRow(
                        title: title,
                        subtitle: subtitle,
                        badge: badge,
                        meta: meta,
                      ),
                      if (body != null) ...[const SizedBox(height: 10), body!],
                      if (footer != null) ...[
                        const SizedBox(height: 10),
                        footer!,
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (trailing != null)
                  trailing!
                else if (menuItems != null && menuItems!.isNotEmpty)
                  _MoreMenu(items: menuItems!, onSelected: onMenuSelected)
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final Widget? badge;
  final Widget? meta;

  const _HeaderRow({this.title, this.subtitle, this.badge, this.meta});

  @override
  Widget build(BuildContext context) {
    final hasLine1 = title != null || badge != null || meta != null;
    final hasLine2 = subtitle != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasLine1)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null) Expanded(child: title!),
              if (badge != null) ...[const SizedBox(width: 8), badge!],
              if (meta != null) ...[const SizedBox(width: 8), meta!],
            ],
          ),
        if (hasLine2) ...[if (hasLine1) const SizedBox(height: 6), subtitle!],
      ],
    );
  }
}

class _MoreMenu extends StatelessWidget {
  final List<PopupMenuEntry> items;
  final void Function(dynamic value)? onSelected;

  const _MoreMenu({required this.items, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => items,
      onSelected: onSelected,
      child: const Padding(
        padding: EdgeInsets.only(top: 2),
        child: Icon(Symbols.more_vert),
      ),
    );
  }
}
