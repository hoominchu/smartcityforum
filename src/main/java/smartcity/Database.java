package smartcity;

import com.mongodb.*;

import java.util.ResourceBundle;

/**
 * Created by minchu on 15/04/16.
 */
public class Database {

    final public static MongoClient mongoClient = new MongoClient(new ServerAddress("localhost", 27017));
    final private static Mongo mongo = new Mongo();
    final private static DB db = mongo.getDB("smartcitydb");

    final public static DBCollection allworks = db.getCollection(LoadProperties.properties.getString("Database.allWorks"));
    final public static DBCollection workDetails = db.getCollection(LoadProperties.properties.getString("Database.workDetails"));
    final public static DBCollection wardmaster = db.getCollection(LoadProperties.properties.getString("Database.wardMaster"));
    final public static DBCollection billspaid = db.getCollection(LoadProperties.properties.getString("Database.billsPaid"));
    final public static DBCollection minorWorkTypes = db.getCollection(LoadProperties.properties.getString("Database.minorWorkTypes"));
    final public static DBCollection corporators = db.getCollection(LoadProperties.properties.getString("Database.corporators"));
    final public static DBCollection workNotes = db.getCollection(LoadProperties.properties.getString("Database.workNotes"));
    final public static DBCollection authorizedEmails = db.getCollection(LoadProperties.properties.getString("Database.authorizedEmails"));
    final public static DBCollection superUsers = db.getCollection(LoadProperties.properties.getString("Database.superusers"));
    final public static DBCollection subscribers = db.getCollection(LoadProperties.properties.getString("Database.subscribers"));

    public static void updateDocument(String collectionName, String queryKey, String queryValue, String updateKey, String updateValue) {
        DBCollection collection = Database.db.getCollection(collectionName);

        BasicDBObject query = new BasicDBObject(queryKey,queryValue);
        BasicDBObject update = new BasicDBObject();
        update.append("$set", new BasicDBObject(updateKey,updateValue));

        collection.update(query,update);
    }

    public static void updateDocument(String collectionName, String queryKey, int queryValue, String updateKey, String updateValue) {
        DBCollection collection = Database.db.getCollection(collectionName);

        BasicDBObject query = new BasicDBObject(queryKey,queryValue);
        BasicDBObject update = new BasicDBObject();
        update.append("$set", new BasicDBObject(updateKey,updateValue));

        collection.update(query,update);
    }

    public static void updateDocument(String collectionName, String queryKey, String queryValue, String updateKey, int updateValue) {
        DBCollection collection = Database.db.getCollection(collectionName);

        BasicDBObject query = new BasicDBObject(queryKey,queryValue);
        BasicDBObject update = new BasicDBObject();
        update.append("$set", new BasicDBObject(updateKey,updateValue));

        collection.update(query,update);
    }

    public static void updateDocument(String collectionName, String queryKey, int queryValue, String updateKey, int updateValue) {
        DBCollection collection = Database.db.getCollection(collectionName);

        BasicDBObject query = new BasicDBObject(queryKey,queryValue);
        BasicDBObject update = new BasicDBObject();
        update.append("$set", new BasicDBObject(updateKey,updateValue));

        collection.update(query,update);
    }
}
