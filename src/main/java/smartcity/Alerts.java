package smartcity;

import com.mongodb.*;
import sun.security.util.PropertyExpander;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * Created by DSV on 30/12/16.
 */
public class Alerts {

    //FIELD 1 ---- WORK ID
    public boolean checkIfSubscribedToField1(String email, int field1) {
        boolean check = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                List<Integer> field1List = (List<Integer>) where.get(LoadProperties.properties.getString("Subscribers.Field1"));
                if (field1List.contains(field1)) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    public void subscribeToField1(String email, int field1) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                BasicDBObject update = new BasicDBObject();
                update.append("$push", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field1"), field1));
                Database.subscribers.update(whereQuery, update);
            } else {
                BasicDBList field1List = new BasicDBList();
                field1List.add(field1);
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.Field1"), field1List);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsubscribeFromField1(String email, int field1) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            BasicDBObject update = new BasicDBObject();
            update.append("$pull", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field1"), field1));
            Database.subscribers.update(whereQuery, update);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    //FIELD 2 ----- WARD NUMBER
    public boolean checkIfSubscribedToField2(String email, int field2) {
        boolean check = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                List<Integer> field2List = (List<Integer>) where.get(LoadProperties.properties.getString("Subscribers.Field2"));
                if (field2List.contains(field2)) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    public void subscribeToField2(String email, int field2) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                BasicDBObject update = new BasicDBObject();
                update.append("$push", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field2"), field2));
                Database.subscribers.update(whereQuery, update);
            } else {
                BasicDBList field2List = new BasicDBList();
                field2List.add(field2);
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.Field2"), field2List);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsubscribeFromField2(String email, int field2) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            BasicDBObject update = new BasicDBObject();
            update.append("$pull", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field2"), field2));
            Database.subscribers.update(whereQuery, update);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //FIELD 3 ---- SOURCE OF INCOME
    public boolean checkIfSubscribedToField3(String email, int field3) {
        boolean check = false;
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                List<Integer> field3List = (List<Integer>) where.get(LoadProperties.properties.getString("Subscribers.Field3"));
                if (field3List.contains(field3)) {
                    check = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return check;
    }

    public void subscribeToField3(String email, int field3) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            DBObject where = Database.subscribers.findOne(whereQuery);
            if (where != null) {
                BasicDBObject update = new BasicDBObject();
                update.append("$push", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field3"), field3));
                Database.subscribers.update(whereQuery, update);
            } else {
                BasicDBList field3List = new BasicDBList();
                field3List.add(field3);
                BasicDBObject document = new BasicDBObject();
                document.append("email", email);
                document.append(LoadProperties.properties.getString("Subscribers.Field3"), field3List);
                Database.subscribers.insert(document);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void unsubscribeFromField3(String email, int field3) {
        try {
            DBObject whereQuery = new BasicDBObject("email", email);
            BasicDBObject update = new BasicDBObject();
            update.append("$pull", new BasicDBObject(LoadProperties.properties.getString("Subscribers.Field3"), field3));
            Database.subscribers.update(whereQuery, update);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void sendEMail(List<Email> emailList) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.socketFactory.port", "465");
        props.put("mail.smtp.socketFactory.class",
                "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.port", "465");

        Session session = Session.getDefaultInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication("email", "password"); //insert email ID and password for authentication
                    }
                });

        try {

            for (Email email : emailList) {

                Message message = new MimeMessage(session);
                message.setFrom(new InternetAddress("from-email@gmail.com")); //insert from email address 
                message.setRecipients(Message.RecipientType.TO,
                        InternetAddress.parse(email.id));
                message.setSubject("Updates: Hubli-Dharwad Smart City Forum");
                message.setText("Hello, \n" + email.message);

                Transport.send(message);

                System.out.println("Done");
            }

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}
