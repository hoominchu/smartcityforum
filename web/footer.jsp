<%@ page import="smartcity.Database" %>
<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="com.mongodb.DBObject" %><%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 12:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String lastUpdatedDate = "";
    try {
        DBObject dateObject = Database.allworks.findOne(new BasicDBObject("Date object", "true"));
        lastUpdatedDate = "Data last refreshed on " + dateObject.get("Last updated date");
    } catch (Exception e) {
        //not doing anything because footer gets loaded with every page and the log will be full if there is no date object found.
    }
%>
<div class="panel-footer" style="text-align: center; color: grey">
    <small>13 July 2017<br>
        <%=LoadProperties.properties.getString("Footer.CopyRightNOrgnizationName")%>
    </small>
    <br>
    <small><a href="about.jsp"> About </a> | <a href="#" data-toggle="modal" data-target=".contact-modal"> Contact</a></small>
</div>



