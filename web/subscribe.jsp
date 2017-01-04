<%@ page import="smartcity.Alerts" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%
    try {
        Alerts alerts = new Alerts();

        String email = (String) session.getAttribute("email");
        String workIDParameter = StringEscapeUtils.escapeHtml4(request.getParameter("workID"));
        String wardNumberParameter = StringEscapeUtils.escapeHtml4(request.getParameter("wardNumber"));
        String sourceOfIncomeIDParameter = StringEscapeUtils.escapeHtml4(request.getParameter("sourceOfIncomeID"));
        String unsubscribe = StringEscapeUtils.escapeHtml4(request.getParameter("unsubscribe"));

        if (email == null) {
            response.sendRedirect("login.jsp");
        }

        //Work - Subscribe/Unsubscribe
        if (email != null && workIDParameter != null) {
            int workID = Integer.parseInt(workIDParameter);
            if (unsubscribe.equals("false")) {
                alerts.subscribeToField1(email, workID);
            } else if (unsubscribe.equals("true")) {
                alerts.unsubscribeFromField1(email, workID);
            }
            response.sendRedirect("workDetails.jsp?workID=" + workIDParameter + "&jumbotron=info");
        }

        //Ward - Subscribe/Unsubscribe
        if (email != null && wardNumberParameter != null) {
            int wardNumber = Integer.parseInt(wardNumberParameter);
            if (unsubscribe.equals("false")) {
                alerts.subscribeToField2(email, wardNumber);
            } else if (unsubscribe.equals("true")) {
                alerts.unsubscribeFromField2(email, wardNumber);
            }
            response.sendRedirect("works.jsp?wardNumber=" + wardNumberParameter);
        }

        //Source Of Income - Subscribe/Unsubscribe
        if (email != null && sourceOfIncomeIDParameter != null) {
            int sourceOfIncome = Integer.parseInt(sourceOfIncomeIDParameter);
            if (unsubscribe.equals("false")) {
                alerts.subscribeToField3(email, sourceOfIncome);
            } else if (unsubscribe.equals("true")) {
                alerts.unsubscribeFromField3(email, sourceOfIncome);
            }
            response.sendRedirect("works.jsp?sourceOfIncomeID=" + sourceOfIncomeIDParameter);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
