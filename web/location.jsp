<%@ page import="org.apache.commons.lang3.math.NumberUtils" %>
<%@ page import="smartcity.Geolocation" %>
<%@ page import="smartcity.LoadProperties" %><%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
%>

<%
    String referer = request.getHeader("referer");
    if (referer.contains("workDetails.jsp")) {
        //For adding location
        if (request.getParameter("lat") != null) {
            Geolocation.addLocationToWork(request);
            response.sendRedirect(referer);
        }
        //For deleting location
        else {
            String workID = request.getParameter("workID");
            Geolocation.deleteLocationOfWork(workID);
            response.sendRedirect(referer.replace("map","info"));
        }

    }
    //Assuming request comes from browse.jsp
    else {
        String ward = Geolocation.getWard(request);
        if (NumberUtils.isNumber(ward)) {
            response.sendRedirect("works.jsp?wardNumber=" + ward);
        } else {
%>
<html>
<head>
    <title><%=LoadProperties.properties.getString("Allpages.PageTitle")%>
    </title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/<%=LoadProperties.properties.getString("FaviconName")%>" type="image/x-icon"/>
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <link rel="stylesheet" href="commonfiles/custom.min.css">
    <link rel="stylesheet" href="commonfiles/bootstrap-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf.css">
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <script src="commonfiles/addons.js"></script>
    <script src="commonfiles/custom.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

</head>
<body>
<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">
    <h4 style="width: 100%; text-align: center; padding-top: 8%; min-height: 5%"><b class="text-danger"><i
            class="fa fa-exclamation-circle" aria-hidden="true"></i> &nbsp;Sorry, </b> we think you are outside HDMC
        boundaries. Can you please make sure you are inside and try again!<br><br></h4>
    <h3 style="width: 100%; text-align: center; padding-top: 3%; min-height: 40%">Or go to <a href="index.jsp"
                                                                                              class="text-primary">home
        page</a> and select your ward manually.</h3>
</div>
</body>
</html>
<%
        }
    }
%>