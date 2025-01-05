import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/responsive.dart';
import '../widgets/sidebar/sidebar.dart';
import '../screens/tabs/home_tab.dart';
import '../screens/tabs/tasks_tab.dart';
import '../screens/tabs/health_tab.dart';
import '../widgets/navigation/app_header.dart';
import '../providers/navigation_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isSidebarVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        ref.read(selectedTabProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppHeader(
        onMenuPressed: _toggleSidebar,
        isSidebarOpen: _isSidebarVisible,
        tabController: _tabController,
        showTopNavBar: !isMobile, 
      ),
      body: Stack(
        children: [
          // Main content
          Row(
            children: [
              if (!isMobile && _isSidebarVisible)
                Sidebar(onToggle: _toggleSidebar),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    HomeTab(),
                    TasksTab(),
                    HealthTab(),
                  ],
                ),
              ),
            ],
          ),

          if (isMobile && _isSidebarVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleSidebar, 
                child: Container(
                  color: Colors.black.withOpacity(0.5), 
                ),
              ),
            ),
          if (isMobile && _isSidebarVisible)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Sidebar(
                onToggle: _toggleSidebar,
              ),
            ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _tabController.index,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                  ref.read(selectedTabProvider.notifier).state = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Health'),
              ],
            )
          : null,
    );
  }
}
