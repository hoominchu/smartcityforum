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
        <p class="pull-right">Hello, <a href="profile.jsp"><%=session.getAttribute("nameOfUser")%>
        </a>!</p>
        <%
            }
        %>
    </div>
</div>