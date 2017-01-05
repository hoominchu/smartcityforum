package smartcity;

import com.mongodb.DBCursor;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by minchu on 05/01/17.
 */
public class DataEntryDifference {
    String previousValue;
    String newValue;
    String message;

    public List<DataEntryDifference> compareData (String filePath, String DBCollectionName) {
        List<DataEntryDifference> differences = new ArrayList<>();

        try {
            List<List<String>> CSVLines = CSVUtils.parseCSV(filePath);

            List<String> headerLine = CSVLines.get(0);

            for (int i = 1; i < CSVLines.size(); i++) {
                List<String> currentLine = CSVLines.get(i);
                for (int j = 0; j < currentLine.size(); j++) {
                    String header = headerLine.get(j);
                    String val = currentLine.get(j);
                    
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }


        return differences;
    }
}
