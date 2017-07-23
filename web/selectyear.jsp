<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
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
    List years = Database.allworks.distinct("Year");
    List<Integer> yearsInNumbers = new ArrayList<>();
    for (Object year : years) {
        int yearInNum = Integer.parseInt(year.toString());
        yearsInNumbers.add(yearInNum);
    }
    Collections.sort(yearsInNumbers);
    Collections.reverse(yearsInNumbers);
    years.clear();
    for (int year : yearsInNumbers) {
        years.add(Integer.toString(year));
    }
%>

<div class="container">
    <div class="row">
        <div class="col-sm-3"></div>
        <div class="col-sm-6" style="padding-bottom: 6em;">
            <h3 style="padding-bottom:1em">Select year</h3>
            <div class="btn-group-vertical round-corner" style="width:100%; min-height: 19em">
                <a href="works.jsp?year=<%=years.get(0)%>" class="btn-link btn btn-default btn-lg btn-block"
                   style="border: 1px solid; border-color:#c1c1c1; border-top-left-radius: 0.6em; border-top-right-radius: 0.6em;"><%=years.get(0)%>
                </a>
                <%
                    for (int i = 1; i < years.size() - 1; i++) {

                %>
                <a href="works.jsp?year=<%=years.get(i)%>"
                   class="btn-link btn btn-default btn-lg btn-block"
                   style="border: 1px solid; border-color:#c1c1c1; "><%=years.get(i)%>
                </a>
                <%
                    }
                %>
                <a href="works.jsp?year=<%=years.get(years.size()-1)%>"
                   class="btn-link btn btn-default btn-lg btn-block round-corner-bottom"
                   style="border: 1px solid; border-color:#c1c1c1; border-bottom-left-radius: 0.6em; border-bottom-right-radius: 0.6em;"><%=years.get(years.size() - 1)%>
                </a>
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
