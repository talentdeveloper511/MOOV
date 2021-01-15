import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


export const sendToDevice = functions.firestore
  .document('notificationFeed/{currentUser}/feedItems/{userId}')
  .onCreate(async snapshot => {


    const notification = snapshot.data();

    const querySnapshot = await db
      .collection('users')
      .doc(notification.ownerName)
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Friend Request Accepted',
        body: `You made a new friend`,
        icon: '../../lib/assets/alvin.png',
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
      },
    };

    return fcm.sendToDevice(tokens, payload);
  });


    functions.pubsub.schedule("* * * * *").onRun(async () => {
        // const oneHourOld = admin.firestore.Timestamp.now().toMillis() - 3600000;
        const now = admin.firestore.Timestamp.now().toMillis;


        
      
        const querySnapshot = await admin
          .firestore()
          .collection("food")
          .where("startDateTimestamp", "<", now)
          .get();
      
        const batch = admin.firestore().batch();
      
        querySnapshot.forEach((docSnapshot) => {
          batch.delete(docSnapshot.ref);
        });
      
        await batch.commit();
      });
      
//       var x = (course['startDate']
//       .millisecondsSinceEpoch);
//   var y =
//       (DateTime.now().millisecondsSinceEpoch);

//   print(x);
//   print(x < (y));

exports.scheduledFunction = functions.pubsub.schedule('every 5 minutes').onRun(async (context) => {
    const now = admin.firestore.Timestamp.now().toMillis;


        
      
        const querySnapshot = await admin
          .firestore()
          .collection("food")
          .where("startDateTimestamp", "<", now)
          .get();
      
        const batch = admin.firestore().batch();
      
        querySnapshot.forEach((docSnapshot) => {
          batch.delete(docSnapshot.ref);
        });
      
        await batch.commit();    return null;
  });