<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 3:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="navbar navbar-default navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <span class="pull-left" style="margin-top: 1%"><img src="images/scf_white_notext.png" height="35px"></span>
            <a class="navbar-brand" href="about.jsp">Smart City Forum</a>
            <button class="navbar-toggle" type="button" data-toggle="collapse" data-target="#navbar-main">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
        </div>
        <div class="navbar-collapse collapse" id="navbar-main">

            <ul class="nav navbar-nav navbar-right">

                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">Works<span
                            class="caret"></span></a>
                    <ul class="dropdown-menu round-corner-bottom" role="menu">
                        <li><a href="works.jsp?workTypeID=1">Capital</a></li>
                        <li><a href="works.jsp?workTypeID=2">Maintenance</a></li>
                        <li><a href="works.jsp?workTypeID=3">Emergency</a></li>
                        <li><a href="works.jsp?recent=true">Recent</a></li>
                        <li><a href="works.jsp">All Works</a></li>
                        <li class="divider"></li>
                        <li><a href="dashboard.jsp" class="round-corner-bottom">Dashboard</a></li>
                    </ul>
                </li>
                <%
                    if (session.getAttribute("email") == null) {
                        %>
                <li><a href="login.jsp">Login</a></li>
                <%
                    } else {
                %>
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">My
                        Profile<span class="caret"></span></a>
                    <ul class="dropdown-menu round-corner-bottom" role="menu">
                        <li><a href="profile.jsp"><%=session.getAttribute("nameOfUser")%>
                        </a></li>
                        <li class="divider"></li>
                        <li><a href="logout.jsp" class="round-corner-bottom">Logout</a></li>
                    </ul>
                </li>
                <%
                    }
                %>
                <li><a href="about.jsp">About</a></li>
                <li><a href="#" data-toggle="modal" data-target=".modal">Contact</a></li>
            </ul>

        </div>
    </div>
</div>