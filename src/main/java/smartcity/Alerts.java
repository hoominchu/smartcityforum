package smartcity;

import com.mongodb.*;
import sun.security.util.PropertyExpander;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by DSV on 30/12/16.
 */
public class Alerts {


    public void subscribeToField1(String email, int field1ID) { //Field1 is work and field1ID is workID
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                BasicDBObject update = new BasicDBObject();
                update.append("$push", new BasicDBObject(LoadProperties.properties.getString("Subscribers.FieldID1"), field1ID));
                Database.subscribers.update(whereQuery, update);
            } else {
                BasicDBList field1IDs = new BasicDBList();
                field1IDs.add(field1ID);
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.FieldID1"), field1IDs);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean checkIfSubscribedToField1(String email, int field1ID) {
        boolean check = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                List<Integer> field1IDs = (List<Integer>) where.get(LoadProperties.properties.getString("Subscribers.FieldID1"));
                if (field1IDs.contains(field1ID)) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    public void unsubscribeFromField1(String email, int field1ID) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            BasicDBObject update = new BasicDBObject();
            update.append("$pull", new BasicDBObject(LoadProperties.properties.getString("Subscribers.FieldID1"), field1ID));
            Database.subscribers.update(whereQuery, update);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
