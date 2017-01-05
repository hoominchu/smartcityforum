package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by minchu on 05/01/17.
 */
public class DataEntryDifference {
    String fieldID;
    String fieldName;
    List<String> previousValues;
    List<String> newValues;
    List<String> headers;

    private DataEntryDifference() {

    }

    private DataEntryDifference(String fieldID, String fieldName) {
        this.fieldID = fieldID;
        this.fieldName = fieldName;
        this.headers = new ArrayList<>();
        this.previousValues = new ArrayList<>();
        this.newValues = new ArrayList<>();
    }

    public static List<DataEntryDifference> compareData(String filePath) {
        List<DataEntryDifference> differences = new ArrayList<>();

        try {
            List<List<String>> CSVLines = CSVUtils.parseCSV(filePath);

            List<String> headerLine = CSVLines.get(0);

            for (int i = 1; i < CSVLines.size(); i++) {
                List<String> currentLine = CSVLines.get(i);
                String workID = currentLine.get(0);
                BasicDBObject query = new BasicDBObject(LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(workID));
                DBObject workObject = Database.allworks.findOne(query);

                DataEntryDifference dataEntryDifference = new DataEntryDifference(workID, "Work");

                for (int j = 0; j < currentLine.size(); j++) {
                    String header = headerLine.get(j);
                    String newVal = currentLine.get(j);

                    String prevVal = workObject.get(header).toString();

                    if (!newVal.equals(prevVal)) {
                        dataEntryDifference.previousValues.add(prevVal);
                        dataEntryDifference.newValues.add(newVal);
                        dataEntryDifference.headers.add(header);

                        System.out.println("Header : " + header + " | Previous value : " + prevVal + " | New value : " + newVal);
                    }

                }

                if (dataEntryDifference.headers != null && dataEntryDifference.headers.size() > 0) {
                    differences.add(dataEntryDifference);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }


        return differences;
    }
}
