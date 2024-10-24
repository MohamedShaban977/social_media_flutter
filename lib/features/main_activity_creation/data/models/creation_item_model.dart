class CreationItemModel {
  final String image;
  final String title;
  final void Function() onTap;

  CreationItemModel({
    required this.image,
    required this.title,
    required this.onTap,
  });
}
