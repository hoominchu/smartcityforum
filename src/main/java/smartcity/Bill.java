package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.util.ArrayList;

/**
 * Created by minchu on 02/06/16.
 */
public class Bill {
    public int recID;    //This is the same as work ID.
    public String mainCategory;
    public String passedCategory;
    public String contractor;
    public String descriptionEnglish;
    public String billPassDate;
    public String billPassAmount;
    public String paidDate;
    public String paidAmount;

    public Bill (DBObject billObject) {
        try {
            this.recID = billObject.get(LoadProperties.properties.getString("Bill.Column.WorkID")) != null ? (int) billObject.get(LoadProperties.properties.getString("Bill.Column.WorkID")) : 0;
            this.mainCategory = billObject.get(LoadProperties.properties.getString("Bill.Column.MainCategory")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.MainCategory")).toString() : "null";
            this.passedCategory = billObject.get(LoadProperties.properties.getString("Bill.Column.PassedCategory")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.PassedCategory")).toString() : "null";
            this.contractor = billObject.get(LoadProperties.properties.getString("Bill.Column.Contractor")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.Contractor")).toString() : "null";
            this.descriptionEnglish = billObject.get(LoadProperties.properties.getString("Bill.Column.DescriptionEnglish")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.DescriptionEnglish")).toString() : "null";
            this.billPassDate = billObject.get(LoadProperties.properties.getString("Bill.Column.BillPassDate")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.BillPassDate")).toString() : "null";
            this.billPassAmount = billObject.get(LoadProperties.properties.getString("Bill.Column.BillPassAmount")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.BillPassAmount")).toString() : "null";
            this.paidDate = billObject.get(LoadProperties.properties.getString("Bill.Column.PaidDate")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.PaidDate")).toString() : "null";
            this.paidAmount = billObject.get(LoadProperties.properties.getString("Bill.Column.PaidAmount")) != null ? billObject.get(LoadProperties.properties.getString("Bill.Column.PaidAmount")).toString() : "null";
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static ArrayList<Bill> createBills (BasicDBObject query) {

        DBCursor cursor = Database.billspaid.find();

        if (query != null) {
            cursor = Database.billspaid.find(query);
        }

        ArrayList<Bill> bills = new ArrayList<>();

        while (cursor.hasNext()) {
            DBObject billDBObject = cursor.next();

            Bill newBill = new Bill(billDBObject);

            bills.add(newBill);

        }

        return bills;
    }

}
