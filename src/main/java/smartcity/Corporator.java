package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

/**
 * This class isn't being used right now. This has been created keeping in mind the scalability of the project.
 * Created by minchu on 21/04/16.
 */
public class Corporator {

    public int ID;
    public String name;
    public String sex;
    public String party;
    public String termsServed;        //AND/OR some other historical fact about the corporator.
    public String linkToPersonalWebpage;    //Or myneta.gov profile.
    public String address;
    public String emailID;
    public String phoneNumber;

    public static String[] getCorporatorDetails(int wardNum) {
        String[] corporatorDetails = new String[6];

        DBCursor cursor = Database.corporators.find(new BasicDBObject(LoadProperties.properties.getString("Corporator.Column.WardNumber"), wardNum));

        while (cursor.hasNext()) {
            DBObject corporator = cursor.next();
            corporatorDetails[0] = corporator.get(LoadProperties.properties.getString("Corporator.Column.Name")) != null ? corporator.get(LoadProperties.properties.getString("Corporator.Column.Name")).toString() : "null";
            corporatorDetails[1] = corporator.get(LoadProperties.properties.getString("Corporator.Column.NameLang2")) != null ? corporator.get(LoadProperties.properties.getString("Corporator.Column.NameLang2")).toString() : "null";
            corporatorDetails[2] = corporator.get(LoadProperties.properties.getString("Corporator.Column.ContactNumber")) != null ? corporator.get(LoadProperties.properties.getString("Corporator.Column.ContactNumber")).toString() : "null";
            corporatorDetails[3] = corporator.get(LoadProperties.properties.getString("Corporator.Column.Party")) != null ? corporator.get(LoadProperties.properties.getString("Corporator.Column.Party")).toString() : "null";
            corporatorDetails[4] = corporator.get(LoadProperties.properties.getString("Corporator.Column.PartyLang2")) != null ? corporator.get(LoadProperties.properties.getString("Corporator.Column.PartyLang2")).toString() : "null";
            corporatorDetails[5] = corporator.get(LoadProperties.properties.getString("Corporator.Column.ImageURL")) != null ? corporator.get(LoadProperties.properties.getString("Corporator.Column.ImageURL")).toString() : "null";
            break;
        }
        return corporatorDetails;
    }

}