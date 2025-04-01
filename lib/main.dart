import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'models/storage.dart';
import 'pages/home_screen.dart';
import 'pages/welcome_screen.dart';
import 'widgets/appbar.dart';
import 'utilities/api_service.dart';
import 'utilities/app_theme.dart';
import 'utilities/constants.dart' as c;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final storage = Storage();
  storage.api_ip = dotenv.env["API_IP_PORT"];

  await StateApiService.fetchStates(storage);
  await CountyApiService.fetchCounties(storage);
  await CityApiService.fetchCities(storage);
  await LocationApiService.fetchLocations(storage);

  storage.locationLatLonMarkerList.loadLocaitonValues(storage);

  runApp(
    ChangeNotifierProvider(
      create: (context) => storage,
      child: const StreamTheVote(),
    ),
  );
}

class StreamTheVote extends StatelessWidget {
  const StreamTheVote({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<Storage>(context);

    return MaterialApp(
      title: c.appName,
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: storage.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: CustomAppBar(),
          body: TabBarView(
            children: [
              WelcomeScreen(),
              HomeScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
