<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 3:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <span class="pull-left" style="margin-top: 1%"><img src="images/scf_white_notext.png" height="35px"></span>
            <a class="navbar-brand" href="about.jsp">Smart City Forum</a>
        </div>

        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="works.jsp?workTypeID=1">Capital</a></li>
                <li><a href="works.jsp?workTypeID=2">Maintenance</a></li>
                <li><a href="works.jsp?workTypeID=3">Emergency</a></li>
                <li><a href="works.jsp?year=2016">This year</a></li>
                <li><a href="works.jsp?recent=true">Recent</a></li>
                <li><a href="works.jsp">All Works</a></li>
                <li><a href="dashboard.jsp">Dashboard</a></li>
                <li><a href="about.jsp">About</a></li>
                <li><a href="#" data-toggle="modal" data-target=".modal">Contact</a></li>
            </ul>
        </div>
    </div>
</nav>
