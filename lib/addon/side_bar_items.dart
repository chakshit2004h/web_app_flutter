import 'package:flutter/material.dart';
import 'package:web_app/required_pages/gps_enable_disable.dart';

class SideBar extends StatelessWidget {
  final String selectedItem;
  final Function(String) updateSelection;
  final VoidCallback onArrowTap;

  const SideBar({
    super.key,
    required this.selectedItem,
    required this.updateSelection,
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar list
        Container(
          width: 250,
          color: Color(0xff1a1e22),
          child: ListView(
            padding: EdgeInsets.all(8),
            children: [
              SidebarItem(title: 'Search', isSelected: selectedItem == 'Search', onTap: () => updateSelection('Search')),
              SidebarItem(title: 'Traceroute', isSelected: selectedItem == 'Traceroute', onTap: () => updateSelection('Traceroute')),
              SidebarItem(title: 'GPS Enable/Disable', isSelected: selectedItem == 'GPS Enable/Disable', onTap: () => updateSelection('GPS Enable/Disable')),
              SidebarItem(title: 'Voice + FTP Upload', isSelected: selectedItem == 'Voice + FTP Upload', onTap: () => updateSelection('Voice + FTP Upload')),
              SidebarItem(title: 'Tcpdump Record', isSelected: selectedItem == 'Tcpdump Record', onTap: () => updateSelection('Tcpdump Record')),
              SidebarItem(title: 'Require Cell File', isSelected: selectedItem == 'Require Cell File', onTap: () => updateSelection('Require Cell File')),
              SidebarItem(title: 'LTE EARFCN Lock', isSelected: selectedItem == 'LTE EARFCN Lock', onTap: () => updateSelection('LTE EARFCN Lock')),
              SidebarItem(title: 'OTT Video Streaming MOS', isSelected: selectedItem == 'OTT Video Streaming MOS', onTap: () => updateSelection('OTT Video Streaming MOS')),
              SidebarItem(title: 'Ask for site completion after script ended', isSelected: selectedItem == 'Ask for site completion after script ended', onTap: () => updateSelection('Ask for site completion after script ended')),
              SidebarItem(title: 'Set Variable Statement', isSelected: selectedItem == 'Set Variable Statement', onTap: () => updateSelection('Set Variable Statement')),
              SidebarItem(title: 'Modem Data Packet Logging Enable', isSelected: selectedItem == 'Modem Data Packet Logging Enable', onTap: () => updateSelection('Modem Data Packet Logging Enable')),
              SidebarItem(title: 'LINE Receive', isSelected: selectedItem == 'LINE Receive', onTap: () => updateSelection('LINE Receive')),
              SidebarItem(title: 'Dynamic GSM Cell Info', isSelected: selectedItem == 'Dynamic GSM Cell Info', onTap: () => updateSelection('Dynamic GSM Cell Info')),
              SidebarItem(title: 'Facebook (Post Video)', isSelected: selectedItem == 'Facebook (Post Video)', onTap: () => updateSelection('Facebook (Post Video)')),
              SidebarItem(title: 'Pause', isSelected: selectedItem == 'Pause', onTap: () => updateSelection('Pause')),
              SidebarItem(title: 'Instagram post video', isSelected: selectedItem == 'Instagram post video', onTap: () => updateSelection('Instagram post video')),
              SidebarItem(title: 'Dynamic WCDMA Cell Info', isSelected: selectedItem == 'Dynamic WCDMA Cell Info', onTap: () => updateSelection('Dynamic WCDMA Cell Info')),
              SidebarItem(title: 'Instagram post comment', isSelected: selectedItem == 'Instagram post comment', onTap: () => updateSelection('Instagram post comment')),
              SidebarItem(title: 'BEC Router Diagnostic Config', isSelected: selectedItem == 'BEC Router Diagnostic Config', onTap: () => updateSelection('BEC Router Diagnostic Config')),
              SidebarItem(title: 'Browser', isSelected: selectedItem == 'Browser', onTap: () => updateSelection('Browser')),
              SidebarItem(title: 'Data Enable/Disable', isSelected: selectedItem == 'Data Enable/Disable', onTap: () => updateSelection('Data Enable/Disable')),
              SidebarItem(title: 'Send Email', isSelected: selectedItem == 'Send Email', onTap: () => updateSelection('Send Email')),
              SidebarItem(title: 'Ping', isSelected: selectedItem == 'Ping', onTap: () => updateSelection('Ping')),
              SidebarItem(title: 'OTT Video Streaming', isSelected: selectedItem == 'OTT Video Streaming', onTap: () => updateSelection('OTT Video Streaming')),
              SidebarItem(title: 'Play Facebook Video', isSelected: selectedItem == 'Play Facebook Video', onTap: () => updateSelection('Play Facebook Video')),
              SidebarItem(title: 'nPerf Test', isSelected: selectedItem == 'nPerf Test', onTap: () => updateSelection('nPerf Test')),
              SidebarItem(title: 'DoH Lookup', isSelected: selectedItem == 'DoH Lookup', onTap: () => updateSelection('DoH Lookup')),
              SidebarItem(title: 'YouTube (Upload Video)', isSelected: selectedItem == 'YouTube (Upload Video)', onTap: () => updateSelection('YouTube (Upload Video)')),
              SidebarItem(title: 'Send SMS', isSelected: selectedItem == 'Send SMS', onTap: () => updateSelection('Send SMS')),
              SidebarItem(title: 'WhatsApp send message', isSelected: selectedItem == 'WhatsApp send message', onTap: () => updateSelection('WhatsApp send message')),
              SidebarItem(title: 'WiFi Scan Enable/Disable', isSelected: selectedItem == 'WiFi Scan Enable/Disable', onTap: () => updateSelection('WiFi Scan Enable/Disable')),
              SidebarItem(title: 'Send MMS', isSelected: selectedItem == 'Send MMS', onTap: () => updateSelection('Send MMS')),
              SidebarItem(title: 'Facebook (Post Status Update)', isSelected: selectedItem == 'Facebook (Post Status Update)', onTap: () => updateSelection('Facebook (Post Status Update)')),
              SidebarItem(title: 'WiFi Connect', isSelected: selectedItem == 'WiFi Connect', onTap: () => updateSelection('WiFi Connect')),
              SidebarItem(title: 'SFTP Upload', isSelected: selectedItem == 'SFTP Upload', onTap: () => updateSelection('SFTP Upload')),
              SidebarItem(title: 'FTP Upload', isSelected: selectedItem == 'FTP Upload', onTap: () => updateSelection('FTP Upload')),
              SidebarItem(title: 'Facebook (Post Photo)', isSelected: selectedItem == 'Facebook (Post Photo)', onTap: () => updateSelection('Facebook (Post Photo)')),
              SidebarItem(title: 'LINE Send Identifier Test', isSelected: selectedItem == 'LINE Send Identifier Test', onTap: () => updateSelection('LINE Send Identifier Test')),
              SidebarItem(title: 'Set Log Server', isSelected: selectedItem == 'Set Log Server', onTap: () => updateSelection('Set Log Server')),
              SidebarItem(title: 'Answer', isSelected: selectedItem == 'Answer', onTap: () => updateSelection('Answer')),
              SidebarItem(title: 'Dropbox Download', isSelected: selectedItem == 'Dropbox Download', onTap: () => updateSelection('Dropbox Download')),
              SidebarItem(title: 'Instagram post photo', isSelected: selectedItem == 'Instagram post photo', onTap: () => updateSelection('Instagram post photo')),
              SidebarItem(title: 'Set APN', isSelected: selectedItem == 'Set APN', onTap: () => updateSelection('Set APN')),
              SidebarItem(title: 'Conditional Loop', isSelected: selectedItem == 'Conditional Loop', onTap: () => updateSelection('Conditional Loop')),
              SidebarItem(title: 'Dropbox Upload', isSelected: selectedItem == 'Dropbox Upload', onTap: () => updateSelection('Dropbox Upload')),
              SidebarItem(title: 'R99 Lock Enable/Disable', isSelected: selectedItem == 'R99 Lock Enable/Disable', onTap: () => updateSelection('R99 Lock Enable/Disable')),
              SidebarItem(title: 'Temporary Airplane Mode', isSelected: selectedItem == 'Temporary Airplane Mode', onTap: () => updateSelection('Temporary Airplane Mode')),
              SidebarItem(title: 'Wait for PCI', isSelected: selectedItem == 'Wait for PCI', onTap: () => updateSelection('Wait for PCI')),
            ],
          ),
        ),
        // Circular background for arrow
        Container(
          width: 50,
          color: Color(0xff1a1e22),
          child: Center(
            child: GestureDetector(
              onTap: onArrowTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8),
                child: IconButton(
                  onPressed: onArrowTap,
                  icon: Icon(Icons.arrow_forward_ios,
                    color: Colors.teal,
                    size: 16,)
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class SidebarItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  SidebarItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.teal : Colors.black54,
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }
}
