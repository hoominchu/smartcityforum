<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBObject" %>
<%@ page import="smartcity.*" %>
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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

</head>
<body>
<%@include file="navbar.jsp" %>
<%@include file="loginbar.jsp"%>
<%@include file="header.jsp" %>

<div class="container">

    <div class="col-sm-4" style="text-align: center">
        <h3>Profile</h3>
        <%
            //            String urlString = "https://www.googleapis.com/plus/v1/people/"+userID+"?fields=image&key="+LoadProperties.properties.getString("GoogleMapsAPIKey");
//            URL url = new URL(urlString);
//            JSONObject urlResponse = (JSONObject) url.getContent();
//            System.out.println(urlResponse.toString());
        %>
        <div class="col-sm-12" style="text-align: center; border-radius: 100%; margin-bottom: 2em; margin-top: 1.5em;">
            <img class="img-circle" src="images/pp-placeholder.png" width="60%">
        </div>
        <h4><%=session.getAttribute("nameOfUser")%>
        </h4>
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
                <%
                    String unsubscribeLink = "subscribe.jsp?unsubscribe=true&workID=" + work.workID;
                %>
                <a href=<%=unsubscribeLink%>> <i style="font-size: 1.2em;"
                                                 class="fa fa-times-circle pull-right text-danger"
                                                 aria-hidden="true"></i></a>
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
        <hr>
        <h4 class="text-danger">You have not subscribed to any work</h4>
        <hr>
        <%
            }
        %>

        <%
            if (profile.subscribedWards.size() > 0) {
        %>
        <hr>
        <h4>Wards you have subscribed to</h4>
        <%
            for (Integer ward : profile.subscribedWards) {

                String[] wardinfo = Ward.getWardInfo(ward);
                String corporatorEnglish = wardinfo[1];
                String corporatorKannada = wardinfo[2];
                String wardMeaning = wardinfo[3];
                String population2011 = wardinfo[4];

                String[] corporatorDetails = Corporator.getCorporatorDetails(ward);
                String contactNumber = corporatorDetails[2];
                String partyEnglish = corporatorDetails[3];
                String partyKannada = corporatorDetails[4];
                String imgURL = corporatorDetails[5];

                String unsubscribeLink = "subscribe.jsp?unsubscribe=true&wardNumber=" + Integer.toString(ward);
        %>

        <div class="panel panel-default round-corner wardifno-box" style="text-align: center; width: 100%">
            <div class="panel-heading round-corner-top">Ward Number : <%=ward%> <a href=<%=unsubscribeLink%>> <i
                    style="font-size: 1.2em;" class="fa fa-times-circle pull-right text-danger" aria-hidden="true"></i></a>
            </div>
            <div class="panel-body">
                <div class="col-sm-2">
                    <%
                        if (imgURL.length() > 1) {
                    %>
                    <img class="round-corner" height="80em" src="<%=imgURL%>">
                    <%
                    } else {
                    %>
                    <img class="round-corner" height="80em"
                         src="images/pp-placeholder.png">
                    <%
                        }
                    %>
                </div>

                <div class="col-xs-10">

                        <%
                            if (ward > 67) {
                        %>| Ward meaning : <%=wardMeaning%>
                        <%
                        } else {
                        %>

                        Corporator : <%=corporatorKannada%> | <%=corporatorEnglish%> <b> | </b> Party
                        : <%=partyKannada%>
                        | <%=partyEnglish%> <br><br>
                        <%
                            String[] phoneNumbers = contactNumber.split(",");
                            for (String number : phoneNumbers) {
                        %>
                        <a href="tel:<%=number%>"><i class="fa fa-phone" aria-hidden="true"></i> <%=number%>
                        </a> &nbsp;&nbsp;
                        <%
                                }
                            }
                        %>

                </div>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <hr>
        <h4 class="text-danger">You have not subscribed to any ward</h4>
        <hr>
        <%
            }
        %>

        <%
            if (profile.subscribedSourcesOfIncome.size() > 0) {
        %>

        <hr>
        <h4>Sources of income you have subscribed to</h4>
        <%
            for (Integer sourceOfIncomeID : profile.subscribedSourcesOfIncome) {
                BasicDBObject query = new BasicDBObject(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"), sourceOfIncomeID);
                DBObject object = Database.allworks.findOne(query);
        %>
        <div class="panel panel-default round-corner" style="display: inline-block">
            <div class="panel-body round-corner">
                <%=object.get(LoadProperties.properties.getString("Work.Column.SourceOfFinance"))%>
                <%
                    String unsubscribeLink = "subscribe.jsp?unsubscribe=true&sourceOfIncomeID=" + Integer.toString(sourceOfIncomeID);
                %>
                <a href=<%=unsubscribeLink%>> <i style="font-size: 1.2em;"
                                                 class="fa fa-times-circle pull-right text-danger"
                                                 aria-hidden="true"></i></a>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <hr>
        <h4 class="text-danger">You have not subscribed to any source of income</h4>
        <hr>
        <%
            }
        %>
    </div>

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
