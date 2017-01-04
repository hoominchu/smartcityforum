package smartcity;

import com.mongodb.*;
import sun.security.util.PropertyExpander;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by DSV on 30/12/16.
 */
public class Alerts {

    //FIELD 1 ---- WORK ID
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

    public void subscribeToField1(String email, int field1) {
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


    //FIELD 2 ----- WARD NUMBER
    public boolean checkIfSubscribedToField2(String email, int field2) {
        boolean check = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                List<Integer> field2List = (List<Integer>) where.get(LoadProperties.properties.getString("Subscribers.Field2"));
                if (field2List.contains(field2)) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    public void subscribeToField2(String email, int field2) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                BasicDBObject update = new BasicDBObject();
                update.append("$push", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field2"), field2));
                Database.subscribers.update(whereQuery, update);
            } else {
                BasicDBList field2List = new BasicDBList();
                field2List.add(field2);
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.Field2"), field2List);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsubscribeFromField2(String email, int field2) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            BasicDBObject update = new BasicDBObject();
            update.append("$pull", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field2"), field2));
            Database.subscribers.update(whereQuery, update);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //FIELD 3 ---- SOURCE OF INCOME
    public boolean checkIfSubscribedToField3(String email, int field3) {
        boolean check = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                List<Integer> field3List = (List<Integer>) where.get(LoadProperties.properties.getString("Subscribers.Field3"));
                if (field3List.contains(field3)) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    public void subscribeToField3(String email, int field3) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                BasicDBObject update = new BasicDBObject();
                update.append("$push", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field3"), field3));
                Database.subscribers.update(whereQuery, update);
            } else {
                BasicDBList field3List = new BasicDBList();
                field3List.add(field3);
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.Field3"), field3List);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsubscribeFromField3(String email, int field3) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            BasicDBObject update = new BasicDBObject();
            update.append("$pull", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field3"), field3));
            Database.subscribers.update(whereQuery, update);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
