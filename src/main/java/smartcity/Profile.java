package smartcity;

import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.util.List;

/**
 * Created by minchu on 04/01/17.
 */
public class Profile {
    public String email;
    public String nameOfUser;
    public List<Integer> subscribedWorks;
    public List<Integer> subscribedWards;
    public List<Integer> subscribedSourcesOfIncome;
    public List<Integer> subscribedWorkTypes;

    public Profile(String emailArg) {
        this.email = emailArg;
        //this.nameOfUser = nameOfUserArg;
        addProfile(emailArg);
        BasicDBObject query = new BasicDBObject();
        query.append("email", this.email);
        DBCursor cursor = Database.subscribers.find(query);

        while (cursor.hasNext()) {
            DBObject subscriber = cursor.next();

            //Subscribers.Field1 = Work ID
            this.subscribedWorks = (List<Integer>) subscriber.get(LoadProperties.properties.getString("Subscribers.Field1"));
            this.subscribedWards = (List<Integer>) subscriber.get(LoadProperties.properties.getString("Subscribers.Field2"));
            this.subscribedSourcesOfIncome = (List<Integer>) subscriber.get(LoadProperties.properties.getString("Subscribers.Field3"));
        }
    }

    public void addProfile(String email) {
        boolean isUserSubscribed = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                isUserSubscribed = true;
            }
            if(!isUserSubscribed){
                BasicDBList field1List = new BasicDBList();
                BasicDBList field2List = new BasicDBList();
                BasicDBList field3List = new BasicDBList();
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.Field1"), field1List);
                document.append(LoadProperties.properties.getString("Subscribers.Field2"), field2List);
                document.append(LoadProperties.properties.getString("Subscribers.Field3"), field3List);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
