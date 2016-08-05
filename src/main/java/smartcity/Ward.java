package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.util.ArrayList;

public class Ward {

    private int wardNumber;
    private String corporator;
    private int population;
    private int capitalWorks;
    private int maintenanceWorks;
    private int emergencyWorks;
    private int totalWorks;
    private int inprogressWorks;
    private int completedWorks;
    private int amountSpent;

    private final static Ward[] allwards = new Ward[(int) Database.wardmaster.count()];
    final private static int physicalWards = 67;

    /**
     * Constructor method for class Ward
     */
    public Ward(DBObject object) {
        try {
            this.wardNumber = object.get(LoadProperties.properties.getString("Ward.Column.WardNumber")) != null ? (int) object.get(LoadProperties.properties.getString("Ward.Column.WardNumber")) : 0;

        } catch (Exception e) {
            System.err.println(e.getClass().getName() + " : " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Creates static array of all the ward objects from wardmaster collection in the database.
     */
    public static void createAllWardObjects(ArrayList<Work> works) {

        //Sets up all the ward objects from the database.
        DBCursor cursor = Database.wardmaster.find();
        DBObject sortBy = new BasicDBObject();
        sortBy.put(LoadProperties.properties.getString("Ward.Column.WardNumber"), 1);
        cursor.sort(sortBy);
        int i = 0;
        try {
            while (cursor.hasNext()) {
                DBObject wardDBObject = cursor.next();
                allwards[i] = new Ward(wardDBObject);
                i++;
            }
        }
        catch (Exception e){
            e.printStackTrace();
            System.err.println(e.getMessage());
        }
        cursor.close();


        //Setting up fields for physical wards as there are some extra wards used for departments for which parameters like population, corporator are irrelevant.

        cursor = Database.wardmaster.find();
        cursor.sort(sortBy);
        i = 0;

        while (cursor.hasNext()) {
            if (i < physicalWards) {
                try {
                    DBObject wardDBObject = cursor.next();
                    allwards[i].corporator = wardDBObject.get(LoadProperties.properties.getString("Ward.Column.CorporatorNameEnglish")) != null ? wardDBObject.get(LoadProperties.properties.getString("Ward.Column.CorporatorNameEnglish")).toString() : "null";
                    allwards[i].population = wardDBObject.get(LoadProperties.properties.getString("Ward.Column.Population")) != null ? (int) wardDBObject.get(LoadProperties.properties.getString("Ward.Column.Population")) : 0;
                    i++;
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println(e.getMessage());
                }
            } else {
                break;
            }

        }

        //Calculating the number of works, amount spent in every ward and storing it in the objects.

        //Counts all the works (in progress, completed and total) and ward-wise expenditure and stores them in the object.
        //Work[] allworks = Work.createWorkObjects(new BasicDBObject());

        //System.out.println(Work.allWorks.length);
        //System.out.println(allwards.length);

        try {
            for (Ward tempWard : allwards) {
                for (Work tempWork : works) {

                    if (tempWork.wardNumber == tempWard.wardNumber) {

                        //Counts capital works
                        if (tempWork.workType.equalsIgnoreCase("Capital")){
                            tempWard.capitalWorks++;

                        }

                        //Counts maintenance works
                        else if (tempWork.workType.equalsIgnoreCase("Maintenance")){
                            tempWard.maintenanceWorks++;

                        }

                        //Counts emergency works
                        else if (tempWork.workType.equalsIgnoreCase("Emergency")){
                            tempWard.emergencyWorks++;

                        }


                        //Counts the number of in progress and completed works for every ward.
                        if (tempWork.statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusCompleted"))) {
                            tempWard.completedWorks++;
                        } else if (tempWork.statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusInprogress"))) {
                            tempWard.inprogressWorks++;
                        }
                        tempWard.totalWorks++;
                        //Updates the amount spent in every ward.
                        tempWard.amountSpent = tempWard.amountSpent + tempWork.amountSanctioned;
                    }

                }

            }
        }
        catch (Exception e){
            e.printStackTrace();
            System.out.println(e.getMessage());
        }

    }

    public static String[] getWardDetails(){
        String[] wardDetails = new String[7];

        String allWardNumbersString = "";
        String allWardsAmountSpent = "";
        String allWardsTotalWorks = "";
        String allWardsCapitalWorks = "";
        String allWatdsMaintenanceWorks = "";
        String allWardsEmergencyWorks = "";
        String allWardsCompletedWorks = "";
        String allWardsInprogressWorks = "";
        String allWardsPopulation = "";
        String allWardsPerCapitaExpenditure = "";

        for (int i = 0; i < 67; i++) {
            allWardNumbersString = allWardNumbersString + allwards[i].wardNumber + ",";
            allWardsAmountSpent = allWardsAmountSpent + allwards[i].amountSpent + ",";
            allWardsTotalWorks = allWardsTotalWorks + allwards[i].totalWorks + ",";
            allWardsCompletedWorks = allWardsCompletedWorks + allwards[i].completedWorks + ",";
            allWardsInprogressWorks = allWardsInprogressWorks + allwards[i].inprogressWorks + ",";
            allWardsPopulation = allWardsPopulation + allwards[i].population + ",";
            allWardsCapitalWorks = allWardsCapitalWorks + allwards[i].capitalWorks + ",";
            allWatdsMaintenanceWorks = allWatdsMaintenanceWorks + allwards[i].maintenanceWorks + ",";
            allWardsEmergencyWorks = allWardsEmergencyWorks + allwards[i].emergencyWorks + ",";

            if (allwards[i].population > 0) {
                allWardsPerCapitaExpenditure = allWardsPerCapitaExpenditure + (allwards[i].amountSpent / allwards[i].population) + ",";
            }

            else {
                allWardsPerCapitaExpenditure = allWardsPerCapitaExpenditure + "0,";
            }

        }

        wardDetails[0] = allWardNumbersString;
        wardDetails[1] = allWardsAmountSpent;
        wardDetails[2] = allWardsTotalWorks;
        wardDetails[3] = allWardsCompletedWorks;
        wardDetails[4] = allWardsInprogressWorks;
        wardDetails[5] = allWardsPopulation;
        wardDetails[6] = allWardsPerCapitaExpenditure;

        for (int i = 0; i < 7; i++) {
            wardDetails[i] = wardDetails[i].substring(0,wardDetails[i].length()-1);
        }

        return wardDetails;
    }

    public static String[] getWardInfo (int wardNumber) {
        String[] wardInfo = new String[5];

        BasicDBObject query = new BasicDBObject(LoadProperties.properties.getString("Ward.Column.WardNumber"),wardNumber);
        DBCursor cursor = Database.wardmaster.find(query);

        while (cursor.hasNext()) {
            DBObject ward = cursor.next();
            wardInfo[0] = ward.get(LoadProperties.properties.getString("Ward.Column.WardNumber")) != null ? ward.get(LoadProperties.properties.getString("Ward.Column.WardNumber")).toString() : "null";
            wardInfo[1] = ward.get(LoadProperties.properties.getString("Ward.Column.CorporatorNameEnglish")) != null ? ward.get(LoadProperties.properties.getString("Ward.Column.CorporatorNameEnglish")).toString() : "null";
            wardInfo[2] = ward.get(LoadProperties.properties.getString("Ward.Column.CorporatorNameLang2")) != null ? ward.get(LoadProperties.properties.getString("Ward.Column.CorporatorNameLang2")).toString() : "null";
            wardInfo[3] = ward.get(LoadProperties.properties.getString("Ward.Column.WardMeaning")) != null ? ward.get(LoadProperties.properties.getString("Ward.Column.WardMeaning")).toString() : "null";
            wardInfo[4] = ward.get(LoadProperties.properties.getString("Ward.Column.Population")) != null ? ward.get(LoadProperties.properties.getString("Ward.Column.Population")).toString() : "null";
        }

        return wardInfo;
    }

}
