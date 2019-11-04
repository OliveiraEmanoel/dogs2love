import 'dart:io';

import 'package:flutter/foundation.dart';

class Util with ChangeNotifier{

static bool internetConnected;

Future<bool> hasInternet() async {
		bool connected;
		try {
			final result = await InternetAddress.lookup('google.com');
			if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
				// print('connected');
				connected = true;
			}
		} on SocketException catch (_) {
			//print('not connected');
			connected = false;
		}
    internetConnected = connected;
    notifyListeners();
		return internetConnected;	
		
	}


}