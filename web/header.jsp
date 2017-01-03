<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 3:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container">
    <div class="row">
        <%
            if (session.getAttribute("email") == null) {
        %>
        <a href="login.jsp">
            <div class="pull-right" id="login-button"><p class="text-primary">Login <i class="fa fa-sign-in"
                                                                                       aria-hidden="true"></i></p></div>
        </a>
        <%
        } else {
        %>
        <p class="pull-right">Hello, <%=session.getAttribute("nameOfUser")%>!</p>
        <%
            }
        %>

    </div>
    <div class="row">
        <div class="col-sm-2" style="text-align:center;">
            <img src="images/<%=LoadProperties.properties.getString("LogoNameOrganization")%>"
                 class="logo-organization">
        </div>
        <div class="col-sm-8">
            <h2 style="text-align:center;vertical-align: middle" class="header-title"><a href="index.jsp"
                                                                                         style="color: black;"><%=LoadProperties.properties.getString("Header.Title")%>
            </a></h2>

        </div>
        <div class="col-sm-2" style="text-align: center">
            <img src="images/<%=LoadProperties.properties.getString("LogoNameSmartCity")%>" class="logo-smartcity">
        </div>
    </div>
</div>