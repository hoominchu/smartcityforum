package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.SystemUtils;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by minchu on 05/01/17.
 */
public class DataEntryDifference {
    String fieldID;
    String fieldName;
    public List<String> previousValues;
    public List<String> newValues;
    public List<String> headers;

    private DataEntryDifference() {

    }

    public DataEntryDifference(String fieldID, String fieldName) {
        this.fieldID = fieldID;
        this.fieldName = fieldName;
        this.headers = new ArrayList<>();
        this.previousValues = new ArrayList<>();
        this.newValues = new ArrayList<>();
    }

    public static List<DataEntryDifference> compareAllWorks(String filePath) {

        //Updating last updated in the database
        DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
        Date date = new Date();
        BasicDBObject currentDate = new BasicDBObject();
        currentDate.put("Date object","true");
        currentDate.put("Last updated date",dateFormat.format(date));
        Database.allworks.insert(currentDate);

        List<DataEntryDifference> differences = new ArrayList<>();

        Map<String, List<String>> wardToWorkOld = new TreeMap<>();
        Map<String, List<String>> sourceOfIncomeToWorkOld = new TreeMap<>();

        Map<String, List<String>> wardToWorkNew = new TreeMap<>();
        Map<String, List<String>> sourceOfIncomeToWorkNew = new TreeMap<>();

        try {
            List<List<String>> CSVLines = CSVUtils.parseCSV(filePath);

            List<String> headerLine = CSVLines.get(0);

            for (int i = 1; i < CSVLines.size(); i++) {
                List<String> currentLine = CSVLines.get(i);
                String workID = currentLine.get(0);
//                System.out.println("%");
//                System.out.println(currentLine);
//                System.out.println("%");
                BasicDBObject query = new BasicDBObject(LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(workID));

                //Inserting the new works
                if (Database.allworks.count(query)<1) {
                    //System.out.println(currentLine);
                    BasicDBObject workObject = new BasicDBObject();

                    List<String> tempForWard = new ArrayList<>(1);

                    if (wardToWorkNew.containsKey(currentLine.get(headerLine.indexOf(LoadProperties.properties.getString("Work.Column.WardNumber"))))) {
                        tempForWard = wardToWorkNew.get(currentLine.get(headerLine.indexOf(LoadProperties.properties.getString("Work.Column.WardNumber"))));
                    }
                    tempForWard.add(workID);
                    wardToWorkNew.put(currentLine.get(headerLine.indexOf(LoadProperties.properties.getString("Work.Column.WardNumber"))),tempForWard);

                    List<String> tempForSOI = new ArrayList<>(1);
//                    System.out.println("*");
//                    System.out.println(headerLine);
//                    System.out.println(currentLine);
//                    System.out.println(headerLine.indexOf(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID")));
//                    System.out.println(currentLine.size());
//                    System.out.println("*");
                    if (sourceOfIncomeToWorkNew.containsKey(currentLine.get(headerLine.indexOf(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"))))) {
                        tempForSOI = sourceOfIncomeToWorkNew.get(currentLine.get(headerLine.indexOf(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"))));
                    }
                    tempForSOI.add(workID);
                    sourceOfIncomeToWorkNew.put(currentLine.get(headerLine.indexOf(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"))),tempForSOI);

                    for (int j = 0; j < currentLine.size(); j++) {

                        try {
                            workObject.put(headerLine.get(j),Integer.parseInt(currentLine.get(j)));
                        } catch (NumberFormatException e) {
                            workObject.put(headerLine.get(j), currentLine.get(j));
                        }
                    }

                    Database.allworks.insert(workObject);
                }
                else {
                    DBObject workObject = Database.allworks.findOne(query);

                    DataEntryDifference dataEntryDifference = new DataEntryDifference(workID, LoadProperties.properties.getString("Subscribers.Field1"));

                    for (int j = 0; j < currentLine.size(); j++) {
                        String header = headerLine.get(j);
                        String newVal = currentLine.get(j);

                        String prevVal = workObject.get(header).toString();
                        String wardNumber = workObject.get(LoadProperties.properties.getString("Work.Column.WardNumber")).toString();
                        String sourceOfIncomeID = workObject.get(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID")).toString();

                        if (!newVal.equals(prevVal)) {
                            dataEntryDifference.previousValues.add(prevVal);
                            dataEntryDifference.newValues.add(newVal);
                            dataEntryDifference.headers.add(header);

                            if (StringUtils.isNumeric(newVal)) {
                                Database.updateDocument(LoadProperties.properties.getString("Database.allWorks"), LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(workID), header, Integer.parseInt(newVal));
                            } else if (!StringUtils.isNumeric(newVal)) {
                                Database.updateDocument(LoadProperties.properties.getString("Database.allWorks"), LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(workID), header, newVal);
                            }

                            List<String> tempForWard = new ArrayList<>();

                            if (wardToWorkOld.containsKey(wardNumber)) {
                                tempForWard = wardToWorkOld.get(wardNumber);
                            }

                            tempForWard.add(workID);
                            wardToWorkOld.put(wardNumber, tempForWard);

                            List<String> tempForSOI = new ArrayList<>();

                            if (sourceOfIncomeToWorkOld.containsKey(sourceOfIncomeID)) {
                                tempForSOI = sourceOfIncomeToWorkOld.get(sourceOfIncomeID);
                            }

                            tempForSOI.add(workID);
                            sourceOfIncomeToWorkOld.put(sourceOfIncomeID, tempForSOI);

                            //System.out.println("Header : " + header + " | Previous value : " + prevVal + " | New value : " + newVal);
                        }

                    }

                    if (dataEntryDifference.headers != null && dataEntryDifference.headers.size() > 0) {
                        differences.add(dataEntryDifference);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        for (Map.Entry<String, List<String>> entry: wardToWorkOld.entrySet()){
            String wardNumber = entry.getKey();
            List<String> worksList = entry.getValue();

            //System.out.println(wardNumber + " : " + worksList);

            DataEntryDifference DED = new DataEntryDifference(wardNumber,LoadProperties.properties.getString("Subscribers.Field2"));
            DED.previousValues = worksList;
            DED.headers.add("-");

            differences.add(DED);
        }

        for (Map.Entry<String, List<String>> entry: sourceOfIncomeToWorkOld.entrySet()){
            String sourceOfIncomeID = entry.getKey();
            List<String> worksList = entry.getValue();

            DataEntryDifference DED = new DataEntryDifference(sourceOfIncomeID,LoadProperties.properties.getString("Subscribers.Field3"));
            DED.previousValues = worksList;
            DED.headers.add("-");

            differences.add(DED);
        }

        for (Map.Entry<String, List<String>> entry: wardToWorkNew.entrySet()){
            String wardNumber = entry.getKey();
            List<String> worksList = entry.getValue();

            //System.out.println(wardNumber + " : " + worksList);

            DataEntryDifference DED = new DataEntryDifference(wardNumber,LoadProperties.properties.getString("Subscribers.Field2"));

            if (differences.contains(DED)) {
                DED = differences.get(differences.indexOf(DED));
            }

            DED.newValues = worksList;
            DED.headers.add("-");

            differences.add(DED);
        }

        for (Map.Entry<String, List<String>> entry: sourceOfIncomeToWorkNew.entrySet()){
            String sourceOfIncomeID = entry.getKey();
            List<String> worksList = entry.getValue();

            DataEntryDifference DED = new DataEntryDifference(sourceOfIncomeID,LoadProperties.properties.getString("Subscribers.Field3"));

            if (differences.contains(DED)) {
                DED = differences.get(differences.indexOf(DED));
            }

            DED.newValues = worksList;
            DED.headers.add("-");

            differences.add(DED);
        }

        return differences;
    }

    @Override
    public boolean equals(Object obj) {
        return (this.fieldID.equals(((DataEntryDifference) obj).fieldID) && this.fieldName.equals(((DataEntryDifference) obj).fieldName));
    }

    @Override
    public int hashCode() {
        return this.fieldID.hashCode() + this.fieldName.hashCode();
    }

    public static void insertUpdateDate(){
        DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
        Date date = new Date();
        BasicDBObject currentDate = new BasicDBObject();
        currentDate.put("Date object","true");
        currentDate.put("Last updated date",dateFormat.format(date));
        Database.allworks.insert(currentDate);
    }
}
