package smartcity;

import com.mongodb.*;
import sun.security.util.PropertyExpander;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by DSV on 30/12/16.
 */
public class Alerts {

    public boolean checkIfSubscribedToField1(String email, int field1) {
        boolean check = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                List<Integer> field1List = (List<Integer>) where.get(LoadProperties.properties.getString("Subscribers.Field1"));
                if (field1List.contains(field1)) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    public void subscribeToField1(String email, int field1) { //Field1 is work and field1ID is workID
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                BasicDBObject update = new BasicDBObject();
                update.append("$push", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field1"), field1));
                Database.subscribers.update(whereQuery, update);
            } else {
                BasicDBList field1List = new BasicDBList();
                field1List.add(field1);
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.Field1"), field1List);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsubscribeFromField1(String email, int field1) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            BasicDBObject update = new BasicDBObject();
            update.append("$pull", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field1"), field1));
            Database.subscribers.update(whereQuery, update);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
