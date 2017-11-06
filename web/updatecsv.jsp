<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="smartcity.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //Use the following checks (full code blocks of if conditions) wherever you want to give access to only authorized users.

    //Checking if the user is logged in to Google
    if (!LoginChecks.isLoggedInGoogle(request)) {
        response.sendRedirect("login.jsp");
    }
    //Checking if the user is NOT authorised from HDMC side.
    //Redirecting to workdetails page because the user is logged in to gmail but is not an authorized user.
    if (!LoginChecks.isSuperUser(request)) {
        session.invalidate();
%>
<script>
    alert("You are not authorised to login. Contact 'inspection.hdmc@gmail.com' to get access.");

</script>
<%
}

//Checking if authorised user is logged in and if true, letting him/her access the page.
else if (LoginChecks.isSuperUser(request)) {
    //String workIDParameter = request.getParameter("workID");

    try {

        String fileName = request.getParameter("fileName");

        if (fileName == null) {
%>
<script>
    alert("Please select a file and hit Update.");
    window.location = "selectcsv.jsp";
</script>
<%
} else {

    String rootFolder;
    if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
        rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataOnWeb");
    } else {
        rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataLocal");
    }

    String filePath = rootFolder + fileName;

    System.out.println("------------#-----------");
    DataEntryDifference.insertUpdateDate();
    List<DataEntryDifference> differences = DataEntryDifference.compareAllWorks(filePath);
    List<Email> emails = Email.getEmailList(differences);
    Alerts.sendEMail(emails);


%>
<script>
    alert("Updated the database successfully! Alert emails have been sent to subscribers.");
    window.location = "selectcsv.jsp";
</script>
<%
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>