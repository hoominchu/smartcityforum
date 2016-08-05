<%@ page import="smartcity.LoadProperties" %><%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 02/07/16
  Time: 4:03 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content round-corner">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Contact Us</h4>
            </div>
            <div class="modal-body">
                <p><h5><b>For any queries or suggestions </b></h5></p>
                <b>Email us</b> <br>
                <%=LoadProperties.properties.getString("ContactName1")%> &mdash; <b><%=LoadProperties.properties.getString("ContactEmail1")%></b><br>
                <%=LoadProperties.properties.getString("ContactName2")%> &mdash; <b><%=LoadProperties.properties.getString("ContactEmail2")%></b><br><br>
                <b>Call us</b> <br>
                <%=LoadProperties.properties.getString("PhoneContactName")%> &mdash; <a href="tel:08362213888"><b><%=LoadProperties.properties.getString("PhoneContactNumber")%></b></a></p>
                <hr>
                <p><h5><b>Our Address</b></h5></p>
                <p><%=LoadProperties.properties.getString("ContactAddress")%>
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default round-corner" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
