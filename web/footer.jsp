<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 12:27 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="panel-footer" style="text-align: center; color: grey">
    <small><%=LoadProperties.properties.getString("Footer.DataLastRefreshed")%><br>
        <%=LoadProperties.properties.getString("Footer.CopyRightNOrgnizationName")%>
    </small>
    <br>
    <small><a href="about.jsp"> About </a> | <a href="#" data-toggle="modal" data-target=".contact-modal"> Contact</a></small>
</div>



