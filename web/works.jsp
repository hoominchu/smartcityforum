<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/04/16
  Time: 4:09 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="org.apache.commons.lang3.StringEscapeUtils"
%>
<%@ page import="smartcity.*" %>
<%@ page import="smartcity.Filter" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%
    try {

        String email = (String) session.getAttribute("email");
        Boolean subscriptionToWard = false;
        Boolean subscriptionToSourceOfIncome = false;


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
        String sourceOfIncomeIDParameter = StringEscapeUtils.escapeHtml4(request.getParameter("sourceOfIncomeID"));

        String searchParameter = StringEscapeUtils.escapeHtml4(request.getParameter("q"));

        System.out.println(searchParameter);

        //checking if the person is subscribed to the ward if logged in
        if (email != null && wardNumberParameter != null) {
            Alerts alerts = new Alerts();
            subscriptionToWard = alerts.checkIfSubscribedToField2(email, Integer.parseInt(wardNumberParameter));
        }

        //checking if the person is subscribed to the source of income if logged in
        if (email != null && sourceOfIncomeIDParameter != null) {
            Alerts alerts = new Alerts();
            subscriptionToSourceOfIncome = alerts.checkIfSubscribedToField3(email, Integer.parseInt(sourceOfIncomeIDParameter));
        }

        BasicDBObject myQuery = new BasicDBObject();

        if (searchParameter == null) {
            myQuery = smartcity.Filter.generateFiltersHashset(request);
        } else if (searchParameter != null) {

            try {
                myQuery = new BasicDBObject(LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(searchParameter));
            } catch (NumberFormatException pe) {

                BasicDBObject searchQuery = new BasicDBObject("$search", searchParameter);
                BasicDBObject textSearchQuery = new BasicDBObject("$text", searchQuery);

                //myQuery = new BasicDBObject();
                myQuery = textSearchQuery;
            }
        }

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

        Boolean atleastOneWorkHasLocation = false;

        // Finds the totals of the works displayed. Check if any of the works has location and count the number of works with location.
        int numOfWorksWithLocation = 0;
        for (Work tempWork : works) {
            if (tempWork.hasLocation) {
                atleastOneWorkHasLocation = true;
                numOfWorksWithLocation++;
            }
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
    <link rel="stylesheet" href="commonfiles/custom.min.css">
    <link rel="stylesheet" href="commonfiles/bootstrap-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf.css">
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <script src="commonfiles/addons.js"></script>
    <script src="commonfiles/custom.js"></script>
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
    <script>
        (function (i, s, o, g, r, a, m) {
            i['GoogleAnalyticsObject'] = r;
            i[r] = i[r] || function () {
                        (i[r].q = i[r].q || []).push(arguments)
                    }, i[r].l = 1 * new Date();
            a = s.createElement(o),
                    m = s.getElementsByTagName(o)[0];
            a.async = 1;
            a.src = g;
            m.parentNode.insertBefore(a, m)
        })(window, document, 'script', 'https://www.google-analytics.com/analytics.js', 'ga');

        ga('create', 'UA-79399673-1', 'auto');
        ga('send', 'pageview');

    </script>
    <script>
        function subscribeToWard() {
            document.getElementById("subscribeWardButton").disabled = true;
            window.location = "subscribe.jsp?unsubscribe=false&wardNumber=<%=wardNumberParameter%>"
        }
        function unsubscribeFromWard() {
            document.getElementById("unsubscribeWardButton").disabled = true;
            window.location = "subscribe.jsp?unsubscribe=true&wardNumber=<%=wardNumberParameter%>"
        }
        function subscribeToSourceOfIncome() {
            document.getElementById("subscribeSourceOfIncomeButton").disabled = true;
            window.location = "subscribe.jsp?unsubscribe=false&sourceOfIncomeID=<%=sourceOfIncomeIDParameter%>"
        }
        function unsubscribeFromSourceOfIncome() {
            document.getElementById("unsubscribeSourceOfIncomeButton").disabled = true;
            window.location = "subscribe.jsp?unsubscribe=true&sourceOfIncomeID=<%=sourceOfIncomeIDParameter%>"
        }
    </script>

    <script>
        jQuery(function ($) {
            // Asynchronously Load the map API
            var script = document.createElement('script');
            script.src = "//maps.googleapis.com/maps/api/js?key=<%=LoadProperties.properties.getString("GoogleMapsAPIKey")%>&callback=initialize";
            document.body.appendChild(script);
        });

        function initialize() {
            var map;
            var bounds = new google.maps.LatLngBounds();
            var mapOptions = {
                mapTypeId: 'roadmap'
            };

            // Display a map on the page
            map = new google.maps.Map(document.getElementById("worksmap"), mapOptions);
            map.setTilt(45);

            // Multiple Markers
            var markers = [
                <%
                for (Work tempWork : works) {
                if (tempWork.hasLocation){
                 %>
                ['<%=tempWork.workDescriptionEnglish%>', <%=tempWork.latitude%>, <%=tempWork.longitude%>],
                <%
                        }
                        }
                        %>
            ];

            // Info Window Content
            var infoWindowContent = [
                <%
                for (Work tempWork : works) {
                if (tempWork.hasLocation){
                 %>
                ['<%=tempWork.workDescriptionEnglish%>' + '<hr>' + '<a style="padding-bottom:3px" href="workDetails.jsp?workID=<%=tempWork.workID%>&jumbotron=info">' + 'Go to work details page' + '</a>'],
                <%
                        }
                        }
                        %>

            ];

            // Display multiple markers on a map
            var infoWindow = new google.maps.InfoWindow(), marker, i;

            // Loop through our array of markers & place each one on the map
            for (i = 0; i < markers.length; i++) {
                var position = new google.maps.LatLng(markers[i][1], markers[i][2]);
                bounds.extend(position);
                marker = new google.maps.Marker({
                    position: position,
                    map: map,
                    title: markers[i][0]
                });

                // Allow each marker to have an info window
                google.maps.event.addListener(marker, 'click', (function (marker, i) {
                    return function () {
                        infoWindow.setContent(infoWindowContent[i][0]);
                        infoWindow.open(map, marker);
                    }
                })(marker, i));

                // Automatically center the map fitting all markers on the screen
                map.fitBounds(bounds);
            }

//            // Override our map zoom level once our fitBounds function runs (Make sure it only runs once)
//            var boundsListener = google.maps.event.addListener((map), 'bounds_changed', function (event) {
//                this.setZoom(14);
//                google.maps.event.removeListener(boundsListener);
//            });

        }
    </script>

    <script src="https://maps.googleapis.com/maps/api/js?key=<%=LoadProperties.properties.getString("GoogleMapsAPIKey")%>&callback=initMap"
            async defer></script>
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
            if (wardNumberParameter != null && Integer.parseInt(wardNumberParameter) < 68) {

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

        <div class="panel panel-default round-corner" style="text-align: center; width: 100%">
            <div class="panel-heading round-corner-top">Ward Information</div>
            <div class="panel-body">

                <div class="col-xs-3" id="corporatorImage" style=" width: 20%; display: inline-block">
                    <%
                        if (imgURL.length() > 1) {
                    %>
                    <img class="round-corner" src="<%=imgURL%>">
                    <%
                    } else {
                    %>
                    <img class="round-corner" height="160em"
                         src="images/pp-placeholder.png">
                    <%
                        }
                    %>
                </div>

                <div class="col-sm-9" style="display: inline-block">
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

                        Corporator : <%=corporatorKannada%> | <%=corporatorEnglish%> <b> | </b> Party
                        : <%=partyKannada%>
                        | <%=partyEnglish%> <br><br>
                        <%
                            String[] phoneNumbers = contactNumber.split(",");
                            for (String number : phoneNumbers) {
                        %>
                        <a href="tel:<%=number%>"><i class="fa fa-phone" aria-hidden="true"></i> <%=number%>
                        </a> &nbsp;&nbsp;
                        <%
                                }
                            }
                        %>

                    </h4>
                </div>
            </div>
            <%
                if (!subscriptionToWard) {
            %>
            <%--button to subscribe--%>
            <button id="subscribeWardButton" class="btn btn-default btn-block round-corner-bottom"
                    style="background-color: #D0E9C6; border-width: 0px; font-size: 15px;"
                    onclick="subscribeToWard()">Click here to subscribe to this ward!
            </button>
            <%
            } else {
            %>
            <%--button to unsubscribe--%>
            <button id="unsubscribeWardButton" class="btn btn-default btn-block round-corner-bottom"
                    style="background-color: #EBCCCC; border-width: 0px; font-size: 15px;"
                    onclick="unsubscribeFromWard()">Click here to unsubscribe from this ward!
            </button>
            <%
                }
            %>
        </div>

        <%
            }
        %>

        <div class="panel panel-default round-corner"
             style="text-align: center; width: 100%; display: inline-block;">
            <div class="panel-heading round-corner-top">Overview</div>
            <div class="panel-body round-corner">
                <%
                    if (atleastOneWorkHasLocation) {
                %>
                <div id="worksmap" class="round-corner"
                     style="width:100%; height: 26em; position: relative; margin-bottom: 2em"></div>
                <%
                    }
                %>

                <div class="jumbotron round-corner-bottom" style="padding: 0; margin-bottom: 2em">

                    <div id="wardInfo" style="width: 100%; position: relative;">
                        <div class="panel panel-default round-corner-bottom" style="">
                            <div class="panel-body">

                                <div class="col-sm-4 round-corner" style="margin-top: 3em;">
                                    <div class="list-group round-corner">
                                        <a href="#" class="list-group-item round-corner-top">
                                            Number of Works <span class="badge"><%=numberOfWorksDisplayedString%></span>
                                        </a>
                                        <a href="#" class="list-group-item">In progress <span
                                                class="badge"><%=General.rupeeFormat(inprogressWorks)%></span>
                                        </a>
                                        <a href="#" class="list-group-item">Completed <span
                                                class="badge"><%=General.rupeeFormat(completedWorks)%></span>
                                        </a>
                                        <a href="#" class="list-group-item">Works with location <span
                                                class="badge"><%=numOfWorksWithLocation%></span>
                                        </a>
                                        <a href="#" class="list-group-item">Amount spent <span
                                                class="badge"><%=amountSpentString%></span>
                                        </a>
                                    </div>
                                </div>

                                <div class="col-sm-8 round-corner">

                                    <%
                                        if (wardNumberParameter != null) {
                                    %>
                                    <div id="pie"
                                         style="min-width: 100px; height: 250px; max-width: 600px; margin: 0 auto"></div>
                                    <%
                                    } else { %>
                                    <div id="dashboard" style="width: 100%"></div>
                                    <%
                                        }
                                    %>
                                </div>

                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div style="margin-top: 0.5em; margin-bottom: 1em; width: 100%;">
            <%
                if (sourceOfIncomeIDParameter != null) {
                    if (!subscriptionToSourceOfIncome) {
            %>
            <%--button to subscribe--%>
            <button id="subscribeSourceOfIncomeButton"
                    class="btn btn-default btn-block round-corner-bottom round-corner-top"
                    style="background-color: #D0E9C6; border-width: 0px; font-size: 15px;"
                    onclick="subscribeToSourceOfIncome()">Click here to subscribe to this source of income!
            </button>
            <%
            } else {
            %>
            <%--button to unsubscribe--%>
            <button id="unsubscribeSourceOfIncomeButton"
                    class="btn btn-default btn-block round-corner-bottom round-corner-top"
                    style="background-color: #EBCCCC; border-width: 0px; font-size: 15px;"
                    onclick="unsubscribeFromSourceOfIncome()">Click here to unsubscribe from this source of income!
            </button>
            <%
                    }
                }
            %>
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
            Highcharts.getOptions().colors = Highcharts.map(Highcharts.getOptions().colors, function (color) {
                return {
                    radialGradient: {
                        cx: 0.5,
                        cy: 0.3,
                        r: 0.7
                    },
                    stops: [
                        [0, color],
                        [1, Highcharts.Color(color).brighten(-0.3).get('rgb')] // darken
                    ]
                };
            });

            var inProgressWorks = 0;
            var completedWorks = 0;
            inProgressWorks = <%=General.rupeeFormat(inprogressWorks)%>;
            completedWorks = <%=General.rupeeFormat(completedWorks)%>;
            // Build the chart
            Highcharts.chart('pie', {
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: 'Dashboard'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false,
                            format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                            style: {
                                color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                            },
                            connectorColor: 'silver',
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    name: 'Works',
                    data: [
                        {name: 'In Progress', y: inProgressWorks},
                        {
                            name: 'Completed',
                            y: completedWorks,
                            sliced: true,
                            selected: true
                        }
                    ]
                }]
            });
        </script>

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
        <span class="label label-primary round-corner auto-height-text-overflow"
              style="font-size: 1.1em; margin-bottom: 0.2em; display: inline-block"><%=click.parameterPresentable%> : <%=click.parameterValuePresentable%> <a
                href=<%=dismissalLink%>> <i class="fa fa-times-circle white-icon" style="color: white"
                                            aria-hidden="true"></i></a></span>
        <%
            }
        %>


        <table class="table table-responsive sortable searchable" id="myTable"
               style="margin-top:2em; width: 100%; min-width: 750px; table-layout: fixed">

            <thead>
            <tr>
                <th style="width: 3%; padding: 2px; text-align: center">Ward</th>
                <th style="width: 30%; padding: 2px; text-align: left">Work Description</th>
                <th style="width: 8%; padding: 2px; text-align: center">Work Order Date</th>
                <th style="width: 8%; padding: 2px; text-align: center">Work Completion Date</th>
                <th style="width: 7%; padding: 2px; text-align: center">Amount Sanctioned</th>
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

                        //int difference = amountSanctioned - billPaid;

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

                        Boolean hasLocation = work.hasLocation;

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
                    <a href="workDetails.jsp?workID=<%=workID%>&jumbotron=info">
                        <%=workDescriptionFinal%>
                    </a>
                    <br>

                    <%
                        if (Work.doesFileExist(rootFolder + workID + File.separator, ".jpg") || Work.doesFileExist(rootFolder + workID + File.separator, ".png")) {
                    %>
                    <i class="fa fa-picture-o"
                       style="font-size: 12pt; margin-top: 2px; margin-left: 5px"
                       aria-hidden="true" title="Images of this work are available"></i>
                    <%
                        }
                        if ((Work.doesFileExist(rootFolder + workID + File.separator, ".kml")) || (hasLocation)) {
                    %>
                    <i class="fa fa-map-marker"
                       style="font-size: 15pt; margin:5px"
                       aria-hidden="true" title="Map of this work is available"></i>
                    <%
                        }
                    %>
                    <br>
                    Work ID : <a href="workDetails.jsp?workID=<%=workID%>&jumbotron=billDetails"><%=workID%>
                </a> | Year : <a href="<%=baseLink%><%=dynamicLink%>year=<%=year%>"><%=year%>
                </a>
                    <br>

                    Minor Work Type : <a href="<%=baseLink%><%=dynamicLink%>minorID=<%=minorID%>"><%=minorIDMeaning%>
                </a>
                    <br>
                    Work Type : <a href="<%=baseLink%><%=dynamicLink%>workTypeID=<%=workTypeID%>"><%=workType%>
                </a>
                    <br>
                    Source of Income : <a
                        href="<%=baseLink%><%=dynamicLink%>sourceOfIncomeID=<%=sourceOfIncomeID%>"><%=sourceOfIncome%>
                </a>

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
                <td style="text-align: center">&#8377;&nbsp;<%=General.rupeeFormat(amountSanctionedString)%>
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
