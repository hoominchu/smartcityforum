<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="smartcity.General" %>
<%@ page import="smartcity.LoginChecks" %>
<%@ page import="smartcity.Work" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
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
%>
<html>
<head>
    <title><%=LoadProperties.properties.getString("Allpages.PageTitle")%>
    </title>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/<%=LoadProperties.properties.getString("FaviconName")%>" type="image/x-icon"/>
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <script src="commonfiles/jquery.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf.css">
    <script src="commonfiles/dropzone.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/dropzone.css"/>
    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

    <script>
        var Dropzone = require("dropzone");
    </script>
</head>
<body>

<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>


<%
    String rootFolder;
    if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
        rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataOnWeb");
    } else {
        rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataLocal");
    }
    File folder = new File(rootFolder);
    File[] listOfFiles = folder.listFiles();
    List<File> csvFiles = new ArrayList<>();
    if (listOfFiles != null) {
        for (File file : listOfFiles) {
            String fileName = file.getName();
            if (fileName.lastIndexOf(".") != -1 && fileName.lastIndexOf(".") != 0) {
                String extension = fileName.substring(fileName.lastIndexOf(".") + 1);
                if (extension.equals("csv")) {
                    csvFiles.add(file);
                }
            }
        }
    }

%>
<center>
    <h3> Please select a csv file: </h3>
    <br/>
    <form action="updatecsv.jsp" method="post">
        <div class="btn-group" data-toggle="buttons">
            <%
                for (File file : csvFiles) {
                    String fileName = file.getName();
            %>
            <label class="btn btn-primary">
                <input type="radio" name="fileName" id="fileName"
                       value="<%=fileName%>"> <%=fileName%>
            </label>
            &nbsp;
            <%="(Last Modified: " + new Date(file.lastModified()) + ")"%>
            <br>
            <br/>
            <%
                }
            %>
        </div>
        <br/>
        <br/>
        <br/>
        <button type="submit" class="btn btn-primary">Update</button>
    </form>
</center>

<%@include file="footer.jsp" %>
<%@include file="contactmodal.jsp" %>

<%
    } catch (Exception e) {
        System.out.println("Error" + e.getMessage());
        System.out.println("Stacktrace -- ");
        e.printStackTrace();
        String redirectURL = "error.jsp";
        response.sendRedirect(redirectURL);
    }
%>
</body>
</html>
<%
    }
%>
