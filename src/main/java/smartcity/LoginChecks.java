package smartcity;

import com.mongodb.BasicDBObject;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class LoginChecks {

    public static boolean isLoggedInGoogle(HttpServletRequest request) {
        Boolean isLoggedIn = false;
        try {
            HttpSession session = request.getSession(false);

            //Checking is HttpSession has attribute email. This will be stored via OAuth if the user has logged in.
            if (session.getAttribute("email") != null) {
                isLoggedIn = true;
            }
        } catch (Exception e) {
            System.out.println("Error in checking if user is logged in to Google in LoginChecks.java");
            System.out.println("Error message : " + e.getMessage());
            System.out.println("Cause : " + e.getCause());
            e.printStackTrace();
        }
        return isLoggedIn;
    }

    public static boolean isAuthorisedUser(HttpServletRequest request) {
        Boolean shouldLetCheckIn = false;

        try {
            HttpSession session = request.getSession(false);

            //Getting the email string from HttpSession.
            String email = session.getAttribute("email").toString();

            //Checking if HttpSession has the attribute email.
            if (email != null) {

                //Checking if the email exists in DB collection 'authorizedEmails'.
                Long numberOfEntries = Database.authorizedEmails.count(new BasicDBObject(LoadProperties.properties.getString("Users.Column.Email"), email));
                if (numberOfEntries > 0) {
                    shouldLetCheckIn = true;
                }

            }

        } catch (Exception e) {
            System.out.println("Error in LoginChecks.java");
            System.out.println("Message : " + e.getMessage());
            System.out.println("Cause : " + e.getMessage());
            e.printStackTrace();
        }
        return shouldLetCheckIn;
    }

    public static boolean isSuperUser(HttpServletRequest request) {
        Boolean retVal = false;
        try {
            HttpSession session = request.getSession(false);

            //Getting the email string from HttpSession.
            String email = session.getAttribute("email").toString();

            //Checking if HttpSession has the attribute email.
            if (email != null) {

                //Checking if the email exists in DB collection 'authorizedEmails'.
                Long numberOfEntries = Database.superUsers.count(new BasicDBObject(LoadProperties.properties.getString("Users.Column.Email"), email));
                if (numberOfEntries > 0) {
                    retVal = true;
                }

            }

        } catch (Exception e) {
            System.out.println("Error in LoginChecks.java");
            System.out.println("Message : " + e.getMessage());
            System.out.println("Cause : " + e.getMessage());
            e.printStackTrace();
        }
        return retVal;
    }
}
