package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.math.BigDecimal;
import java.util.ArrayList;

public class WorkDetails {

    public String stepNumber;
    public String workStep;
    public String measurement;
    public String unit;
    public String rate;

    public Double totalAmount;
    public Double truncatedTotal;
    public String totalAmountString;

    private WorkDetails (DBObject workDetailsObject) {

        this.stepNumber = workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Step")) != null ? workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Step")).toString() : "null";
        this.workStep = workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Details")) != null ? workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Details")).toString() : "null";
        this.measurement = workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Measurement")) != null ? workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Measurement")).toString() : "null";
        this.unit = workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Unit")) != null ? workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Unit")).toString() : "null";
        this.rate = workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Rate")) != null ? workDetailsObject.get(LoadProperties.properties.getString("WorkDetails.Column.Rate")).toString() : "null";

        this.totalAmount = (Double.parseDouble(measurement)) * (Double.parseDouble(rate));
        this.truncatedTotal = new BigDecimal(totalAmount).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
        this.totalAmountString = truncatedTotal.toString();

    }

    public static ArrayList<WorkDetails> createWorkDetails (BasicDBObject query) {
        DBCursor cursor = Database.workDetails.find();

        if (query != null) {
            cursor = Database.workDetails.find(query);
        }

        ArrayList<WorkDetails> workDetails = new ArrayList<>();

        while (cursor.hasNext()) {
            DBObject workDetailDBObject = cursor.next();

            WorkDetails newWorkDetail = new WorkDetails(workDetailDBObject);

            workDetails.add(newWorkDetail);

        }

        return workDetails;
    }
}
