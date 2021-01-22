import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.onCreateActivityFeedItem = functions.firestore
  .document("notreDame/data/notificationFeed/{userId}/feedItems/{activityFeedItem}")
  .onCreate(async (snapshot, context) => {
    console.log("Activity Feed Item Created", snapshot.data());

    // 1) Get user connected to the feed
    const userId = context.params.userId;

    const userRef = admin.firestore().doc(`notreDame/data/users/${userId}`);
    const doc = await userRef.get();

    // 2) Once we have user, check if they have a notification token; send notification, if they have a token
    const androidNotificationToken = doc.data()!.androidNotificationToken;
    const createdActivityFeedItem = snapshot.data();
    if (androidNotificationToken) {
      sendNotification(androidNotificationToken, createdActivityFeedItem);
    } else {
      console.log("No token for user, cannot send notification Alvin");
    }

    function sendNotification(androidNotificationToken: any, activityFeedItem: { [x: string]: any; type?: any; username?: any; commentData?: any; }) {
      let body;

      // 3) switch body value based off of notification type
      switch (activityFeedItem.type) {
        case "invite":
          body = `${activityFeedItem.username} invited you`;
          break;
        case "going":
          body = `${activityFeedItem.username} is going to your MOOV`;
          break;
        case "friendgroup":
          body = `${activityFeedItem.username} added you to a friend group`;
          break;
        default:
          break;
      }

      // 4) Create message for push notification
      const message = {
        notification: { body },
        token: androidNotificationToken,
        data: { recipient: userId }
      };

      // 5) Send message with admin.messaging()
      admin
        .messaging()
        .send(message)
        .then(response => {
          // Response is a message ID string
          console.log("Successfully sent message Alvin", response);
        })
        .catch(error => {
          console.log("Error sending message Alvin", error);
        });
    }
  });


export const sendToDevice = functions.firestore
  .document('notreDame/data/notificationFeed/{currentUser}/feedItems/{userId}')
  .onCreate(async snapshot => {


    const notification = snapshot.data();

    const querySnapshot = await db
    .collection('notreDame').doc('data')
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
          .firestore().collection("notreDame").doc("data")
          .collection("food")
          .where("startDateTimestamp", "<", now)
          .get();
      
        const batch = admin.firestore().batch();
      
        querySnapshot.forEach((docSnapshot) => {
          batch.delete(docSnapshot.ref);
        });
      
        await batch.commit();
      });

// exports.scheduledFunction = functions.pubsub.schedule('every 5 minutes').onRun(async (context) => {
//     const now = admin.firestore.Timestamp.now().toMillis;

//         const querySnapshot = await admin
//           .firestore().collection("notreDame").doc("data")
//           .collection("food")
//           .where("startDateTimestamp", "<", now)
//           .get();
      
//         const batch = admin.firestore().batch();
      
//         querySnapshot.forEach((docSnapshot) => {
//           batch.delete(docSnapshot.ref);
//         });
      
//         await batch.commit();    return null;
//   });