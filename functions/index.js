const functions = require("firebase-functions");
const admin = require("firebase-admin");
const algoliasearch = require("algoliasearch");
// const {user} = require("firebase-functions/lib/providers/auth");
admin.initializeApp(functions.config().firebase);

const ALGOLIA_APP_ID = "CUWBHO409I";
const ALGOLIA_ADMIN_KEY = "53390b64ddeba1e1f32e81485ebf9492";
const ALGOLIA_INDEX_NAME = "users";
const ALGOLIA_INDEX_NAME2 = "events";
const ALGOLIA_INDEX_NAME3 = "groups";

exports.createPost = functions.firestore
    .document("{college}/data/users/{userId}")
    .onCreate( async (snap, context) => {
      const newValue = snap.data();
      newValue.objectID = snap.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME);
      index.saveObject(newValue);
      console.log("Finished");
    });

exports.updatePost = functions.firestore
    .document("{college}/data/users/{userId}")
    .onUpdate( async (snap, context) => {
      const afterUpdate = snap.after.data();
      afterUpdate.objectID = snap.after.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME);
      index.saveObject(afterUpdate);
    });

exports.deletePost = functions.firestore
    .document("{college}/data/users/{userId}")
    .onDelete( async (snap, context) => {
      const oldID = snap.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME);
      index.deleteObject(oldID);
    });

exports.createEvent = functions.firestore
    .document("{college}/data/food/{eventId}")
    .onCreate( async (snap, context) => {
      const newValue = snap.data();
      newValue.objectID = snap.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME2);
      index.saveObject(newValue);
      console.log("Finished");
    });

exports.updateEvent = functions.firestore
    .document("{college}/data/food/{eventId}")
    .onUpdate( async (snap, context) => {
      const afterUpdate = snap.after.data();
      afterUpdate.objectID = snap.after.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME2);
      index.saveObject(afterUpdate);
    });

exports.deleteEvent = functions.firestore
    .document("{college}/data/food/{eventId}")
    .onDelete( async (snap, context) => {
      const oldID = snap.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME2);
      index.deleteObject(oldID);
    });

exports.createGroup = functions.firestore
    .document("{college}/data/friendGroups/{groupId}")
    .onCreate( async (snap, context) => {
      const newValue = snap.data();
      newValue.objectID = snap.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME3);
      index.saveObject(newValue);
      console.log("Finished");
    });

exports.updateGroup = functions.firestore
    .document("{college}/data/friendGroups/{groupId}")
    .onUpdate( async (snap, context) => {
      const afterUpdate = snap.after.data();
      afterUpdate.objectID = snap.after.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME3);
      index.saveObject(afterUpdate);
    });

exports.deleteGroup = functions.firestore
    .document("{college}/data/friendGroups/{groupId}")
    .onDelete( async (snap, context) => {
      const oldID = snap.id;
      const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
      const index = client.initIndex(ALGOLIA_INDEX_NAME3);
      index.deleteObject(oldID);
    });

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
      const pushSettings = doc.data().pushSettings;
      if (androidNotificationToken) {
        if (pushSettings.going == true && createdActivityFeedItem.type == "going") {
          sendNotification(androidNotificationToken, createdActivityFeedItem);
        } else if (pushSettings.friendPosts == true && createdActivityFeedItem.type == "created") {
          sendNotification(androidNotificationToken, createdActivityFeedItem);
        } else if (pushSettings.suggestions == true && createdActivityFeedItem.type == "suggestion") {
          sendNotification(androidNotificationToken, createdActivityFeedItem);
        } else if (createdActivityFeedItem.type != "suggestion" && createdActivityFeedItem.type != "created" && createdActivityFeedItem.type != "going") {
          sendNotification(androidNotificationToken, createdActivityFeedItem);
        }
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
            title = `${activityFeedItem.username}`;
            body = `invited you to ${activityFeedItem.title}`;
            break;
          case "sent":
            title = `${activityFeedItem.username}`;
            body = `sent you ${activityFeedItem.title}`;
            break;
          case "edit":
            title = `${activityFeedItem.username}`;
            body = "has been updated with a new start time";
            break;
          case "going":
            title = `${activityFeedItem.title}`;
            body = `${activityFeedItem.username} is going to your MOOV!`;
            break;
          case "friendGroup":
            title = `${activityFeedItem.username}`;
            body = `added you to their friend group, ${activityFeedItem.groupName}`;
            break;
          case "suggestion":
            title = `${activityFeedItem.groupName}`;
            body = `${activityFeedItem.username} suggested ${activityFeedItem.title}`;
            break;
          case "comment":
            title = `${activityFeedItem.title}`;
            body = `${activityFeedItem.username} commented: "${activityFeedItem.message}"`;
            break;
          case "request":
            title = `${activityFeedItem.username}`;
            body = "sent you a friend request";
            break;
          case "created":
            title = `${activityFeedItem.username}`;
            body = `just posted ${activityFeedItem.title}`;
            break;
          case "deleted":
            title = `${activityFeedItem.username} `;
            body = "has been canceled";
            break;
          case "accept":
            title = `${activityFeedItem.username} `;
            body = "accepted your friend request";
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

exports.onCreateGroupFeedItem = functions.firestore
    .document("{college}/data/notificationFeed/{groupId}/feedItems/{activityFeedItem}")
    .onCreate(async (snapshot, context) => {
      console.log("Activity Feed Item Created", snapshot.data());

      // 1) Get user connected to the feed
      const groupId = context.params.groupId;
      const college = context.params.college;

      const groupRef = admin.firestore().doc(`${college}/data/friendGroups/${groupId}`);
      const doc = await groupRef.get();
      const name = doc.data().groupName;
      let userId;

      // 2) check if they have a notification token
      const members = doc.data().members;
      const createdActivityFeedItem = snapshot.data();
      for (let i = 0; i < members.length; i++) {
        const userRef = admin.firestore().doc(`${college}/data/users/${members[i]}`);
        const userdoc = await userRef.get();
        userId = userdoc.data().id;
        if (userdoc.data().androidNotificationToken && userdoc.data().pushSettings["suggestions"] == true) {
          sendNotification(userdoc.data().androidNotificationToken, createdActivityFeedItem);
        } else {
          console.log("No token for user, cannot send notification");
        }
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
            title = `${name}`;
            body = `${activityFeedItem.username} has invited you all to ${activityFeedItem.title}`;
            break;
          case "suggestion":
            title = `${activityFeedItem.groupName}`;
            body = `${activityFeedItem.username} suggested ${activityFeedItem.title}`;
            break;
          case "canceled":
            title = `${activityFeedItem.title}`;
            body = "has been canceled";
            break;
          case "sent":
            title = `${activityFeedItem.username}`;
            body = `sent you ${activityFeedItem.title}`;
            break;
          case "askToJoin":
            title = `${activityFeedItem.groupName}`;
            body = `${activityFeedItem.username} requested to join`;
            break;
          case "chat":
            title = `${activityFeedItem.groupName}`;
            body = `${activityFeedItem.username}: ${activityFeedItem.title}`;
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
        if (activityFeedItem.userId != userId) {
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
      }
    });

exports.groupChat = functions.firestore
    .document("{college}/data/friendGroups/{groupId}/chat/{activityFeedItem}")
    .onCreate(async (snapshot, context) => {
      console.log("Activity Feed Item Created", snapshot.data());

      // 1) Get user connected to the feed
      const groupId = context.params.groupId;
      const college = context.params.college;

      const groupRef = admin.firestore().doc(`${college}/data/friendGroups/${groupId}`);
      const doc = await groupRef.get();
      const groupName = doc.data().groupName;
      let userId;

      // 2) check if they have a notification token
      const members = doc.data().members;
      const createdActivityFeedItem = snapshot.data();
      const senderId = createdActivityFeedItem.userId;
      for (let i = 0; i < members.length; i++) {
        const userRef = admin.firestore().doc(`${college}/data/users/${members[i]}`);
        const userdoc = await userRef.get();
        userId = userdoc.data().id;
        console.log("sender id:", senderId);
        console.log("user id: ", userId);
        if (userdoc.data().androidNotificationToken && userdoc.data().pushSettings["suggestions"] == true && userId != senderId) {
          sendNotification(userdoc.data().androidNotificationToken, createdActivityFeedItem, groupName);
        } else {
          console.log("No token for user, cannot send notification");
        }
      }
      /**
       * Adds two numbers together.
       * @param {string} androidNotificationToken The first number.
       * @param {string} activityFeedItem The second number.
       * @param {string} groupName The second number.
       * @return {void} The sum of the two numbers.
       */
      function sendNotification(androidNotificationToken, activityFeedItem, groupName) {
        const body = `${activityFeedItem.displayName}: "${activityFeedItem.comment}"`;
        const title = `${groupName}`;
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

exports.resetScore = functions.pubsub.schedule("55 23 * * 0").timeZone("America/New_York")
    .onRun(async (context) => {
      const querySnapshot = admin
          .firestore().collection("notreDame").doc("data")
          .collection("users").get()
          .then((snapshot) => {
            snapshot.docs.forEach(async (doc) => {
              const data = doc.data();
              admin.firestore().collection("notreDame").doc("data").collection("users").doc(`${data.id}`).set({
                score: 0,
              }, {merge: true});
              console.log("Scores wiped!");
            });
            console.log(querySnapshot);
          });
    });

exports.resetLimits = functions.pubsub.schedule("0 0 * * *")
    .onRun(async (context) => {
      const querySnapshot = admin
          .firestore().collection("notreDame").doc("data")
          .collection("users").get()
          .then((snapshot) => {
            snapshot.docs.forEach(async (doc) => {
              const data = doc.data();
              admin.firestore().collection("notreDame").doc("data").collection("users").doc(`${data.id}`).set({
                postLimit: 3,
                sendLimit: 5,
                groupLimit: 2,
                suggestLimit: 5,
              }, {merge: true});
              console.log("Limits reset!");
            });
            console.log(querySnapshot);
          });
    });

exports.fixPrivacy = functions.firestore
    .document("{college}/data/users/{userId}")
    .onCreate(async (snapshot, context) => {
      const userId = context.params.userId;
      admin.firestore().collection("notreDame").doc("data").collection("users").doc(`${userId}`).set({
        "privacySettings": {
          "friendFinderVisibility": true,
          "friendsOnly": false,
          "incognito": false,
          "showDorm": true,
        },
      }, {merge: true});
    });

exports.editPostNotif = functions.firestore
    .document("{college}/data/food/{postId}")
    .onUpdate(async (snapshot, context) => {
      const postId = context.params.postId;
      const college = context.params.college;
      const postRef = admin.firestore().doc(`${college}/data/food/${postId}`);
      const doc = await postRef.get();
      let userId;
      const oldTime = snapshot.before.startDate.toDate();
      console.log("old time: ", oldTime);
      const newTime = snapshot.after.startDate.toDate();

      // 2) check if they have a notification token
      const going = doc.data().going;
      const createdActivityFeedItem = snapshot.data();
      console.log("created: ", createdActivityFeedItem);
      const senderId = createdActivityFeedItem.userId;
      for (let i = 0; i < going.length; i++) {
        const userRef = admin.firestore().doc(`${college}/data/users/${going[i]}`);
        const userdoc = await userRef.get();
        userId = userdoc.data().id;
        console.log("sender id:", senderId);
        console.log("user id: ", userId);
        if (userdoc.data().androidNotificationToken && userId != senderId && oldTime != newTime) {
          sendNotification(userdoc.data().androidNotificationToken, createdActivityFeedItem, newTime);
        } else {
          console.log("No token for user, cannot send notification");
        }
      }
      /**
       * Adds two numbers together.
       * @param {string} androidNotificationToken The first number.
       * @param {string} activityFeedItem The second number.
       * @param {string} newTime The second number.
       * @return {void} The sum of the two numbers.
       */
      function sendNotification(androidNotificationToken, activityFeedItem, newTime) {
        const body = `was updated to ${newTime}`;
        const title = `${activityFeedItem.title}`;
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
                if (data.startDate.toDate().getDate() == now.toDate().getDate() && data.startDate.toDate().getMonth() == now.toDate().getMonth() && data.startDate.toDate().getFullYear() == now.toDate().getFullYear()) {
                  if ((data.startDate.toDate().getHours() - 1 == now.toDate().getHours()) && data.scheduled != "true") {
                    admin.firestore().collection("notreDame").doc("data").collection("food").doc(`${data.postId}`).set({
                      scheduled: "true",
                    }, {merge: true});
                    if (user.pushSettings.hourBefore == true) {
                      admin
                          .messaging()
                          .send(message)
                          .then((response) => {
                            // Response is a message ID string
                            console.log("Successfully sent message!", response, querySnapshot);
                          })
                          .catch((error) => {
                            console.log("Error sending message", error);
                          });
                    }
                  }
                  // else if ((data.startDate.toDate().getHours() + 1 == now.toDate().getHours()) && data.scheduled != "true") {
                  //   console.log("deleting post!");
                  //   // admin.firestore().collection("notreDame").doc("data").collection("food").doc(`${data.postId}`).collection("comments").delete();
                  //   // admin.firestore().collection("notreDame").doc("data").collection("food").doc(`${data.postId}`).delete();
                  // }
                  console.log(querySnapshot, message);
                }
              });
            });
          })
          .catch((error) => {
            console.log("Error Alvin: ", error);
          });
    });
