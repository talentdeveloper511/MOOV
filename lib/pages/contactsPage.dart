import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:share/share.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (Text('Contacts')),
      ),
      body: _contacts != null
          //Build a list view of all contacts, displaying their avatar and
          // display name
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                return Container(
                    padding: EdgeInsets.fromLTRB(6, 2.0, 6, 16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //    Image.asset(product.image, height: 50),
                          //     child: (contact.avatar != null && contact.avatar.isNotEmpty)
                          //      CircleAvatar(backgroundImage: MemoryImage(contact.avatar));
                          CircleAvatar(
                              child: Text(contact.initials()),
                              backgroundColor: Theme.of(context).accentColor),
                          SizedBox(width: 15),
                          Padding(
                            padding: EdgeInsets.only(left: 1.0),
                            child: Text(
                              contact.displayName ?? '',
                              style: new TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                                fontFamily: "Solway",
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(2.0),
                              color: Color.fromRGBO(2, 43, 91, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                              onPressed: () {
                                Share.share(
                                    'Hey check out the MOOV app at: https://play.google.com/store/apps/details?id=package:MOOV',
                                    subject: 'MOOV App');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Share",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]));
                /*return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                  leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                        )
                      : CircleAvatar(
                          child: Text(contact.initials()),
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                  title: Text(contact.displayName ?? ''),
                  trailing: Icon(Icons.share),
                  //This can be further expanded to showing contacts detail
                  onTap: () {
                    final RenderBox box = context.findRenderObject();
                    Share.share("Hey check out app at: https://play.google.com/store/apps/details?id=package:MOOV",
                        subject: "MOOV App ",
                        sharePositionOrigin:
                        box.localToGlobal(Offset.zero) &
                        box.size);
                  },
                  // onPressed().
                );*/
              },
            )
          : Center(child: const CircularProgressIndicator()),
    );
  }
}
