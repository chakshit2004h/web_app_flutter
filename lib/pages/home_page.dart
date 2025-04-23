import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_app/required_pages/answer.dart';
import 'package:web_app/required_pages/ask_for_site_completion.dart';
import 'package:web_app/required_pages/browser.dart';
import 'package:web_app/required_pages/conditional_loop.dart';
import 'package:web_app/required_pages/data_enable_disable.dart';
import 'package:web_app/required_pages/doh_loopup.dart';
import 'package:web_app/required_pages/dropbox_download.dart';
import 'package:web_app/required_pages/dropbox_upload.dart';
import 'package:web_app/required_pages/dynamic_gsm_cell_info.dart';
import 'package:web_app/required_pages/dynamic_wcdma_cell_info.dart';
import 'package:web_app/required_pages/facebook_post_photo.dart';
import 'package:web_app/required_pages/facebook_post_update.dart';
import 'package:web_app/required_pages/facebook_post_video.dart';
import 'package:web_app/required_pages/ftp_upload.dart';
import 'package:web_app/required_pages/gps_enable_disable.dart';
import 'package:web_app/required_pages/instagram_post_comment.dart';
import 'package:web_app/required_pages/instagram_post_video.dart';
import 'package:web_app/required_pages/line_recieve.dart';
import 'package:web_app/required_pages/line_send.dart';
import 'package:web_app/required_pages/log_server.dart';
import 'package:web_app/required_pages/lte_earfcn_lock.dart';
import 'package:web_app/required_pages/modem_data_packet.dart';
import 'package:web_app/required_pages/nPerf.dart';
import 'package:web_app/required_pages/ott_video_streaming_mos.dart';
import 'package:web_app/required_pages/pause.dart';
import 'package:web_app/required_pages/ping.dart';
import 'package:web_app/required_pages/play_facebook_video.dart';
import 'package:web_app/required_pages/r99_lock.dart';
import 'package:web_app/required_pages/require_cell_file.dart';
import 'package:web_app/required_pages/send_email.dart';
import 'package:web_app/required_pages/send_mms.dart';
import 'package:web_app/required_pages/send_sms.dart';
import 'package:web_app/required_pages/set_apn.dart';
import 'package:web_app/required_pages/set_varible_statement.dart';
import 'package:web_app/required_pages/smtp_upload.dart';
import 'package:web_app/required_pages/tcpdump_record.dart';
import 'package:web_app/required_pages/temprory_aeroplane_mode.dart';
import 'package:web_app/required_pages/trasroute.dart';
import 'package:web_app/required_pages/voice_ftp_upload.dart';
import 'package:web_app/required_pages/wait_pci.dart';
import 'package:web_app/required_pages/whatsapp_send_message.dart';
import 'package:web_app/required_pages/wifi_connect.dart';
import 'package:web_app/required_pages/wifi_scan.dart';

import '../addon/provider.dart';
import '../required_pages/bec_router_diagonstic_config.dart';
import '../addon/side_bar_items.dart';
import '../required_pages/youtube_upload_videos.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedItem = '';
  List<Widget> script = [];
  int? selectedCardIndex;
  void moveCardUp() {
    final cardProvider = Provider.of<SaveCardState>(context, listen: false);
    if (selectedCardIndex! > 0) {
      final temp = cardProvider.saveCard[selectedCardIndex!];
      cardProvider.saveCard[selectedCardIndex!] = cardProvider.saveCard[selectedCardIndex! - 1];
      cardProvider.saveCard[selectedCardIndex! - 1] = temp;
      setState(() {
        selectedCardIndex = selectedCardIndex! - 1;
      });
    }
  }

  void moveCardDown() {
    final cardProvider = Provider.of<SaveCardState>(context, listen: false);
    if (selectedCardIndex! < cardProvider.saveCard.length - 1) {
      final temp = cardProvider.saveCard[selectedCardIndex!];
      cardProvider.saveCard[selectedCardIndex!] = cardProvider.saveCard[selectedCardIndex! + 1];
      cardProvider.saveCard[selectedCardIndex! + 1] = temp;
      setState(() {
        selectedCardIndex = selectedCardIndex! + 1;
      });
    }
  }

  void deleteCard() {
    final cardProvider = Provider.of<SaveCardState>(context, listen: false);
    cardProvider.saveCard.removeAt(selectedCardIndex!);
    setState(() {
      selectedCardIndex = null;
    });
  }
  void editCard(BuildContext context) {
    print("Edit card clicked");
    final cardProvider = Provider.of<SaveCardState>(context, listen: false);

    // Check if the selected card exists
    if (selectedCardIndex != null) {
      final currentCard = cardProvider.saveCard[selectedCardIndex!] as ScriptCard;
      final controller = TextEditingController(text: currentCard.text);

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Edit Script', style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter new script',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final newText = controller.text;
                  if (newText.isNotEmpty) {
                    // Update the card's text
                    cardProvider.saveCard[selectedCardIndex!] =
                        ScriptCard(text: newText);
                    // Close the dialog
                    Navigator.pop(context);
                    setState(() {});  // Refresh the UI to reflect the changes
                  } else {
                    // Optionally, show an error if text is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Text cannot be empty")),
                    );
                  }
                },
                child: Text('Save', style: TextStyle(color: Color(0xff04bcb0))),
              ),
            ],
          );
        },
      );
    }
  }

  void saveCard(BuildContext context) {
    TextEditingController fileNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff22282e),
          title: Text('Enter file name',style: TextStyle(color: Colors.white),),
          content: TextField(
            controller: fileNameController,
            decoration: InputDecoration(hintText: "File name",hintStyle: TextStyle(color: Colors.white),),
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text('Cancel',style: TextStyle(color: Colors.white),),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Save',style: TextStyle(color: Colors.black),),
              onPressed: () {
                String fileName = fileNameController.text.trim();
                Navigator.of(context).pop(); // Close the dialog
                // Placeholder: Save logic goes here using fileName
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(child: Text('Script "$fileName" saved!', style: TextStyle(color: Colors.white))),
                    backgroundColor: Colors.black45,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Add this function inside _HomePageState
  Widget? getSelectedWidget() {
    switch (selectedItem) {
      case 'Traceroute': return Trasroute();
      case 'GPS Enable/Disable': return GpsEnableDisable();
      case 'Voice + FTP Upload': return VoiceFtpUpload();
      case 'Dropbox Download': return DropboxDownloadPage();
      case 'Tcpdump Record': return TcpDumpRecordPage();
      case 'Require Cell File': return RequireCellFilePage();
      case 'LTE EARFCN Lock': return LTEEARFCNLockPage();
      case 'OTT Video Streaming MOS': return OttVideoStreamingMos();
      case 'Ask for site completion after script ended': return CompletionFile();
      case 'Set Variable Statement': return SetVariablePage();
      case 'Modem Data Packet Logging Enable': return ModemDataPacketConfigPage();
      case 'LINE Receive': return LineRecieve();
      case 'Dynamic GSM Cell Info': return GSMCellInfoPage();
      case 'Facebook (Post Video)': return FacebookPostVideo();
      case 'Pause': return PausePage();
      case 'Instagram post video': return InstagramPostVideoPage();
      case 'Dynamic WCDMA Cell Info': return GSMCellInfoPage();
      case 'Instagram post comment': return InstagramPostCommentPage();
      case 'BEC Router Diagnostic Config': return RouterConfigPage();
      case 'Browser': return BrowserPage();
      case 'Data Enable/Disable': return DataEnableDisable();
      case 'Send Email': return SendEmailPage();
      case 'Ping': return PingStatementPage();
      case 'OTT Video Streaming': return OttVideoStreamingMos();
      case 'Play Facebook Video': return PlayFacebookVideoPage();
      case 'nPerf Test': return NPerfTestPage();
      case 'DoH Lookup': return DohLookupPage();
      case 'YouTube (Upload Video)': return UploadVideoPage();
      case 'Send SMS': return SendSmsPage();
      case 'WhatsApp send message': return WhatsAppMessageSettingsPage();
      case 'WiFi Scan Enable/Disable': return WifiScanPage();
      case 'Send MMS': return SendMmsPage();
      case 'Facebook (Post Status Update)': return FacebookPostPage();
      case 'WiFi Connect': return WifiConnectPage();
      case 'SFTP Upload': return SftpUploadPage();
      case 'FTP Upload': return FTPUploadPage();
      case 'Facebook (Post Photo)': return FacebookPostPhotoPage();
      case 'LINE Send Identifier Test': return LineSendPage();
      case 'Set Log Server': return SetLogStatementPage();
      case 'Answer': return AnswerPage();
      case 'Instagram post photo': return FacebookPostPhotoPage();
      case 'Set APN': return SetApnPage();
      case 'Conditional Loop': return ConditionalLoopPage();
      case 'Dropbox Upload': return FileUploadPage();
      case 'R99 Lock Enable/Disable': return R99LockPage();
      case 'Temporary Airplane Mode': return TemporaryAeroplaneModePage();
      case 'Wait for PCI': return WaitForPciPage();
      default: return null;
    }
  }

  void onArrow() {
    if (selectedItem.isEmpty) return;

    final widget = getSelectedWidget();
    if (widget == null) return;

    final cardProvider = Provider.of<SaveCardState>(context, listen: false);
    cardProvider.saveCard.add(
      ScriptCard(text: selectedItem), // Or you might want to create a more detailed card
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $selectedItem to script')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            color: Color(0xff22282e),
            child: Text(
              'Sigma-AQ',
              style: TextStyle(
                color: Color(0xff04bcb0),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                SideBar(
                  selectedItem: selectedItem,
                  updateSelection: updateSelection,
                  onArrowTap: onArrow,
                ),
                Expanded(
                  child: Container(
                    color: Color(0xff03120e),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Script',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Spacer(),
                            if (selectedCardIndex != null) ...[
                              IconCard(
                                ic: Icon(Icons.arrow_drop_down_rounded, color: Color(0xff04bcb0)),
                                onTap: moveCardDown,
                              ),
                              IconCard(
                                ic: Icon(Icons.arrow_drop_up_rounded, color: Color(0xff04bcb0)),
                                onTap: moveCardUp,
                              ),
                              IconCard(
                                ic: Icon(Icons.edit, color: Color(0xff04bcb0)),
                                onTap: () => editCard(context),
                              ),
                              IconCard(
                                ic: Icon(Icons.save, color: Color(0xff04bcb0)),
                                onTap: () => saveCard(context),
                              ),
                              IconCard(
                                ic: Icon(Icons.delete, color: Color(0xff04bcb0)),
                                onTap: () => deleteCard(),
                              ),
                            ]
                          ],
                        ),


                        SizedBox(height: 10),
                        Expanded(
                          child: Consumer<SaveCardState>(
                            builder: (context, cardProvider, child) {
                              return ListView.builder(
                                itemCount: cardProvider.saveCard.length,
                                itemBuilder: (context, index) {
                                  final card = cardProvider.saveCard[index];
                                  return GestureDetector(
                                    onLongPress: () {
                                      setState(() {
                                        selectedCardIndex = index;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: selectedCardIndex == index
                                            ? Border.all(color: Colors.tealAccent, width: 2)
                                            : null,
                                      ),
                                      child: card,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (selectedItem == 'Traceroute') Trasroute(),
                if (selectedItem == 'GPS Enable/Disable') GpsEnableDisable(),
                if (selectedItem == 'Voice + FTP Upload') VoiceFtpUpload(),
                if (selectedItem == 'Dropbox Download') DropboxDownloadPage(),
                if (selectedItem == 'Tcpdump Record') TcpDumpRecordPage(),
                if (selectedItem == 'Require Cell File') RequireCellFilePage(),
                if (selectedItem == 'LTE EARFCN Lock') LTEEARFCNLockPage(),
                if (selectedItem == 'OTT Video Streaming MOS') OttVideoStreamingMos(),
                if (selectedItem == 'Ask for site completion after script ended') CompletionFile(),
                if (selectedItem == 'Set Variable Statement') SetVariablePage(),
                if (selectedItem == 'Modem Data Packet Logging Enable') ModemDataPacketConfigPage(),
                if (selectedItem == 'LINE Receive') LineRecieve(),
                if (selectedItem == 'Dynamic GSM Cell Info') GSMCellInfoPage(),
                if (selectedItem == 'Facebook (Post Video)') FacebookPostVideo(),
                if (selectedItem == 'Pause') PausePage(),
                if (selectedItem == 'Instagram post video') InstagramPostVideoPage(),
                if (selectedItem == 'Dynamic WCDMA Cell Info') GSMCellInfoPage(),
                if (selectedItem == 'Instagram post comment') InstagramPostCommentPage(),
                if (selectedItem == 'BEC Router Diagnostic Config') RouterConfigPage(),
                if (selectedItem == 'Browser') BrowserPage(),
                if (selectedItem == 'Data Enable/Disable') DataEnableDisable(),
                if (selectedItem == 'Send Email') SendEmailPage(),
                if (selectedItem == 'Ping') PingStatementPage(),
                if (selectedItem == 'OTT Video Streaming') OttVideoStreamingMos(),
                if (selectedItem == 'Play Facebook Video') PlayFacebookVideoPage(),
                if (selectedItem == 'nPerf Test') NPerfTestPage(),
                if (selectedItem == 'DoH Lookup') DohLookupPage(),
                if (selectedItem == 'YouTube (Upload Video)') UploadVideoPage(),
                if (selectedItem == 'Send SMS') SendSmsPage(),
                if (selectedItem == 'WhatsApp send message') WhatsAppMessageSettingsPage(),
                if (selectedItem == 'WiFi Scan Enable/Disable') WifiScanPage(),
                if (selectedItem == 'Send MMS') SendMmsPage(),
                if (selectedItem == 'Facebook (Post Status Update)') FacebookPostPage(),
                if (selectedItem == 'WiFi Connect') WifiConnectPage(),
                if (selectedItem == 'SFTP Upload') SftpUploadPage(),
                if (selectedItem == 'FTP Upload') FTPUploadPage(),
                if (selectedItem == 'Facebook (Post Photo)') FacebookPostPhotoPage(),
                if (selectedItem == 'LINE Send Identifier Test') LineSendPage(),
                if (selectedItem == 'Set Log Server') SetLogStatementPage(),
                if (selectedItem == 'Answer') AnswerPage(),
                if (selectedItem == 'Instagram post photo') FacebookPostPhotoPage(),
                if (selectedItem == 'Set APN') SetApnPage(),
                if (selectedItem == 'Conditional Loop') ConditionalLoopPage(),
                if (selectedItem == 'Dropbox Upload') FileUploadPage(),
                if (selectedItem == 'R99 Lock Enable/Disable') R99LockPage(),
                if (selectedItem == 'Temporary Airplane Mode') TemporaryAeroplaneModePage(),
                if (selectedItem == 'Wait for PCI') WaitForPciPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateSelection(String item) {
    setState(() {
      if (selectedItem == item) {
        selectedItem = '';
      } else {
        selectedItem = item;
      }
    });
  }
}

class ScriptCard extends StatelessWidget {
  final String text;

  ScriptCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xff111e21),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class IconCard extends StatelessWidget {
  final Icon ic;
  final VoidCallback? onTap;

  const IconCard({Key? key, required this.ic, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ic,
      ),
    );
  }
}
