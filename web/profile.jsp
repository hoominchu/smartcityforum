<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBObject" %>
<%@ page import="smartcity.Database" %>
<%@ page import="smartcity.Profile" %>
<%@ page import="smartcity.Work" %>
<%@ page import="java.net.URL" %>
<%@ page import="org.json.JSONObject" %>
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
        String userEmail = (String) session.getAttribute("email");
        String userID = (String) session.getAttribute("userID");
        Profile profile = new Profile(userEmail);
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

</head>
<body>
<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">

    <div class="col-sm-4" style="text-align: center">
        <h3>Profile</h3>
        <%
            String urlString = "https://www.googleapis.com/plus/v1/people/"+userID+"?fields=image&key="+LoadProperties.properties.getString("GoogleMapsAPIKey");
//            URL url = new URL(urlString);
//            JSONObject urlResponse = (JSONObject) url.getContent();
//            System.out.println(urlResponse.toString());
        %>
        <div class="col-sm-12" style="text-align: center; border-radius: 100%; margin-bottom: 2em; margin-top: 1.5em;">
            <img class="img-circle" src="images/pp-placeholder.png" width="60%">
        </div>
        <h5 class="text-primary"><%=session.getAttribute("nameOfUser")%></h5>
    </div>
    <div class="col-sm-8">

        <%
            if (profile.subscribedWorks.size() > 0) {
        %>
        <h4>Works you have subscribed to</h4>
        <%
            for (Integer workID : profile.subscribedWorks) {
                Work work = Work.getWork(workID.toString());
        %>
        <div class="panel panel-default round-corner">
            <div class="panel-body round-corner-top">
                <%=work.workDescriptionEnglish%>
            </div>
            <div class="panel-footer round-corner-bottom">Work ID : <%=work.workID%> | Ward : <%=work.wardNumber%> |
                Contractor
                : <%=work.contractor%>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <hr><h4 class="text-danger">You have not subscribed to any work</h4><hr>
        <%
            }
        %>

        <%
            if (profile.subscribedWards.size() > 0) {
        %>
        <h4>Wards you have subscribed to</h4>
        <%
            for (Integer ward : profile.subscribedWards) {
        %>
        <div class="panel panel-default round-corner" style="display: inline-block">
            <div class="panel-body round-corner">
                <%=ward%>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <hr><h4 class="text-danger">You have not subscribed to any ward</h4><hr>
        <%
            }
        %>

        <%
            if (profile.subscribedSourcesOfIncome.size() > 0) {
        %>

        <h4>Sources of income you have subscribed to</h4>
        <%
            for (Integer sourceOfIncomeID : profile.subscribedSourcesOfIncome) {
                BasicDBObject query = new BasicDBObject(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"), sourceOfIncomeID);
                DBObject object = Database.allworks.findOne(query);
        %>
        <div class="panel panel-default round-corner" style="display: inline-block">
            <div class="panel-body round-corner">
                <%=object.get(LoadProperties.properties.getString("Work.Column.SourceOfFinance"))%>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <hr><h4 class="text-danger">You have not subscribed to any source of income</h4><hr>
        <%
            }
        %>
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
