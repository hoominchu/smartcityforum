package smartcity;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * Created by minchu on 21/04/16.
 */
public class Contractor {

    public String ID;
    public String name;
    public int inprogressWorks;
    public int completedWorks;
    public int totalWorks;
    //public String[] typesOfWorksDone;
    public String linkToPersonalWebpage;
    public String address;
    public String emailID;
    public String phoneNumber;
    public int totalContractAmount;

    public static List<Contractor> contractors;

    public Contractor (String newID, String newName){
        this.ID = newID;
        this.name = newName;
    }

    @Override
    public boolean equals(Object obj) {

        if (obj == null) {
            return false;
        }

        Contractor c = (Contractor) obj;

        return (c.ID.equals(this.ID));
    }

    @Override
    public int hashCode(){
        return this.ID.hashCode();
    }

    /**
     * Creates all the contractor objects and sorts them based on the contract amount.
     */
    public static void createContractors() {

        Set<Contractor> contractorsSet = new HashSet<Contractor>();

        try {
            for (int i = 0; i < Work.allWorks.size(); i++) {
                Contractor c = new Contractor(Work.allWorks.get(i).contractorID, Work.allWorks.get(i).contractor);
                contractorsSet.add(c);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }

        contractors = new ArrayList(contractorsSet);

        for (int i = 0; i < Work.allWorks.size(); i++) {

            for (Contractor c : contractors) {
                if (Work.allWorks.get(i).contractorID.equals(c.ID)) {

                    //Adding amount to the contractor.
                    c.totalContractAmount = c.totalContractAmount + Work.allWorks.get(i).amountSanctioned;

                    //Adding to thr number of works of the contractor.
                    c.totalWorks++;

                    //Checking the status of the work and adding it to the relevant field.
                    if (Work.allWorks.get(i).statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusCompleted"))) {
                        c.completedWorks++;
                    } else if (Work.allWorks.get(i).statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusInprogress"))) {
                        c.inprogressWorks++;
                    }
                }
            }
        }

        Stream<Contractor> stream = contractors.stream();
        contractors = stream.sorted(compareContractorByAmount).collect(Collectors.<Contractor>toList());

        //Collections.sort(contractors, compareContractorByAmount);

    }

    /**
     * Returns the string of the names of top 50 contractors.
     * @return
     */
    public static String getTop50ContractorsNames(){

        String top50ContractorNames = "";

        for (int i = 0; i < 50; i++){
            top50ContractorNames = top50ContractorNames + "'" + contractors.get(i).name + "'" + ",";
        }

        return top50ContractorNames;
    }

    /**
     * Returns the string of the contract amounts of top 50 contractors.
     * @return
     */
    public static String getTop50ContractorsAmount(){

        String top50ContractorAmount = "";

        for (int i = 0; i < 50; i++){
            top50ContractorAmount = top50ContractorAmount + contractors.get(i).totalContractAmount + ",";
        }

        return top50ContractorAmount;
    }

    /**
     * Returns the string of the number of works of top 50 contractors.
     * @return
     */
    public static String getTop50ContractorsTotalWorks(){

        String top50ContractorTotalWorks = "";

        for (int i = 0; i < 50; i++){
            top50ContractorTotalWorks = top50ContractorTotalWorks + contractors.get(i).totalWorks + ",";
        }

        return top50ContractorTotalWorks;
    }

    /**
     * Returns the string of the number of inprogress works of top 50 contractors.
     * @return
     */
    public static String getTop50ContractorsInprogressWorks(){

        String top50ContractorInprogressWorks = "";

        for (int i = 0; i < 50; i++){
            top50ContractorInprogressWorks = top50ContractorInprogressWorks + contractors.get(i).inprogressWorks + ",";
        }

        return top50ContractorInprogressWorks;
    }

    /**
     * Returns the string of the number of completed works of top 50 contractors.
     * @return
     */
    public static String getTop50ContractorsCompletedWorks(){

        String top50ContractorCompletedWorks = "";

        for (int i = 0; i < 50; i++){
            top50ContractorCompletedWorks = top50ContractorCompletedWorks + contractors.get(i).completedWorks + ",";
        }

        return top50ContractorCompletedWorks;
    }

    public static List<String> getAllContractorNames () {
        List<String> names = (List<String>) Database.allworks.distinct("Contractor");
        return names;
    }

    /**
     * Custom method to compare two contractors based on their contract amount.
     */
    final private static Comparator<Contractor> compareContractorByAmount = new Comparator<Contractor>() {
        @Override
        public int compare(Contractor o1, Contractor o2) {

            int val;
            if (o1.totalContractAmount < o2.totalContractAmount){
                val = 1;
            }

            else if(o1.totalContractAmount > o2.totalContractAmount){
                val = -1;
            }

            else {
                val = 0;
            }

            return val;
        }
    };
}