import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
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
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isSearchActive = false;
  TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  final List<String> sidebarItems = [
    'Search',
    'Traceroute',
    'GPS Enable/Disable',
    'Voice + FTP Upload',
    'Tcpdump Record',
    'Require Cell File',
    'LTE EARFCN Lock',
    'OTT Video Streaming MOS',
    'Ask for site completion after script ended',
    'Set Variable Statement',
    'Modem Data Packet Logging Enable',
    'LINE Receive',
    'Dynamic GSM Cell Info',
    'Facebook (Post Video)',
    'Pause',
    'Instagram post video',
    'Dynamic WCDMA Cell Info',
    'Instagram post comment',
    'BEC Router Diagnostic Config',
    'Browser',
    'Data Enable/Disable',
    'Send Email',
    'Ping',
    'OTT Video Streaming',
    'Play Facebook Video',
    'nPerf Test',
    'DoH Lookup',
    'YouTube (Upload Video)',
    'Send SMS',
    'WhatsApp send message',
    'WiFi Scan Enable/Disable',
    'Send MMS',
    'Facebook (Post Status Update)',
    'WiFi Connect',
    'SFTP Upload',
    'FTP Upload',
    'Facebook (Post Photo)',
    'LINE Send Identifier Test',
    'Set Log Server',
    'Answer',
    'Dropbox Download',
    'Instagram post photo',
    'Set APN',
    'Conditional Loop',
    'Dropbox Upload',
    'R99 Lock Enable/Disable',
    'Temporary Airplane Mode',
    'Wait for PCI',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> filteredItems = sidebarItems
        .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Row(
      children: [
        Container(
          width: 250,
          color: const Color(0xff1a1e22),
          child: Column(
            children: [
              if (isSearchActive)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Color(0xff03120e),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    onChanged: (val) {
                      setState(() {
                        searchQuery = val;
                      });
                    },
                  )

                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    String item = filteredItems[index];
                    return SidebarItem(
                      title: item,
                      isSelected: widget.selectedItem == item,
                      onTap: () {
                        if (item == 'Search') {
                          setState(() {
                            isSearchActive = !isSearchActive;
                            if (!isSearchActive) {
                              _searchController.clear();
                              searchQuery = '';
                            }
                          });
                        } else {
                          setState(() {
                            isSearchActive = false;
                            searchQuery = '';
                            _searchController.clear();
                          });
                        }
                        widget.updateSelection(item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Arrow button
        Container(
          width: 50,
          color: const Color(0xff1a1e22),
          child: Center(
            child: GestureDetector(
              onTap: widget.onArrowTap,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: IconButton(
                    onPressed: widget.onArrowTap,
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.teal, size: 16),
                  ),
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

  const SidebarItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Colors.teal : Colors.black54,
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: onTap,
      ),
    );
  }
}
