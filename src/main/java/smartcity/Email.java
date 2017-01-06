package smartcity;

import com.mongodb.BasicDBObject;
import com.mongodb.DBCursor;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by DSV on 05/01/17.
 */
public class Email {

    String id;
    String message;

    public Email(String id) {
        this.id = id;
        this.message = "";
    }

    public static List<Email> getEmailList(List<DataEntryDifference> differences) {

        List<String> addedEmailIDs = new ArrayList<>();
        List<Email> emailList = new ArrayList<>();
        try {

            for (DataEntryDifference difference : differences) {
                String fieldID = difference.fieldID;
                String fieldName = difference.fieldName;
                List<String> previousValues = difference.previousValues;
                List<String> newValues = difference.newValues;
                List<String> headers = difference.headers;

                if (fieldName.equals(LoadProperties.properties.getString("Subscribers.Field1"))) {

                    //creating the message for a particular work
                    String workDescription = Work.getWorkDescriptionOfWork(Integer.parseInt(fieldID));
                    String currentMessage = "The following has changed in the work: " + workDescription + "\n";
                    int headersSize = headers.size();
                    for (int i = 0; i < headersSize; i++) {
                        String msg = " - " + headers.get(i) + " has changed from " + previousValues.get(i) + " to " + newValues.get(i);
                        currentMessage += msg + "\n";
                        if (i == headersSize - 1) {
                            currentMessage += "\n";
                        }
                    }

                    //getting all the emails subscribed to the work id and making the email object
                    BasicDBObject whereQuery = new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field1"), Integer.parseInt(fieldID));
                    DBCursor cursor = Database.subscribers.find(whereQuery);
                    while (cursor.hasNext()) {
                        String id = (String) cursor.next().get("email");
                        Email email = new Email(id);
                        if (!addedEmailIDs.contains(id)) {
                            email.message += currentMessage + "\n";
                            emailList.add(email);
                            addedEmailIDs.add(id);
                        } else {
                            for (Email everyEmail : emailList) {
                                if (id.equals(everyEmail.id)) {
                                    email = everyEmail;
                                    break;
                                }
                            }
                            email.message += currentMessage + "\n";
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        //printEmails(emailList);
        return emailList;
    }

    private static void printEmails(List<Email> emailList) {
        for (Email email : emailList) {
            System.out.println(email.id);
            System.out.println(email.message);
            System.out.println("-----------------------------------------");
        }
    }
}
