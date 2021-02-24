const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();

exports.helloWorld = functions.https.onRequest((request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});

exports.allCocktails = functions.https.onRequest(async (request, response) => {
    // const original = req.query.text;
    // console.log(original);
    var snapshot = await admin.firestore().collection('cocktails').get();
    var payload = []
    snapshot.forEach(doc => {
        payload.push(doc.data()['name']);
    });
    return response.json({
      payload: payload
    });
});
