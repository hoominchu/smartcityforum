<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 27/06/16
  Time: 10:50 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Sorry!</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/<%=LoadProperties.properties.getString("FaviconName")%>" type="image/x-icon"/>
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <link rel="stylesheet" href="commonfiles/custom.min.css">
    <link rel="stylesheet" href="commonfiles/bootstrap-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf.css">
    <script src="commonfiles/jquery.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <script src="commonfiles/addons.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
</head>
<body>

<%@include file="navbar.jsp" %>

<%@include file="header.jsp" %>

<div class="container">
    <h3 style="width: 100%; text-align: center; padding-top: 11%; min-height: 54%"><b class="text-danger"><i
            class="fa fa-exclamation-circle" aria-hidden="true"></i> &nbsp;Sorry, </b> we encountered an error. We'll
        fix it as soon as possible! <br><br>
        Go to <a href="index.jsp" class="text-primary">home page</a>.</h3>
</div>

<%@include file="footer.jsp" %>
<%@include file="contactmodal.jsp" %>

</body>
</html>
