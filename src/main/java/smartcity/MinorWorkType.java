package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.util.ArrayList;
import java.util.Comparator;

public class MinorWorkType {
    private int totalWorks, completedWorks, inprogressWorks;
    private int code;
    private int amountSpent;
    private String meaning;

    private MinorWorkType (int code, String meaning) {
        this.code = code;
        this.meaning = meaning;
    }

    final private static Comparator<MinorWorkType> compareMinorWorkType = new Comparator<MinorWorkType>() {
        @Override
        public int compare(MinorWorkType w1, MinorWorkType w2) {
            int val;
            if (w1.code>w2.code) {
                val = 1;
            }
            else {
                val = -1;
            }
            return val;
        }
    };

    public static ArrayList<MinorWorkType> createMinorWorkTypes (BasicDBObject query) {

        ArrayList<MinorWorkType> allMinorWorkTypes = new ArrayList<>();
        DBCursor cursor = Database.minorWorkTypes.find();

        while (cursor.hasNext()) {
            DBObject minorWorkType = cursor.next();
            int code = minorWorkType.get(LoadProperties.properties.getString("MinorWorkType.Column.Code")) != null ? (int) minorWorkType.get(LoadProperties.properties.getString("MinorWorkType.Column.Code")) : 0;
            String meaning = minorWorkType.get(LoadProperties.properties.getString("MinorWorkType.Column.Meaning")) != null ? minorWorkType.get(LoadProperties.properties.getString("MinorWorkType.Column.Meaning")).toString() : "null";
            MinorWorkType temp = new MinorWorkType(code,meaning);
            allMinorWorkTypes.add(temp);
        }

        ArrayList<Work> selectedWorks = Work.createWorkObjects(query);

        for (Work tempwork : selectedWorks) {
            for (MinorWorkType tempMinorWorkType : allMinorWorkTypes) {
                if (Integer.parseInt(tempwork.minorWorkTypeID) == tempMinorWorkType.code) {
                    tempMinorWorkType.totalWorks++;
                    tempMinorWorkType.amountSpent = tempMinorWorkType.amountSpent + tempwork.amountSanctioned;

                    if (tempwork.statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusCompleted"))) {
                        tempMinorWorkType.completedWorks++;
                    }
                    else if (tempwork.statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusInprogress"))) {
                        tempMinorWorkType.inprogressWorks++;
                    }
                }

                tempMinorWorkType.amountSpent = Math.abs(tempMinorWorkType.amountSpent);
            }
        }

        allMinorWorkTypes.sort(compareMinorWorkType);
        return allMinorWorkTypes;
    }

    public static String[] getMinorWorkTypeDetails (ArrayList<MinorWorkType> minorWorkTypes) {
        String[] minorWorkDetails = new String[5];
        for (int i = 0; i < 5; i++) {
            minorWorkDetails[i] = "";
        }

        for (MinorWorkType minorWorkType : minorWorkTypes) {

            //List of meanings for X-axis
            minorWorkDetails[0] = minorWorkDetails[0] + "'" + minorWorkType.meaning +"'"+ ",";

            minorWorkDetails[1] = minorWorkDetails[1] + minorWorkType.completedWorks + ",";
            minorWorkDetails[2] = minorWorkDetails[2] + minorWorkType.inprogressWorks + ",";
            minorWorkDetails[3] = minorWorkDetails[3] + minorWorkType.totalWorks + ",";
            minorWorkDetails[4] = minorWorkDetails[4] + minorWorkType.amountSpent + ",";
        }

        return minorWorkDetails;
    }
}
