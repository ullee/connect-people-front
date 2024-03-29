import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'write_board_form.dart';
import 'gallery_item.dart';

class GalleryPhotoViewWrapper extends StatefulWidget {
  GalleryPhotoViewWrapper({
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
    this.initialIndex,
    @required this.galleryItems,
    this.photoStatus,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  final PhotoStatus photoStatus;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<GalleryItem> galleryItems;
  final Axis scrollDirection;

  @override
  State<StatefulWidget> createState() {
    return _GalleryPhotoViewWrapperState();
  }
}

class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              builder: _buildPhoto,
              scrollPhysics: const BouncingScrollPhysics(),
              itemCount: widget.galleryItems.length,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: widget.scrollDirection,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Image ${currentIndex + 1}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            ),
            SafeArea(
              child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 16),
                child: FlatButton(
                  shape: CircleBorder(),
                  onPressed: () {},
                  child: BackButton(),
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildPhoto(BuildContext context, int index) {
    final GalleryItem item = widget.galleryItems[index];
    return item.isSvg
        ? PhotoViewGalleryPageOptions.customChild(
            child: Container(
              width: 300,
              height: 300,
              child: widget.photoStatus == PhotoStatus.LOADED
                  ? Image.network(
                      item.resource,
                      height: 200.0,
                    )
                  : Image.asset(
                      item.resource,
                      height: 200.0,
                    ),
            ),
            childSize: const Size(300, 300),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 1.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          )
        : PhotoViewGalleryPageOptions(
            imageProvider: widget.photoStatus == null ||
                    widget.photoStatus == PhotoStatus.LOADED
                ? NetworkImage(item.resource)
                : FileImage(File(item.resource)),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
            maxScale: PhotoViewComputedScale.covered * 1.1,
            heroAttributes: PhotoViewHeroAttributes(tag: item.id),
          );
  }
}
