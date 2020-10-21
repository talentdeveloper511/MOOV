import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/pages/contacts/contactsPage.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_sms/flutter_sms.dart';

class SeeContactsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white
          .withOpacity(.7), //set this opacity as per your requirement

      onPressed: () async {
        final PermissionStatus permissionStatus = await _getPermission();
        if (permissionStatus == PermissionStatus.granted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ContactsPage()));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text('Permissions error'),
                    content: Text('Please enable contacts access '
                        'permission in system settings'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ));
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.contacts, color: TextThemes.ndGold),
          ),
          Container(
              child: Text('Import Contacts',
                  style: TextStyle(color: TextThemes.ndBlue))),
        ],
      ),
    );
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.undetermined;
    } else {
      return permission;
    }
  }

//   static String getValidPhoneNumber(Iterable phoneNumbers) {
//     if (phoneNumbers != null && phoneNumbers.toList().isNotEmpty) {
//       List phoneNumbersList = phoneNumbers.toList();
//       // This takes first available number. Can change this to display all
//       // numbers first and let the user choose which one use.
//       return phoneNumbersList[0].value;
//     }
//     return null;
//   }

//   static Future<void> callNumber(BuildContext context, String number) async {
//   number = number.replaceAll(RegExp(r"[^\w]"), "");
//   bool _result =
//       await launch('tel:' + number).catchError((dynamic onError) {
//     print(onError);
//     // standardAlertDialog(context, "Error", onError.toString());
//   });
//   if (_result == false) {
//     // standardAlertDialog(context, "Error", "Unable to call number");
//   }
// }

// Function onPhoneButtonPressed(BuildContext context) {
//   // String number = HelperFunctions.getValidPhoneNumber(phoneNumbers);
//   // if (number != null) {
//   //   return () {
//   //     HelperFunctions.callNumber(context, number);
//   //   };
//   // } else {
//   //   return null;
//   // }
// }

// }

// class MessagingDialog extends StatefulWidget {
//   MessagingDialog({Key key, this.messageCallback, this.recipient})
//       : super(key: key);

//   final Function messageCallback;
//   final String recipient;

//   @override
//   _MessagingDialogState createState() => _MessagingDialogState();
// }

// class _MessagingDialogState extends State<MessagingDialog> {
//   TextEditingController controller;

//   @override
//   void initState() {
//     controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Enter Message"),
//       content: TextFormField(controller: controller),
//       actions: <Widget>[
//         FlatButton(
//           child: Text("OK"),
//           onPressed: () {
//             widget.messageCallback(context, controller.text, widget.recipient);
//             Navigator.of(context).pop();
//           },
//         )
//       ],
//     );
//   }
// }

// class HelperFunctions {
//   static Future<void> initiateMessage(
//       BuildContext context, String message, String recipient) async {
//     final String _result =
//         await sendSMS(message: message, recipients: <String>[recipient])
//             .catchError((dynamic onError) {
//       standardAlertDialog(context, "Error", onError.toString());
//     });
//     print(_result);
//   }

//   static Future<void> callNumber(BuildContext context, String number) async {
//     number = number.replaceAll(RegExp(r"[^\w]"), "");
//     bool _result =
//         await launch('tel:' + number).catchError((dynamic onError) {
//       standardAlertDialog(context, "Error", onError.toString());
//     });
//     if (_result == false) {
//       standardAlertDialog(context, "Error", "Unable to call number");
//     }
//   }

//   static String getValidPhoneNumber(Iterable phoneNumbers) {
//     if (phoneNumbers != null && phoneNumbers.toList().isNotEmpty) {
//       List phoneNumbersList = phoneNumbers.toList();
//       // This takes first available number. Can change this to display all
//       // numbers first and let the user choose which one use.
//       return phoneNumbersList[0].value;
//     }
//     return null;
//   }

//   // Used for error messages
//   static void standardAlertDialog(
//       BuildContext context, String title, String content) {
//     showDialog<Dialog>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(title),
//             content: content.isNotEmpty ? Text(content) : null,
//             actions: <Widget>[
//               FlatButton(
//                 child: Text("OK"),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           );
//         });
//   }

//   static void messagingDialog(BuildContext context, String recipient) {
//     showDialog<Dialog>(
//         context: context,
//         builder: (BuildContext context) {
//           return MessagingDialog(
//               messageCallback: initiateMessage, recipient: recipient);
//         });
//   }
// }

// class SmsButton extends StatelessWidget {
//   const SmsButton({Key key, @required this.phoneNumbers}) : super(key: key);

//   final Iterable phoneNumbers;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.message),
//       onPressed: onSmsButtonPressed(context),
//     );
//   }

//   Function onSmsButtonPressed(BuildContext context) {
//     String number = HelperFunctions.getValidPhoneNumber(phoneNumbers);
//     if (number != null) {
//       return () {
//         HelperFunctions.messagingDialog(context, number);
//       };
//     } else {
//       return null;
//     }
//   }
// }

// class PhoneButton extends StatelessWidget {
//   const PhoneButton({Key key, @required this.phoneNumbers}) : super(key: key);

//   final Iterable phoneNumbers;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.phone),
//       onPressed: onPhoneButtonPressed(context),
//     );
//   }

//   Function onPhoneButtonPressed(BuildContext context) {
//     String number = HelperFunctions.getValidPhoneNumber(phoneNumbers);
//     if (number != null) {
//       return () {
//         HelperFunctions.callNumber(context, number);
//       };
//     } else {
//       return null;
//     }
//   }
}
