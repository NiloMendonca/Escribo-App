import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HttpService {
  Future getDados(String endpoint, List res) async {
    final response = await http
        .get(Uri.parse(endpoint));

    if (response.statusCode == 200) {
      var resTemp = jsonDecode(response.body);
      for(int i=0; i<resTemp['results'].length; i++){
        res.add(resTemp['results'][i]);
      }
      if(resTemp['next'] != null)
        return getDados(resTemp['next'], res);
      else
        return res;
    } else {
      if(res.length == 0)
        throw Exception('Failed');
      else
        return res;
    }
  }
}