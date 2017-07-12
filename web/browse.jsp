<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/06/16
  Time: 2:06 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    try {
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

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

    <script>
        var x = document.getElementById("localert");

        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(submitPosition,errorMessage,{enableHighAccuracy:true});
            }
        }

        function errorMessage() {
            x.innerHTML = "Geolocation is not supported by this browser.";
        }

        function submitPosition(position) {
            document.getElementById("lat").value = position.coords.latitude
            document.getElementById("long").value = position.coords.longitude
            document.getElementById("locationform").submit();
        }
    </script>

</head>
<body>
<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<form action="location.jsp" name="locationform" id="locationform" method="post">
    <input type="hidden" name="lat" id="lat" value="">
    <input type="hidden" name="long" id="long" value="">
</form>

<div class="container">
    <div class="row">
        <div class="col-sm-3"></div>
        <div class="col-sm-6">
            <h3 style="padding-bottom:1em">Browse by</h3>
            <div class="btn-group-vertical round-corner" style="width:100%; margin-bottom: 2em">
                <a class="btn-link btn btn-default btn-lg btn-block round-corner" onclick="getLocation()" style="border: 1px solid; border-color:#c1c1c1;">My Ward</a>
            </div>
            <div class="text-danger" id="localert"></div>
            <div class="btn-group-vertical round-corner" style="width:100%; height: 19em">
                <a href="selectward.jsp" class="btn-link btn btn-default btn-lg btn-block" style="border: 1px solid; border-color:#c1c1c1; border-top-left-radius: 0.6em; border-top-right-radius: 0.6em;">Ward</a>
                <a href="selectworktype.jsp" class="btn-link btn btn-default btn-lg btn-block" style="border: 1px solid; border-color:#c1c1c1; ">Work Type</a>
                <a href="selectsourceofincome.jsp" class="btn-link btn btn-default btn-lg btn-block" style="border: 1px solid; border-color:#c1c1c1; ">Source of Income</a>
                <a href="selectyear.jsp" class="btn-link btn btn-default btn-lg btn-block round-corner-bottom" style="border: 1px solid; border-color:#c1c1c1; border-bottom-left-radius: 0.6em; border-bottom-right-radius: 0.6em;">Year</a>
            </div>
        </div>
        <div class="col-sm-3"></div>
    </div>
</div>

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
