<%@ page import="smartcity.DataEntryDifference" %>
<%@ page import="java.util.List" %>
<%
    System.out.println("------------------------");
    List<DataEntryDifference> tempList = DataEntryDifference.compareAllWorks("/data/projects/smartcity/data/latest/all_works_changed2.csv");
    System.out.println(tempList.toString());
%>