package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

/**
 * Created by minchu on 07/06/16.
 */
public class EveryNightScripts {

    public static void updateDB() {

        Database.allworks.createIndex(new BasicDBObject(LoadProperties.properties.getString("Work.Column.WorkID"), -1));
        Database.billspaid.createIndex(new BasicDBObject(LoadProperties.properties.getString("Bill.Column.WorkID"), 1));
        Database.workDetails.createIndex(new BasicDBObject(LoadProperties.properties.getString("WorkDetails.Column.WorkID"), 1));
        Database.corporators.createIndex(new BasicDBObject(LoadProperties.properties.getString("Corporator.Column.WardNumber"), 1));
        Database.minorWorkTypes.createIndex(new BasicDBObject(LoadProperties.properties.getString("MinorWorkType.Column.Code"), 1));
        Database.workNotes.createIndex(new BasicDBObject("Work ID", 1));
        Database.authorizedEmails.createIndex(new BasicDBObject(LoadProperties.properties.getString("Users.Column.Email"), 1));
        Database.superUsers.createIndex(new BasicDBObject(LoadProperties.properties.getString("Users.Column.Email"), 1));
        Database.wardmaster.createIndex(new BasicDBObject(LoadProperties.properties.getString("Ward.Column.WardNumber"), 1));

        DBCursor allWorks = Database.allworks.find();

        while (allWorks.hasNext()) {
            DBObject work = allWorks.next();
            int workID = (int) work.get(LoadProperties.properties.getString("Work.Column.WorkID"));


            BasicDBObject billQuery = new BasicDBObject(LoadProperties.properties.getString("Bill.Column.WorkID"), workID);

            //Possible bug here
            BasicDBObject workQuery = new BasicDBObject(LoadProperties.properties.getString("Work.Column.WorkID"), workID);

            DBCursor billsPaid = Database.billspaid.find(billQuery);
            int billTotal = 0;

            while (billsPaid.hasNext()) {
                DBObject bill = billsPaid.next();
                int billAmount = bill.get(LoadProperties.properties.getString("Bill.Column.PaidAmount")) != null ? (int) bill.get(LoadProperties.properties.getString("Bill.Column.PaidAmount")) : 0;
                billTotal = billTotal + billAmount;
            }

            BasicDBObject newDocument = new BasicDBObject();
            newDocument.append("$set", new BasicDBObject().append(LoadProperties.properties.getString("Work.Column.TotalBillAmountPaid"), billTotal));

            Database.allworks.update(workQuery, newDocument);

            /////////////////////////

            //DBObject work = allWorks.next();
            //int workID = (int) work.get("Work ID");

            BasicDBObject query = new BasicDBObject(LoadProperties.properties.getString("WorkDetails.Column.WorkID"), workID);

            DBCursor workdetails = Database.workDetails.find(query);

            BasicDBObject newDoc = new BasicDBObject();

            if (workdetails.size() > 0) {
                newDoc.append("$set", new BasicDBObject().append(LoadProperties.properties.getString("Work.Column.AreWorkDetails"), "TRUE"));
            } else {
                newDoc.append("$set", new BasicDBObject().append(LoadProperties.properties.getString("Work.Column.AreWorkDetails"), "FALSE"));
            }

            Database.allworks.update(query, newDoc);

            ////----------------------------

            //DBObject work = works.next();

            String minorWorkTypeID = work.get(LoadProperties.properties.getString("Work.Column.MinorWorkTypeID")) != null ? work.get(LoadProperties.properties.getString("Work.Column.MinorWorkTypeID")).toString() : "null";
            //int workID = (int) work.get("Work ID");

            BasicDBObject minorIDQuery = new BasicDBObject(LoadProperties.properties.getString("MinorWorkType.Column.Code"), Integer.parseInt(minorWorkTypeID));

            DBCursor minorIDs = Database.minorWorkTypes.find(minorIDQuery);

            DBObject minorID = minorIDs.next();
            String minorIDMeaning = minorID.get(LoadProperties.properties.getString("MinorWorkType.Column.Meaning")) != null ? minorID.get(LoadProperties.properties.getString("MinorWorkType.Column.Meaning")).toString() : "null";

            BasicDBObject IDMeaning = new BasicDBObject();
            IDMeaning.append("$set", new BasicDBObject().append(LoadProperties.properties.getString("Work.Column.MinorWorkTypeIDMeaning"), minorIDMeaning));

            Database.allworks.update(new BasicDBObject(LoadProperties.properties.getString("Work.Column.AreWorkDetails"), workID), IDMeaning);
        }
    }
}
