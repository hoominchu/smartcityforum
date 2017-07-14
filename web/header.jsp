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
        <div class="col-sm-1"></div>
        <div class="col-sm-2" style="text-align:center;">
            <img src="images/<%=LoadProperties.properties.getString("LogoNameOrganization")%>"
                 class="logo-organization">
        </div>
        <div class="col-sm-6">
            <h2 style="text-align:center;vertical-align: middle" class="header-title"><a href="index.jsp"
                                                                                         style="color: black;"><%=LoadProperties.properties.getString("Header.Title")%>
            </a></h2>

        </div>
        <div class="col-sm-2" style="text-align: center">
            <img src="images/<%=LoadProperties.properties.getString("LogoNameSmartCity")%>" class="logo-smartcity">
        </div>
        <div class="col-sm-1"></div>
    </div>

    <form action="works.jsp" method="get">
        <div class="input-group" style="margin-bottom: 1em">
            <input type="text" class="form-control round-corner-left" name="q" placeholder="Search by work ID">
            <span class="input-group-btn">
                <button class="btn btn-default round-corner-right" type="submit">Search</button>
            </span>
        </div>
    </form>

</div>