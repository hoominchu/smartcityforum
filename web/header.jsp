<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 3:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container">
    <div class="col-xs-2">
        <img src="images/<%=LoadProperties.properties.getString("LogoNameOrganization")%>" width="150em" height="150em"
             style="text-align:center;margin-left: 40%">
    </div>
    <div class="col-xs-8">
        <h2 style="text-align:center;margin-top: 7%;margin-bottom: auto;"><a href="index.jsp"
                                                                             style="color: black;"><%=LoadProperties.properties.getString("Header.Title")%>
        </a>&nbsp;<h6 style="text-align: right; margin-right: 14%;">BETA</h6></h2>
    </div>
    <div class="col-xs-2">
        <img src="images/<%=LoadProperties.properties.getString("LogoNameSmartCity")%>" width="150em" height="150em"
             style="margin-right: 40%;margin-left: -40%;">
    </div>
</div>