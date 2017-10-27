<%@ page import="java.util.List" %>
<%@ page import="smartcity.DataEntryDifference" %>
<%@ page import="smartcity.Email" %>
<%@ page import="smartcity.Alerts" %>
<%
    System.out.println("------------#-----------");
    DataEntryDifference.insertUpdateDate();
    List<DataEntryDifference> differences = DataEntryDifference.compareAllWorks("/Users/dsv/Desktop/Projects/SCF/test_data/sample.csv");
    List<Email> emails = Email.getEmailList(differences);
    Alerts.sendEMail(emails);
%>