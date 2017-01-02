<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 3:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container" style="margin-top: 2em">
    <div class="col-sm-2" style="text-align:center;">
        <img src="images/<%=LoadProperties.properties.getString("LogoNameOrganization")%>" class="logo-organization">
    </div>
    <div class="col-sm-8">
        <h2 style="text-align:center;vertical-align:" class="header-title"><a href="index.jsp"
                                                                              style="color: black;"><%=LoadProperties.properties.getString("Header.Title")%>
        </a></h2>

    </div>
    <div class="col-sm-2" style="text-align: center">
        <img src="images/<%=LoadProperties.properties.getString("LogoNameSmartCity")%>" class="logo-smartcity">
    </div>
</div>