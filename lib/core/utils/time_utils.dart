class TimeUtils {
  static String formatLastSeen(DateTime? date) {
    if (date == null) return 'Offline';
    final now = DateTime.now();
    final localDate = date.toLocal();
    final difference = now.difference(localDate);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[localDate.month - 1]} ${localDate.day}, ${localDate.year}';
    }
  }

  static String formatMessageTime(DateTime date) {
    final localDate = date.toLocal();
    final hour = localDate.hour == 0 ? 12 : (localDate.hour > 12 ? localDate.hour - 12 : localDate.hour);
    final amPm = localDate.hour >= 12 ? 'PM' : 'AM';
    final minute = localDate.minute.toString().padLeft(2, '0');
    return '$hour:$minute $amPm';
  }
}
