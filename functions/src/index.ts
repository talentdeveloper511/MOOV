import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();
const db = admin.firestore();

export const taskRunner = functions.runWith( { memory: '2GB' }).pubsub

    .schedule('* * * * *').onRun(async context => {
        

        // Consistent timestamp
        const now = admin.firestore.Timestamp.now();
        
        // Query all documents ready to perform
        const query = db.collection('food').where('startDate', '<=', now).where('status', '==', 'scheduled');

        const tasks = await query.get();


        // Jobs to execute concurrently. 
        const jobs: Promise<any>[] = [];

        // Loop over documents and push job.
        tasks.forEach(snapshot => {
            const { worker, options } = snapshot.data();

            const job = worker[worker](options)
                
                // Update doc with status on success or error
                .then(() => snapshot.ref.update({ status: 'complete' }))
                // .catch((err) => snapshot.ref.update({ status: 'error' }));

            jobs.push(job);
        });

        // Execute all jobs concurrently
        return await Promise.all(jobs);

});
