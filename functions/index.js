const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onCreateActivityFeedItem = functions.firestore
    .document("{college}/data/notificationFeed/{userId}/feedItems/{activityFeedItem}")
    .onCreate(async (snapshot, context) => {
      console.log("Activity Feed Item Created", snapshot.data());

      // 1) Get user connected to the feed
      const userId = context.params.userId;
      const college = context.params.college;

      const userRef = admin.firestore().doc(`${college}/data/users/${userId}`);
      const doc = await userRef.get();

      // 2) check if they have a notification token
      const androidNotificationToken = doc.data().androidNotificationToken;
      const createdActivityFeedItem = snapshot.data();
      // const goingUserIDRef = admin.firestore().doc(`${college}/data/users/${snapshot.data().userId}`);
      // admin.messaging().subscribeToTopic(goingUserIDRef.androidNotificationToken, snapshot.data().postId)
      //     .then(function(response) {
      //       // See the MessagingTopicManagementResponse reference documentation
      //       // for the contents of response.
      //       console.log("Successfully subscribed to topic:", response);
      //     })
      //     .catch(function(error) {
      //       console.log("Error subscribing to topic:", error);
      //     });
      if (androidNotificationToken) {
        sendNotification(androidNotificationToken, createdActivityFeedItem);
      } else {
        console.log("No token for user, cannot send notification");
      }

      /**
       * Adds two numbers together.
       * @param {string} androidNotificationToken The first number.
       * @param {string} activityFeedItem The second number.
       * @return {void} The sum of the two numbers.
       */
      function sendNotification(androidNotificationToken, activityFeedItem) {
        let body;
        let title;

        // 3) switch body value based off of notification type
        switch (activityFeedItem.type) {
          case "invite":
            title = "You're Invited";
            body = `${activityFeedItem.username} invited you to ${activityFeedItem.title}`;
            break;
          case "going":
            title = `${activityFeedItem.title}`;
            body = `${activityFeedItem.username} is going to ${activityFeedItem.title}`;
            break;
          case "friendGroup":
            title = "Added to Friend Group";
            body = `${activityFeedItem.username} added you to their Friend Group, ${activityFeedItem.groupName}`;
            break;
          case "suggestion":
            title = `${activityFeedItem.groupName}`;
            body = `${activityFeedItem.username} suggested ${activityFeedItem.title} to the group`;
            break;
          case "request":
            title = "You Have Friends?";
            body = `${activityFeedItem.username} sent you a friend request`;
            break;
          case "accept":
            title = "New Friend!";
            body = `${activityFeedItem.username} accepted your friend request`;
            break;
          default:
            break;
        }

        // 4) Create message for push notification
        const message = {
          notification: {title, body},
          token: androidNotificationToken,
          data: {recipient: userId},
        };

        // 5) Send message with admin.messaging()
        admin
            .messaging()
            .send(message)
            .then((response) => {
              // Response is a message ID string
              console.log("Successfully sent message!", response);
            })
            .catch((error) => {
              console.log("Error sending message", error);
            });
      }
    });

exports.scheduledFunction = functions.pubsub.schedule("* * * * *")
    .onRun(async (context) => {
      const now = admin.firestore.Timestamp.now();
      const querySnapshot = admin
          .firestore().collection("notreDame").doc("data")
          .collection("food")
          .where("startDate", ">=", now).get()
          .then((snapshot) => {
            snapshot.docs.forEach(async (doc) => {
              // doc is a DocumentSnapshot with actual data
              const data = doc.data();
              data.going.forEach(async (goingUser) => {
                const user = admin.firestore().collection("notreDame").doc("data").collection("users").doc(`${goingUser}`);
                const getUser = await user.get();
                const notifToken = getUser.data().androidNotificationToken;
                const message = {
                  notification: {title: data.title, body: "starts in one hour, don't flake!"},
                  token: notifToken,
                  data: {recipient: user.id},
                };
                if ((data.startDate.toDate().getMilliseconds() - 3600000) <= now.toDate().getMilliseconds()) {
                  console.log((data.startDate.toDate().getMilliseconds() - 3600000));
                  console.log(now.toDate().getMilliseconds());
                  // admin
                  //     .messaging()
                  //     .send(message)
                  //     .then((response) => {
                  //       // Response is a message ID string
                  //       console.log("Successfully sent message!", response, querySnapshot);
                  //     })
                  //     .catch((error) => {
                  //       console.log("Error sending message", error);
                  //     });
                  console.log(querySnapshot, message);
                }
              });
            });
          })
          .catch((error) => {
            console.log("Error Alvin: ", error);
          });
    });
