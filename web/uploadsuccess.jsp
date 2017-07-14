<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 28/06/16
  Time: 11:39 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    try {
        String workIDParameter = request.getParameter("workID");
%>
<html>
<head>
    <title><%=LoadProperties.properties.getString("Allpages.PageTitle")%></title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/<%=LoadProperties.properties.getString("FaviconName")%>" type="image/x-icon"/>
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <script src="commonfiles/jquery.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="commonfiles/scf-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf.css">
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

</head>
<body>

<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">
</div>
<div class="row" style="text-align: center; margin-bottom: 17%">
    <%
        try {
            String numberOfFiles = request.getParameter("number-of-files");
    %>
    <h3>You have successfully uploaded file/s. <a href="upload.jsp?workID=<%=workIDParameter%>"> Click here </a> to
        upload more.</h3>
    <br>
    <br>
    <h3><a href="workDetails.jsp?workID=<%=workIDParameter%>&jumbotron=info"> Click here </a> to go the work page.</h3>
    <%
        } catch (Exception e) {
            System.out.println("Error message " + e.getMessage());
            System.out.println("Cause " + e.getCause());
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    %>
</div>
<script>
    function logoutAlert() {
        var r = confirm("You will be logged out of Gmail on all the windows. Do you want to continue?");
        if (r == true) {
            window.location = "https://mail.google.com/mail/u/0/?logout&hl=en";
        }
    }
</script>

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
