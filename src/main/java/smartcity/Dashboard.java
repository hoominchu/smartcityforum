package smartcity;

import com.mongodb.BasicDBObject;

/**
 * Created by minchu on 16/06/16.
 */
public class Dashboard {

    public static String[] workStatusPieChart (BasicDBObject query) {
        String[] pieChartInput = new String[2];

        String completedWorks = String.valueOf(Database.allworks.find(query.append(LoadProperties.properties.getString("Work.Column.Status"),LoadProperties.properties.getString("StatusCompleted"))).count());
        String inprogressWorks = String.valueOf(Database.allworks.find(query.append(LoadProperties.properties.getString("Work.Column.Status"),LoadProperties.properties.getString("StatusInprogress"))).count());

        pieChartInput[0] = completedWorks;
        pieChartInput[1] = inprogressWorks;

        return pieChartInput;
    }
}
