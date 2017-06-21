<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="smartcity.General" %>
<%@ page import="smartcity.LoginChecks" %>
<%@ page import="smartcity.Work" %>
<%@ page import="java.util.ArrayList" %>
<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 27/06/16
  Time: 5:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    //Use the following checks (full code blocks of if conditions) wherever you want to give access to only authorized users.

    //Checking if the user is logged in to Google
    if (!LoginChecks.isLoggedInGoogle(request)) {
        response.sendRedirect("logincsv.jsp");
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
    <title><%=LoadProperties.properties.getString("Allpages.PageTitle")%></title>
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

<div class="container">


    <div class="row">
        <form name="csv-dropped" action="uploadcsvscript.jsp"
              class="dropzone round-corner pull-left"
              style="border: dashed 4px darkgrey; height: 25em; display: inline-block; width: 100%; overflow:auto" id="filesDropzone"
              method="post"
              enctype="multipart/form-data">
        </form>

    </div>

    <button class="btn btn-default round-corner" style="margin-left: 46%" onclick="submitfiles()">Upload</button>


</div>
<script>
    function logoutAlert() {
        var r = confirm("You will be logged out of Gmail on all the windows. Do you want to continue?");
        if (r == true) {
            window.location = "https://mail.google.com/mail/u/0/?logout&hl=en";
        }
    }

    function submitfiles() {
        document.getElementById("filesDropzone").submit();
        var count = Dropzone.files.length.toString();
    }

    Dropzone.options.filesDropzone = {
        dictDefaultMessage: "<i class=\"fa fa-table fa-5\" style='font-size: 20pt' aria-hidden=\"true\"></i> &nbsp; Drag and drop your <b class='text-primary'>CSV files</b> here or click here to browse...",
        acceptedFiles: ".csv,.zip,.gzip"
    };

</script>
<form action="uploadsuccesscsv.jsp" method="post" id="numOfFilesForm">
    <input type="hidden" name="number-of-files" id="number-of-files">
</form>

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
