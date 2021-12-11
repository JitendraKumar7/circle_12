part of '../index.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.photo,
    this.avatarSize = 48,
  }) : super(key: key);

  final String? photo;
  final double? avatarSize;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return CircleAvatar(
      radius: avatarSize,
      backgroundImage: (photo != null
          ? NetworkImage(photo)
          : AssetImage(
              'assets/default/user.jpg',
            )) as ImageProvider,
    );
  }
}
