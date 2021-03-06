<%@ page import="smartcity.Database" %>
<%@ page import="java.util.List" %>
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

</head>
<body>
<%@include file="navbar.jsp" %>
<%
    List sourcesOfIncome = Database.allworks.distinct("Source of Income");
    List sourceOfIncomeIDs = Database.allworks.distinct("Source of Income ID");
%>
<div class="container">
    <div class="row">
        <div class="col-sm-3"></div>
        <div class="col-sm-6">
            <h3 style="padding-bottom:1em">Select source of income</h3>
            <div class="btn-group-vertical round-corner" style="width:100%; min-height: 19em">
                <a href="works.jsp?sourceOfIncomeID=<%=sourceOfIncomeIDs.get(0)%>" class="btn-link btn btn-default btn-lg btn-block"
                   style="border: 1px solid; border-color:#c1c1c1; border-top-left-radius: 0.6em; border-top-right-radius: 0.6em;"><%=sourcesOfIncome.get(0)%></a>
                <%
                    for (int i = 1; i < sourcesOfIncome.size() - 1; i++) {

                %>
                <a href="works.jsp?sourceOfIncomeID=<%=sourceOfIncomeIDs.get(i)%>"
                   class="btn-link btn btn-default btn-lg btn-block"
                   style="border: 1px solid; border-color:#c1c1c1; height: auto; ;"><%=sourcesOfIncome.get(i)%>
                </a>
                <%
                    }
                %>
                <a href="works.jsp?sourceOfIncomeID=<%=sourceOfIncomeIDs.get(sourceOfIncomeIDs.size()-1)%>" class="btn-link btn btn-default btn-lg btn-block round-corner-bottom"
                   style="border: 1px solid; border-color:#c1c1c1; border-bottom-left-radius: 0.6em; border-bottom-right-radius: 0.6em;"><%=sourcesOfIncome.get(sourcesOfIncome.size()-1)%></a>
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
