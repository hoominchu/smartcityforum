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
}
