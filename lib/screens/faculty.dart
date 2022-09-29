
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:mac_address/mac_address.dart';

class MyFaculty extends StatefulWidget{
  final String email;
  const MyFaculty({Key?key, required this.email}): super(key: key);

  @override
  _MyFacultyState createState() => _MyFacultyState();
}

class _MyFacultyState extends State<MyFaculty> {
dynamic session_name;
dynamic OTP;
String ap_mac = "";
dynamic dropdownValue = "";
List sub_list = [];
String f_name = "";
String l_name = "";
String fac_id = "";
DateTimeRange date = DateTimeRange(
  start: DateTime.now(),
  end: DateTime.now(),
);




dynamic id_checker() async{
  WifiInfoWrapper wifiObject = await  WifiInfoPlugin.wifiDetails;
  var mac1 = wifiObject.routerIp.toString();
  var mac2 = wifiObject.ipAddress.toString();
  var mac3 = wifiObject.networkId.toString();
  ap_mac = wifiObject.bssId.toString();
  var mac4 = wifiObject.macAddress.toString();
  var mac6 = wifiObject.signalStrength.toString();
  var mac7 = wifiObject.connectionType.toString();
  var mac8 = wifiObject.isHiddenSSid.toString();
  print(mac1+"\n"+mac2+"\n"+mac3+"\n"+mac4+"\n"+ap_mac+"\n"+mac6+"\n"+mac7+"\n"+mac8);
  final info = NetworkInfo();
  ap_mac = (await info.getWifiBSSID())!;
  print(ap_mac);
}

void get_subjects() async{
  //final url = 'http://192.168.0.171:5000/professor_subjects';
  final url = 'http://10.0.2.2:5000/professor_subjects';
  final dynamic send = await http.post(Uri.parse(url), body: json.encode({
    'email': widget.email,
  }));
  final decoded = await json.decode(send.body) as Map<String, dynamic>;
  print(decoded['subjects']);

  dropdownValue = await decoded['subjects'][0];
  sub_list = decoded['subjects'];
}

void get_details() async{
  print(widget.email);
  //final url = 'http://192.168.0.171:5000/faculty_details';
  final url = 'http://10.0.2.2:5000/faculty_details';
  final dynamic send = await http.post(Uri.parse(url), body: json.encode({
    'email': widget.email,
  }));
  final decoded = await json.decode(send.body) as Map<String, dynamic>;
  print(decoded);
  f_name = await decoded['f_name'];
  l_name = await decoded['l_name'];
  fac_id = await decoded['reg_no'];
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final start = date.start;
    final end = date.end;
    get_details();
    get_subjects();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Builder(
          builder: (context) =>
              IconButton(
                icon: Icon(Icons.menu_rounded, color: Colors.black,),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        backgroundColor: Colors.blueAccent,
        title: Image.network("https://www.ssn.edu.in/wp-content/uploads/2020/06/SSN-Institutions-1.png",
          fit: BoxFit.contain,
          height: 32,
        ),

        //centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Container(

          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30,left: 60,right: 60,),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('asset/logo.png'), fit: BoxFit.fill)),
                ),
              ),
              //DrawerHeader(child: Text(""),/*child: Center(child: Text("LOGO",style: TextStyle(fontSize: 30,),)),*/),
              ListTile(
                  leading: Icon(Icons.lock_clock_rounded, color: Colors.black,),
                  title: Text("Logout",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, 'login');
                  }
              ),
              ListTile(
                leading: Icon(Icons.star, color: Colors.black,),
                title: Text("Rate Us",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                onTap: () {},
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.55,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: Column(
                    children: [
                      Text("Designed and Developed by:"),
                      Text("𝐀.𝐀𝐧𝐚𝐧𝐝", style: TextStyle(fontSize: 20,),),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image:DecorationImage(
            image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwflYli3_AU_tvzbrmDxZPEEGOeazVYerHvg&usqp=CAU",),
            fit: BoxFit.cover,),
        ),
        child: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15,bottom: 10,left: 10,right: 10,),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.9,
                    width: MediaQuery.of(context).size.width*1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                    ),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30,),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Welcome, ",
                            maxLines: 2,
                            style: TextStyle(fontSize: 30,color: Colors.blue, fontWeight: FontWeight.bold,),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.center,
                          child: Text("Dr. "+f_name +" "+ l_name,
                            maxLines: 2,
                            style: TextStyle(fontSize: 30,color: Colors.blue, fontWeight: FontWeight.bold,),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text("Select Period:",style: TextStyle(fontSize: 20,color: Colors.blue,),),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.shade100,border: Border.all(color: Colors.blue,width: 2),),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10,),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                borderRadius: BorderRadius.circular(10),
                                value: dropdownValue,
                                elevation: 16,
                                icon: Icon(Icons.arrow_downward_sharp),
                                style: TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                    session_name = newValue;
                                    print(dropdownValue);
                                  });
                                },
                                items: sub_list.map((sub_list)/*<String> ['select subject',sub_list[0],sub_list[1],sub_list[2],sub_list[3],sub_list[4],sub_list[5],sub_list[6],sub_list[7]]
                                    .map<DropdownMenuItem<String>>((String value)*/ {
                                  return DropdownMenuItem<String>(
                                    value: sub_list,
                                    child: Text(sub_list, style: TextStyle(fontSize: 20),),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        /*Text("Enter the session name:",style: TextStyle(fontSize: 20,color: Colors.blue,),),
                        SizedBox(height: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          height: MediaQuery.of(context).size.height*0.1,
                          child: TextField(

                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: 'Session name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (text) {
                              session_name = text;
                              print(session_name);
                            },
                            onSubmitted: (String password) { print("submitted\n");
                            setState(() {
                              session_name = password;
                            });
                            },
                          ),
                        ),*/
                        Row(
                          children: [
                            Spacer(),
                            ElevatedButton(
                                onPressed: () async {
                                  await id_checker();
                                  //final url = 'http://192.168.0.171:5000/send';
                                  final url = 'http://10.0.2.2:5000/send';
                                  OTP = await http.post(Uri.parse(url),body:json.encode({'email': widget.email,'name':session_name,'ip':ap_mac}));
                                  final decoded_otp = json.decode(OTP.body) as Map<String, dynamic>;
                                  print(decoded_otp);
                                  if (decoded_otp['status'] == 'na'){
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Align(
                                            alignment: Alignment.center,
                                            child: Text("Error!",style: TextStyle(color: Colors.red),)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        elevation: 5,
                                        actionsPadding: EdgeInsets.all(10.0),
                                        actions: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Session already exists",style: TextStyle(color: Colors.black,fontSize: 20),maxLines: 3,),
                                              )),
                                        ],
                                      ),
                                    );
                                  }
                                  else if(decoded_otp['status'] == 'done') {
                                    var text_otp = decoded_otp['otp'];
                                    var text_name = decoded_otp['name'];
                                    showDialog(
                                      context: context,
                                      builder: (_) =>
                                          AlertDialog(
                                            title: Align(
                                                alignment: Alignment.center,
                                                child: Text("Share with students",
                                                  style: TextStyle(
                                                      color: Colors.blue),)),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))
                                            ),
                                            elevation: 5,
                                            actionsPadding: EdgeInsets.all(10.0),
                                            actions: [
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Text("Session Name :",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                      maxLines: 3,),
                                                  )),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Text(text_name,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20),
                                                      maxLines: 3,),
                                                  )),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Text("OTP :",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20),),
                                                  )),
                                              Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(
                                                        8.0),
                                                    child: Text(text_otp,
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 20),),
                                                  )),
                                            ],
                                          ),
                                    );
                                  }
                                },
                                child: Text("Generate OTP")
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              child: IconButton(
                                icon: Icon(Icons.refresh_rounded, color: Colors.blue,),
                                iconSize: 30,
                                onPressed: () {
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /*
                              ElevatedButton(
                                child: Text('${start.day}/${start.month}/${start.year}'),
                                onPressed: (){},
                              ),*/
                              Container(
                                width: MediaQuery.of(context).size.width*0.25,
                                height: MediaQuery.of(context).size.height*0.06,
                                decoration: BoxDecoration(color: Colors.white70, border: Border.all(width: 2, color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text(
                                    '${start.day}/${start.month}/${start.year}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width*0.25,
                                height: MediaQuery.of(context).size.height*0.06,
                                decoration: BoxDecoration(color: Colors.white70, border: Border.all(width: 2, color: Colors.blue), borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Text(
                                      '${end.day}/${end.month}/${end.year}',
                                      style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.transparent,),
                          //height: MediaQuery.of(context).size.height*0.05,
                          //width: MediaQuery.of(context).size.width*0.9,
                          child: ElevatedButton(
                            child: Text("Select Date"),
                            onPressed: () async {
                              DateTimeRange? newDate = await showDateRangePicker(
                                context: context,
                                initialDateRange: date,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                                if(newDate == null) return;
                                setState(() {
                                  date = newDate;
                                  print("${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}");
                                });
                            },
                          )
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.transparent,),
                          //height: MediaQuery.of(context).size.height*0.05,
                          //width: MediaQuery.of(context).size.width*0.9,
                          child: ElevatedButton(
                            child: Text("Generate Report"),
                            onPressed: () async{

                            },

                          )
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}