<div class="container">
    <div class="row">
        <div class="pull-right" style="display: inline-block">
            <%
                if (session.getAttribute("email") == null) {
            %>
            <a href="login.jsp">
                <div id="login-button" style="display: inline-block"><p class="text-primary">Login</p>
                </div>
            </a>
            <%
            } else {
            %>
            <p style="display: inline-block">Hello, <a href="profile.jsp"><%=session.getAttribute("nameOfUser")%>
            </a>!</p>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <div id="logout-button" style="display: inline-block"><a href="logout.jsp">Logout</a></div>
            <%
                }
            %>

        </div>
    </div>
</div>