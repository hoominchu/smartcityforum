<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.BasicDBObject"
%>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%@ page import="smartcity.*" %>
<%@ page import="smartcity.Filter" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%
    try {

        String rootFolder;
        if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
            rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataOnWeb");
        } else {
            rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataLocal");
        }

        Calendar today = Calendar.getInstance();

        String languageParameter = StringEscapeUtils.escapeHtml4(request.getParameter("language"));
        String showRecentParameter = StringEscapeUtils.escapeHtml4(request.getParameter("recent"));
        String wardNumberParameter = StringEscapeUtils.escapeHtml4(request.getParameter("wardNumber"));

        BasicDBObject myQuery = smartcity.Filter.generateFiltersHashset(request);

        String baseLink = "works.jsp?";
        String dynamicLink = General.genLink();

        ArrayList<Work> works;

        if (showRecentParameter != null && showRecentParameter.equals("true")) {
            works = Work.getRecentWorks();
        } else {
            works = Work.createWorkObjects(myQuery);
        }

        Integer numberOfWorksDisplayed = works.size();
        Long amountSpent = Long.valueOf(0);
        int completedWorks = 0;
        int inprogressWorks = 0;

        // Finds the totals of the works displayed.
        for (Work tempWork : works) {
            amountSpent = amountSpent + Long.valueOf(tempWork.amountSanctioned);
            if (tempWork.statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusCompleted"))) {
                completedWorks++;
            } else {
                inprogressWorks++;
            }
        }

        String amountSpentString = General.rupeeFormat(amountSpent.toString());
        String numberOfWorksDisplayedString = General.rupeeFormat(numberOfWorksDisplayed.toString());

%>

<html>
<head>
    <title><%=LoadProperties.properties.getString("Allpages.PageTitle")%>
    </title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/<%=LoadProperties.properties.getString("FaviconName")%>" type="image/x-icon"/>
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <script src="commonfiles/jquery.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <script src="commonfiles/addons.js"></script>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">
    <script type="text/javascript" src="commonfiles/tableExport/tableExport.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jquery.base64.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jspdf/libs/sprintf.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jspdf/jspdf.js"></script>
    <script type="text/javascript" src="commonfiles/tableExport/jspdf/libs/base64.js"></script>
    <script>
        (function (document) {
            'use strict';

            var LightTableFilter = (function (Arr) {

                var _input;

                function _onInputEvent(e) {
                    _input = e.target;
                    var tables = document.getElementsByClassName(_input.getAttribute('data-table'));
                    Arr.forEach.call(tables, function (table) {
                        Arr.forEach.call(table.tBodies, function (tbody) {
                            Arr.forEach.call(tbody.rows, _filter);
                        });
                    });
                }

                function _filter(row) {
                    var text = row.textContent.toLowerCase(), val = _input.value.toLowerCase();
                    row.style.display = text.indexOf(val) === -1 ? 'none' : 'table-row';
                }

                return {
                    init: function () {
                        var inputs = document.getElementsByClassName('light-table-filter');
                        Arr.forEach.call(inputs, function (input) {
                            input.oninput = _onInputEvent;
                        });
                    }
                };
            })(Array.prototype);

            document.addEventListener('readystatechange', function () {
                if (document.readyState === 'complete') {
                    LightTableFilter.init();
                }
            });

        })(document);
    </script>
</head>

<body>

<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">

    <div style="margin-bottom: 2em">

        <%
            if (numberOfWorksDisplayed > 0) {
        %>
        <%
            if (wardNumberParameter != null) {

                String[] wardinfo = Ward.getWardInfo(Integer.parseInt(wardNumberParameter));
                String corporatorEnglish = wardinfo[1];
                String corporatorKannada = wardinfo[2];
                String wardMeaning = wardinfo[3];
                String population2011 = wardinfo[4];

                String[] corporatorDetails = Corporator.getCorporatorDetails(Integer.parseInt(wardNumberParameter));
                String contactNumber = corporatorDetails[2];
                String partyEnglish = corporatorDetails[3];
                String partyKannada = corporatorDetails[4];
                String imgURL = corporatorDetails[5];
        %>

        <div class="panel panel-default round-corner" style="text-align: center">
            <div class="panel-heading round-corner-top">Ward Info</div>
            <div class="panel-body">

                <div class="pull-left" id="corporatorImage" style=" width: 20%; display: inline-block">
                    <%
                        if (imgURL.length() > 1) {
                    %>
                    <img class="round-corner" src="<%=imgURL%>">
                    <%
                    } else {
                    %>
                    <img class="round-corner" height="160em"
                         src="https://pixabay.com/static/uploads/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png">
                    <%
                        }
                    %>
                </div>

                <h4>
                    Ward Number : <%=wardNumberParameter%>
                    <%
                        if (Integer.parseInt(wardNumberParameter) > 67) {
                    %>| Ward meaning : <%=wardMeaning%>
                    <%
                    } else {
                    %>
                    | Population
                    <small>(Census of 2011)</small>
                    : <%=General.rupeeFormat(population2011)%>
                    <br>
                    <hr>

                    Corporator : <%=corporatorKannada%> | <%=corporatorEnglish%> <b> | </b> Party : <%=partyKannada%>
                    | <%=partyEnglish%> <br><br>
                    <%
                        String[] phoneNumbers = contactNumber.split(",");
                        for (String number : phoneNumbers) {
                    %>
                    <a href="tel:<%=number%>"><i class="fa fa-phone" aria-hidden="true"></i> <%=number%>
                    </a> |
                    <%
                            }
                        }
                    %>

                </h4>
            </div>
        </div>

        <%
            }
        %>

        <div class="row">
            <div class="panel panel-default round-corner"
                 style="text-align: center; width: 20%; display: inline-block; margin-right: -5em; margin-left: 1em">
                <div class="panel-heading round-corner-top">Overview</div>
                <div class="panel-body round-corner " style="height: 25em">
                    Number of Works
                    <h4>
                        <%
                            if (showRecentParameter != null && showRecentParameter.equals("true")) {
                        %>
                        <small>Most recent</small>
                        <%
                            }
                        %><b><%=numberOfWorksDisplayedString%>
                    </b></h4>
                    <hr>
                    In progress <h4><b><%=General.rupeeFormat(inprogressWorks)%>
                </b></h4>
                    <hr>
                    Completed <h4><b><%=General.rupeeFormat(completedWorks)%>
                </b></h4>
                    <hr>
                    Amount Spent <h4><b><%=amountSpentString%>
                </b></h4>
                </div>
            </div>

            <div class="panel panel-default round-corner pull-right"
                 style="text-align: center; width: 75%; display: inline-block; margin-left: -4em; margin-right: 1em">
                <div class="panel-heading round-corner-top">Dashboard</div>
                <div class="panel-body round-corner">
                    <div id="loading-chart-gif" style="height: 10em; width: 100%;">
                        <small><i class="fa fa-bar-chart fa-2" aria-hidden="true"></i> &nbsp;Please wait while the chart
                            loads...
                        </small>
                    </div>
                    <div id="dashboard" style="width:100%; height:23em; z-index: 100; margin-top: -10em"></div>
                </div>
            </div>
        </div>
        <%
            Ward.createAllWardObjects(works);

            String[] wardDetails = Ward.getWardDetails();

            String allWardsString = wardDetails[0];
            String allWardsAmountSpent = wardDetails[1];
            String allWardsWorks = wardDetails[2];
            String allWardsCompletedWorks = wardDetails[3];
            String allWardsInprogressWorks = wardDetails[4];
        %>
        <script>
            $(function () {
                $('#dashboard').highcharts({
                    chart: {
                        type: 'column'
                    },
                    title: {
                        text: '<%=smartcity.Filter.getFiltersApplied()%>'
                    },
                    tooltip: {
                        borderRadius: 12,
                        animation: true
                    },
                    plotOptions: {
                        column: {
                            borderRadius: 0
                        },
                        series: {
                            cursor: 'pointer',
                            point: {
                                events: {
                                    click: function () {
                                        location.href = "works.jsp?wardNumber=" + this.category;
                                    }
                                }
                            }
                        }
                    },
                    credits: {
                        enabled: false
                    },
                    xAxis: {
                        categories: [<%=allWardsString%>],
                        text: 'Wards'
                    },
                    yAxis: {
                        title: {
                            text: 'Magnitude'
                        }
                    },
                    series: [{
                        name: 'Total works',
                        data: [<%=allWardsWorks%>],
                        visible: true
                    }, {
                        name: 'Completed works',
                        data: [<%=allWardsCompletedWorks%>],
                        visible: true
                    }, {
                        name: 'In progress works',
                        data: [<%=allWardsInprogressWorks%>],
                        visible: true

                    }, {
                        name: 'Total amount spent',
                        data: [<%=allWardsAmountSpent%>],
                        visible: false
                    }]
                });
            });
        </script>

        <% if (languageParameter != null) {
            dynamicLink = dynamicLink + "&language=kannada&";
        }
            dynamicLink = dynamicLink.replaceAll("&&", "&");

            for (Filter click : smartcity.Filter.FILTERS) {
                String dismissalLink = baseLink + dynamicLink.replace(click.parameter + "=" + click.parameterValue, "");
                dismissalLink = dismissalLink.substring(0, dismissalLink.lastIndexOf("&"));
        %>
    <span class="label label-primary round-corner"
          style="font-size: 1.1em;"><%=click.parameterPresentable%> : <%=click.parameterValuePresentable%> <a
            href=<%=dismissalLink%>> <i class="fa fa-times-circle white-icon" style="color: white"
                                        aria-hidden="true"></i></a></span>
        <%
            }
        %>

        <input type="search" class="light-table-filter form-control col-xs-12 round-corner" data-table="searchable"
               placeholder="Search in displayed results..." style="margin-bottom: 1em; margin-top: 1em">

        <button class="btn btn-default pull-right round-corner-top"
                onclick="$('#myTable').tableExport({type:'csv',escape:'false'});" href="#">
            Download Results
        </button>

        <table class="table table-striped table-responsive sortable searchable" id="myTable"
               style="margin-top:2em; width: 100%; table-layout: fixed">

            <thead>
            <tr>
                <th style="width: 3%; padding: 2px; text-align: center">Ward</th>
                <th style="width: 30%; padding: 2px; text-align: left">Work Description</th>
                <th style="width: 8%; padding: 2px; text-align: center">Work Order Date</th>
                <th style="width: 8%; padding: 2px; text-align: center">Work Completion Date</th>
                <th style="width: 9%; padding: 2px; text-align: center">Work Type</th>
                <th style="width: 11%; padding: 2px; text-align: center">Minor Work Type</th>
                <th style="width: 3%; padding: 2px; text-align: center">Year</th>
                <th style="width: 8%; padding: 2px; text-align: center">Source Of Funding</th>
                <th style="width: 7%; padding: 2px; text-align: center">Amount Sanctioned</th>
                <th style="width: 6%; padding: 2px; text-align: center">Bill Paid</th>
                <th style="width: 7%; padding: 2px; text-align: center">Difference</th>
            </tr>
            </thead>
            <tbody>
            <%
                //WorkResults wr = mymethod(request);
                try {
                    for (Work work : works) {

                        int wardNumber = work.wardNumber;
                        String workDescriptionEnglish = work.workDescriptionEnglish;
                        String workDescriptionKannada = work.workDescriptionKannada;
                        String workDescriptionFinal;
                        String workOrderDate = work.workOrderDate;
                        String workCompletionDate = work.workCompletionDate;
                        String workType = work.workType;
                        String minorIDMeaning = work.minorIDMeaning;

                        Calendar completionDate = General.createDate(workCompletionDate);
                        String dateColor = "";

                        String sourceOfIncome = work.sourceOfIncome;

                        String contractor = work.contractor;
                        String amountSanctionedString = work.amountSanctionedString;
                        int amountSanctioned = work.amountSanctioned;
                        Integer billPaid = work.billPaid;

                        int difference = amountSanctioned - billPaid;

                        String year = work.year;

                        String status = work.statusfirstLetterCapital;
                        String statusFirstLetterSmall = work.statusFirstLetterSmall;

                        //Values for backend
                        String workID = work.workID;
                        String workTypeID = work.workTypeID;
                        String contractorID = work.contractorID;
                        String sourceOfIncomeID = work.sourceOfIncomeID;
                        String statusColor = work.statusColor;
                        String minorID = work.minorWorkTypeID;
                        //String tenderApprovalDate = work.tenderApprovalDate;
                        //String customSortKeyTenderDate = General.customSortKeySortTableJS(tenderApprovalDate);

                        String billPaidColor = General.setBillPaidColor(amountSanctioned, billPaid);

                        if (today.after(completionDate) && status.equalsIgnoreCase(LoadProperties.properties.getString("StatusInprogress"))) {
                            dateColor = "red";
                        }

                        workDescriptionFinal = General.setWorkDescriptionFinal(languageParameter, workDescriptionEnglish, workDescriptionKannada);
            %>
            <tr>
                <td style="text-align: center; padding-left: 0.2em"><a
                        href="<%=baseLink%><%=dynamicLink%>wardNumber=<%=wardNumber%>"><%=wardNumber%><br>
                </a>

                </td>

                <td>
                    <a href="workDetails.jsp?workID=<%=workID%>&jumbotron=billDetails">
                        <%=workDescriptionFinal%>
                    </a>
                    <br>
                    <% if (work.doWorkDetailsExist) { %>
                    <i class="fa fa-list-ul"
                       style="font-size: 12pt; margin-top: 2px"
                       aria-hidden="true" title="This work has more details"></i>
                    <% }
                        if (billPaid > 0) {
                    %>
                    <i class="fa fa-money"
                       style="font-size: 12pt; margin-top: 2px; margin-left: 5px"
                       aria-hidden="true" title="This work has details of bills paid"></i>
                    <%
                        }
                        if (Work.doesFileExist(rootFolder + workID + File.separator, ".jpg") || Work.doesFileExist(rootFolder + workID + File.separator, ".png")) {
                    %>
                    <i class="fa fa-picture-o"
                       style="font-size: 12pt; margin-top: 2px; margin-left: 5px"
                       aria-hidden="true" title="Images of this work are available"></i>
                    <%
                        }
                        if (Work.doesFileExist(rootFolder + workID + File.separator, ".kml")) {
                    %>
                    <i class="fa fa-map-marker"
                       style="font-size: 12pt; margin-top: 2px; margin-left: 5px"
                       aria-hidden="true" title="Map of this work is available"></i>
                    <%
                        }
                    %>
                    <br>
                    Contractor : <a href="<%=baseLink%><%=dynamicLink%>contractorID=<%=contractorID%>"><%=contractor%>
                </a>
                    <br>
                    Status : <a href="<%=baseLink%><%=dynamicLink%>status=<%=statusFirstLetterSmall%>"><%=status%>
                </a>
                    &nbsp;
                    <i class="fa fa-circle" style="color: <%=statusColor%>;" aria-hidden="true"></i>
                </td>
                <td sorttable_customkey="<%=General.customSortKeySortTableJS(workOrderDate)%>"
                    style="text-align: center"><%=workOrderDate%>
                </td>
                <td sorttable_customkey="<%=General.customSortKeySortTableJS(workCompletionDate)%>"
                    style="text-align: center; color: <%=dateColor%>"><%=workCompletionDate%>
                </td>
                <td style="text-align: center"><a
                        href="<%=baseLink%><%=dynamicLink%>workTypeID=<%=workTypeID%>"><%=workType%>
                </a>
                <td style="text-align: center; padding-left: 0.2em"><a
                        href="<%=baseLink%><%=dynamicLink%>minorID=<%=minorID%>"><%=minorIDMeaning%>
                </a>
                </td>
                <td style="text-align: center"><a
                        href="<%=baseLink%><%=dynamicLink%>year=<%=year%>"><%=year%>
                </a>
                </td>
                <td style="text-align: center; overflow: hidden"><a
                        href="<%=baseLink%><%=dynamicLink%>sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%>
                </a>
                </td>
                <td style="text-align: center"><%=General.rupeeFormat(amountSanctionedString)%>
                </td>
                <td style="text-align: center; color: <%=billPaidColor%>">
                    <%
                        if (billPaid > 0) {
                    %><%=General.rupeeFormat(billPaid.toString())%>
                    <%
                    } else {
                    %>
                    Not paid
                    <%
                        }
                    %>
                </td>
                <td style="text-align: center; color: <%=billPaidColor%>">
                    <%
                        if (difference != 0 && billPaid > 0) {
                    %><%=General.rupeeFormat(difference)%>
                    <%
                    } else if (difference == 0) {
                    %>
                    Exact amount has been paid
                    <%
                    } else if (billPaid == 0) {
                    %>
                    NA
                    <%
                        }
                    %>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    System.err.println(e.getClass().getName() + ": " + e.getMessage());
                }
            %>
            </tbody>
        </table>
        <a href="#" class="scrollup round-corner">Go to top</a>
        <%
        } else {
        %>
        <div style="text-align: center; margin-bottom: 5%; margin-top: 5%">
            <h4><p class="text-danger">No results found </p></h4>
        </div>
        <%
            }
        %>
    </div>
</div>

<%@include file="footer.jsp" %>
<%@include file="contactmodal.jsp" %>

<%
    } catch (Exception e) {
        System.out.println("Error" + e.getMessage());
        System.out.println("Stacktrace -- ");
        e.printStackTrace();
        String redirectURL = "error.jsp";
        response.sendRedirect(redirectURL);
    }
%>
</body>
</html>
