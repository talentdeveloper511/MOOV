const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// const db = admin.firestore();
// const fcm = admin.messaging();

exports.onCreateActivityFeedItem = functions.firestore
    .document("/notificationFeed/{userId}/feedItems/{activityFeedItem}")
    .onCreate(async (snapshot, context) => {
      console.log("Activity Feed Item Created", snapshot.data());

      // 1) Get user connected to the feed
      const userId = context.params.userId;

      const userRef = admin.firestore().doc(`users/${userId}`);
      const doc = await userRef.get();

      // 2) check if they have a notification token
      const androidNotificationToken = doc.data().androidNotificationToken;
      const createdActivityFeedItem = snapshot.data();
      if (androidNotificationToken) {
        sendNotification(androidNotificationToken, createdActivityFeedItem);
      } else {
        console.log("No token for user, cannot send notification Alvin");
      }
      /**
       * Adds two numbers together.
       * @param {string} androidNotificationToken The first number.
       * @param {string} activityFeedItem The second number.
       * @return {void} The sum of the two numbers.
       */
      function sendNotification(androidNotificationToken, activityFeedItem) {
        let body;

        // 3) switch body value based off of notification type
        switch (activityFeedItem.type) {
          case "invite":
            body = `${activityFeedItem.username} invited you to a MOOV`;
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
          notification: {body},
          token: androidNotificationToken,
          data: {recipient: userId},
        };

        // 5) Send message with admin.messaging()
        admin
            .messaging()
            .send(message)
            .then((response) => {
              // Response is a message ID string
              console.log("Successfully sent message Alvin", response);
            })
            .catch((error) => {
              console.log("Error sending message Alvin", error);
            });
      }
    });

// exports.sendToDevice = functions.firestore
//     .document("notificationFeed/{currentUser}/feedItems/{userId}")
//     .onCreate(async (snapshot) => {
//       const notification = snapshot.data();

//       const querySnapshot = await db
//           .collection("users")
//           .doc(notification.ownerName)
//           .collection("tokens")
//           .get();

//       const tokens = querySnapshot.docs.map((snap) => snap.id);

//       const payload: admin.messaging.MessagingPayload = {
//         notification: {
//           title: "Friend Request Accepted",
//           body: "You made a new friend",
//           icon: "../../lib/assets/alvin.png",
//           click_action: "FLUTTER_NOTIFICATION_CLICK",
//         },
//       };

//       return fcm.sendToDevice(tokens, payload);
//     });


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

exports.scheduledFunction = functions.pubsub.schedule("every 5 minutes")
    .onRun(async (context) => {
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

      await batch.commit(); return null;
    });
