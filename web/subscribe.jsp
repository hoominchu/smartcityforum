<%@ page import="smartcity.Alerts" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%
    try {
        Alerts alerts = new Alerts();

        String email = (String) session.getAttribute("email");
        String workIDParameter = StringEscapeUtils.escapeHtml4(request.getParameter("workID"));
        int workID = Integer.parseInt(workIDParameter);
        String unsubscribe = StringEscapeUtils.escapeHtml4(request.getParameter("unsubscribe"));

        if (email == null) {
            response.sendRedirect("login.jsp");
        }

        if (email != null && workIDParameter != null && unsubscribe.equals("false")) {
            alerts.subscribeToField1(email, workID);
            response.sendRedirect("workDetails.jsp?workID=" + workIDParameter+"&jumbotron=info");
        }
        else if(email != null && workIDParameter != null && unsubscribe.equals("true")){
            alerts.unsubscribeFromField1(email, workID);
            response.sendRedirect("workDetails.jsp?workID=" + workIDParameter+"&jumbotron=info");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
