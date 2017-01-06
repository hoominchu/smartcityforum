package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.List;

public class Work implements Comparable<Work> {

    public String workObjectID;
    public int wardNumber;
    public String workDescriptionEnglish;
    public String workDescriptionKannada;
    public String workDescriptionFinal;
    public String workOrderDate;
    public String workCompletionDate;
    public String workType;
    public String contractor;
    public String amountSanctionedString;
    public int amountSanctioned;
    public String statusFirstLetterSmall;
    public String statusfirstLetterCapital;
    public String workID;
    public String workTypeID;
    public String contractorID;
    public String sourceOfIncomeID;
    public String sourceOfIncome;
    public String statusColor;
    public String year;
    public boolean doWorkDetailsExist;
    public int billPaid;
    public String tenderApprovalDate;
    public String minorWorkTypeID;
    public String minorIDMeaning;

    public static ArrayList<Work> allWorks = createWorkObjects(new BasicDBObject());

    //Constructor method for class work
    public Work(DBObject workObject) {

        try {

            this.wardNumber = (workObject.get(LoadProperties.properties.getString("Work.Column.WardNumber")) != null) ? (int) workObject.get(LoadProperties.properties.getString("Work.Column.WardNumber")) : 0;
            this.workDescriptionEnglish = (workObject.get(LoadProperties.properties.getString("Work.Column.WorkDescriptionEnglish")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.WorkDescriptionEnglish")).toString() : "null";
            this.workDescriptionKannada = (workObject.get(LoadProperties.properties.getString("Work.Column.WorkDescriptionLocalLanguage")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.WorkDescriptionLocalLanguage")).toString() : "null";
            this.workDescriptionFinal = null;
            this.workOrderDate = (workObject.get(LoadProperties.properties.getString("Work.Column.WorkOrderDate")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.WorkOrderDate")).toString() : "null";
            this.workCompletionDate = (workObject.get(LoadProperties.properties.getString("Work.Column.WorkCompletionDate")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.WorkCompletionDate")).toString() : "null";
            this.workType = (workObject.get(LoadProperties.properties.getString("Work.Column.WorkType")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.WorkType")).toString() : "null";
            this.sourceOfIncome = (workObject.get(LoadProperties.properties.getString("Work.Column.SourceOfFinance")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.SourceOfFinance")).toString() : "null";
            this.contractor = (workObject.get(LoadProperties.properties.getString("Work.Column.Contractor")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.Contractor")).toString() : "null";
            this.amountSanctionedString = (workObject.get(LoadProperties.properties.getString("Work.Column.AmountSanctioned")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.AmountSanctioned")).toString() : "0.0";
            //Converting string to integer with commas
            Double temp = Double.parseDouble(amountSanctionedString);
            this.amountSanctioned = temp.intValue();
            //IndianCurrencyFormat.format(Double.parseDouble(amountSanctionedString));
            this.billPaid = (workObject.get(LoadProperties.properties.getString("Work.Column.TotalBillAmountPaid")) != null) ? (int) workObject.get(LoadProperties.properties.getString("Work.Column.TotalBillAmountPaid")) : 0;
            this.year = (workObject.get(LoadProperties.properties.getString("Work.Column.Year")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.Year")).toString() : "null";
            this.statusFirstLetterSmall = (workObject.get(LoadProperties.properties.getString("Work.Column.Status")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.Status")).toString() : "null";
            this.statusfirstLetterCapital = General.capitalizeFirstLetter(this.statusFirstLetterSmall);

            //Values for backend
            this.workID = (workObject.get(LoadProperties.properties.getString("Work.Column.WorkID")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.WorkID")).toString() : "null";
            this.workTypeID = (workObject.get(LoadProperties.properties.getString("Work.Column.WorkTypeID")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.WorkTypeID")).toString() : "null";
            this.contractorID = (workObject.get(LoadProperties.properties.getString("Work.Column.ContractorID")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.ContractorID")).toString() : "null";
            this.sourceOfIncomeID = (workObject.get(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID")).toString() : "null";
            this.tenderApprovalDate = (workObject.get(LoadProperties.properties.getString("Work.Column.TenderApprovalDate")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.TenderApprovalDate")).toString() : "null";
            this.minorWorkTypeID = (workObject.get(LoadProperties.properties.getString("Work.Column.MinorWorkTypeID")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.MinorWorkTypeID")).toString() : "null";
            this.minorIDMeaning = (workObject.get(LoadProperties.properties.getString("Work.Column.MinorWorkTypeIDMeaning")) != null) ? workObject.get(LoadProperties.properties.getString("Work.Column.MinorWorkTypeIDMeaning")).toString() : "null";

            this.doWorkDetailsExist = (workObject.get(LoadProperties.properties.getString("Work.Column.AreWorkDetails")) != null) && workObject.get(LoadProperties.properties.getString("Work.Column.AreWorkDetails")).toString().equalsIgnoreCase("TRUE");

            if (this.statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusCompleted"))) {
                this.statusColor = "43ac6a";
            } else if (this.statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusInprogress"))) {
                this.statusColor = "#FFA44B";
            } else {
                this.statusColor = "#FFFFFF";
            }

        } catch (Exception e) {
            System.err.println("Exception in Work.java");
            e.printStackTrace();
            System.err.println(e.getClass().getName() + " : " + e.getMessage());
        }
    }

    @Override
    public boolean equals(Object obj) {

        if (obj == null) {
            return false;
        }

        Work w = (Work) obj;

        return (w.workID.equals(this.workID));
    }

    @Override
    public int hashCode() {
        return this.workID.hashCode();
    }


    /**
     * Creates all the work objects based on the database query given as argument. Returns an arraylist of Works
     *
     * @param query
     * @return
     */
    public static ArrayList<Work> createWorkObjects(BasicDBObject query) {

        DBCursor cursor = Database.allworks.find();
        if (query != null) {
            cursor = Database.allworks.find(query);
        }
        ArrayList<Work> works = new ArrayList<>();

        while (cursor.hasNext()) {
            DBObject workDBObject = cursor.next();
            Work newWork = new Work(workDBObject);
            works.add(newWork);
        }
        return works;
    }

    public static Work getWork(String workID) {
        BasicDBObject query = new BasicDBObject();
        query.append(LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(workID));
        DBCursor cursor = Database.allworks.find(query);

        Work work = null;

        while (cursor.hasNext()) {
            DBObject workObject = cursor.next();
            work = new Work(workObject);
        }

        return work;
    }

    public int compareTo(Work compareWork) {

        int compareQuantity = Integer.parseInt(compareWork.workTypeID);

        //ascending order
        return Integer.parseInt(this.workTypeID) - compareQuantity;
    }

    public static ArrayList<Work> getRecentWorks() {
        BasicDBObject query = new BasicDBObject();
        List<Work> works = Work.createWorkObjects(query);

        List<Work> recentWorksList = works.subList(0, 500);

        ArrayList<Work> recentWorks = new ArrayList<>(recentWorksList);

        return recentWorks;
    }

    public static boolean doesFileExist(String filePath, String fileType) {
        File dir = new File(filePath);
        File[] directoryContents = dir.listFiles();
        if (directoryContents != null) {
            for (File singleFile : directoryContents) {
                if (singleFile.isFile() && singleFile.getName().toLowerCase().endsWith(fileType.toLowerCase())) {
                    return true;
                }
            }
        }
        return false;
    }

    public static String getWorkDescriptionOfWork(int workID) {
        DBObject whereQuery = new BasicDBObject(LoadProperties.properties.getString("Work.Column.WorkID"), workID);
        DBObject where = Database.allworks.findOne(whereQuery);
        String description = "";
        if (where != null) {
            description = (String) where.get(LoadProperties.properties.getString("Work.Column.WorkDescriptionEnglish"));
        }
        return description;
    }
}
