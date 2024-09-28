import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchApp({
  String? path,
  String? url,
  String? email,
  String? username,
  String? channelId,
  bool isFile = false,
  bool isWebsite = false,
  bool isEmail = false,
  bool isTelegram = false,
  bool isInstagram = false,
  bool isTwitter = false,
  bool isGitHub = false,
  bool isYouTube = false,
}) async {
  if (isFile && path != null) {
    // Launch file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$path';
    final file = File(filePath);

    if (await file.exists()) {
      final Uri fileUri = Uri.file(filePath);
      if (await canLaunchUrl(fileUri)) {
        await launchUrl(fileUri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not open file: $filePath');
      }
    } else {
      throw Exception('File does not exist: $filePath');
    }
  } else if (isWebsite && url != null) {
    // Launch website
    final Uri websiteUri = Uri.parse(url);
    if (await canLaunchUrl(websiteUri)) {
      await launchUrl(websiteUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $url');
    }
  } else if (isEmail && email != null) {
    // Launch email
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch email app');
    }
  } else if (isTelegram && username != null) {
    // Launch Telegram
    final Uri appUrl = Uri.parse('tg://resolve?domain=$username');
    final Uri webUrl = Uri.parse('https://t.me/$username');

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch Telegram');
    }
  } else if (isInstagram && username != null) {
    // Launch Instagram
    final Uri appUrl = Uri.parse('instagram://user?username=$username');
    final Uri webUrl = Uri.parse('https://www.instagram.com/$username');

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch Instagram');
    }
  } else if (isTwitter && username != null) {
    // Launch Twitter
    final Uri appUrl = Uri.parse('twitter://user?screen_name=$username');
    final Uri webUrl = Uri.parse('https://twitter.com/$username');

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch Twitter');
    }
  } else if (isYouTube && channelId != null) {
    // Launch YouTube Channel
    final Uri youtubeChannelUri =
        Uri.parse('https://www.youtube.com/@$channelId');
    if (await canLaunchUrl(youtubeChannelUri)) {
      await launchUrl(youtubeChannelUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $youtubeChannelUri');
    }
  } else if (isGitHub && username != null) {
    // Launch GitHub
    final Uri gitHubUri = Uri.parse('https://github.com/$username');
    if (await canLaunchUrl(gitHubUri)) {
      await launchUrl(gitHubUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch $gitHubUri');
    }
  } else {
    throw Exception('Invalid parameters provided');
  }
}
