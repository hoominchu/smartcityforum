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
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    try {

        long initialTime = System.currentTimeMillis();

        String baseLink = "dashboard.jsp?";

        String jumbotronParameter = StringEscapeUtils.escapeHtml4(request.getParameter("jumbotron"));
        String workTypeParameter = StringEscapeUtils.escapeHtml4(request.getParameter("workType"));

        String[] yearParameterWardsChart = request.getParameterValues("yearWards");
        String[] yearParameterMinorTypeChart = request.getParameterValues("yearMinorType");

        Map<Integer, String> yearCheckedWardsChart = new HashMap<>();
        Map<Integer, String> yearCheckedMinorTypeChart = new HashMap<>();

        BasicDBObject queryWardsChart = new BasicDBObject();
        BasicDBObject queryMinorTypeChart = new BasicDBObject();

        if (yearParameterWardsChart == null) {
            queryWardsChart.put(LoadProperties.properties.getString("Work.Column.Year"), new BasicDBObject("$in", new int[]{2014, 2015, 2016}));
            for (int i = 2014; i < 2018; i++) {
                yearCheckedWardsChart.put(i, "checked");
            }
        }

        if (yearParameterWardsChart != null) {
            int[] years = new int[yearParameterWardsChart.length];
            for (int i = 0; i < yearParameterWardsChart.length; i++) {
                years[i] = Integer.parseInt(yearParameterWardsChart[i]);

                for (int j = 2014; j < 2018; j++) {
                    if (years[i] == j) {
                        yearCheckedWardsChart.put(j, "checked");
                    }
                }
            }
            queryWardsChart.put(LoadProperties.properties.getString("Work.Column.Year"), new BasicDBObject("$in", years));
        }

        //Minor types chart
        if (yearParameterMinorTypeChart == null) {
            queryMinorTypeChart.append(LoadProperties.properties.getString("Work.Column.Year"), new BasicDBObject("$in", new int[]{2015, 2016, 2017}));
            for (int i = 2014; i < 2018; i++) {
                yearCheckedMinorTypeChart.put(i, "checked");
            }
        }

        if (yearParameterMinorTypeChart != null) {
            int[] years = new int[yearParameterMinorTypeChart.length];
            for (int i = 0; i < yearParameterMinorTypeChart.length; i++) {
                years[i] = Integer.parseInt(yearParameterMinorTypeChart[i]);

                for (int j = 2014; j < 2018; j++) {
                    if (years[i] == j) {
                        yearCheckedMinorTypeChart.put(j, "checked");
                    }
                }
            }
            queryMinorTypeChart.append(LoadProperties.properties.getString("Work.Column.Year"), new BasicDBObject("$in", years));
        }

        if (workTypeParameter != null && workTypeParameter.equals("capital")) {
            queryWardsChart.put(LoadProperties.properties.getString("Work.Column.WorkTypeID"), 1);
        }
        if (workTypeParameter != null && workTypeParameter.equals("maintenance")) {
            queryWardsChart.put(LoadProperties.properties.getString("Work.Column.WorkTypeID"), 2);
        }
        if (workTypeParameter != null && workTypeParameter.equals("emergency")) {
            queryWardsChart.put(LoadProperties.properties.getString("Work.Column.WorkTypeID"), 3);
        }

        Contractor.createContractors();

        ArrayList<Work> works = Work.createWorkObjects(queryWardsChart);

        Ward.createAllWardObjects(works);

        try {
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
    <script src="commonfiles/maps.js"></script>
    <script src="http://maps.googleapis.com/maps/api/js"></script>
    <script>
        var src = 'http://hack4hd.org/data/HD-ward-boundaries.kml';
    </script>
    <script src="https://code.highcharts.com/highcharts.js"></script>
    <script src="https://code.highcharts.com/modules/exporting.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

    <script>
        function initMap() {
            var mapDiv = document.getElementById('map');
            var map = new google.maps.Map(mapDiv, {
                center: new google.maps.LatLng(15.3935685, 75.08009570000002),
                zoom: 15,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scrollwheel: false
            });
            var wardBoundariesLayer = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-ward-boundaries.kml',
                map: map
            });
            var landmarks = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-landmarks.kml',
                map: map
            });
            var hoardings = new google.maps.KmlLayer({
                url: 'http://hack4hd.org/data/HD-hoardings.kml',
                map: map
            })
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

        <div class="btn-group btn-group-justified">
            <a href="<%=baseLink%>&jumbotron=map&" class="btn btn-default round-corner-top-left">Map</a>
            <a href="<%=baseLink%>&jumbotron=wardsDashboard&" class="btn btn-default">Wardwise Dashboard</a>
            <a href="<%=baseLink%>&jumbotron=topContractors&" class="btn btn-default round-corner-top-right">Top
                Contractors</a>
        </div>

        <div class="jumbotron round-corner-bottom" style="padding: 0px; margin: 0px">

            <%
                if (jumbotronParameter != null && jumbotronParameter.equals("map")) {
            %>
            <div id="map" class="round-corner-bottom" style="width:100%; height: 26em; position: relative"></div>
            <%
            } else if ((jumbotronParameter == null && workTypeParameter == null) || jumbotronParameter != null && jumbotronParameter.equals("wardsDashboard")) { %>
            <div id="wardsDashboardChart" style="width:100%; height:26em;"></div>
            <%
            } else if ((jumbotronParameter != null && workTypeParameter == null) && jumbotronParameter.equals("topContractors")) { %>
            <div id="topContractorsChart" style="width:100%; height:26em;"></div>
            <%
                }

                if ((jumbotronParameter == null && workTypeParameter == null) || jumbotronParameter != null && jumbotronParameter.equals("wardsDashboard")) {
            %>
            <form method="post" action="">
                <div class="checkbox">

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="yearWards" value="2015"
                               onchange="this.form.submit()" <%=yearCheckedWardsChart.get(2015)%>> 2015
                    </label>

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="yearWards" value="2016"
                               onchange="this.form.submit()" <%=yearCheckedWardsChart.get(2016)%>> 2016
                    </label>

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="yearWards" value="2017"
                               onchange="this.form.submit()" <%=yearCheckedWardsChart.get(2017)%>> 2017
                    </label>
                </div>
            </form>

            <div class="btn-group btn-group-justified">
                <a href="<%=baseLink%>&jumbotron=wardsDashboard" class="btn btn-default round-corner-bottom-left">All
                    works</a>
                <a href="<%=baseLink%>&jumbotron=wardsDashboard&workType=capital" class="btn btn-default">Capital
                    works</a>
                <a href="<%=baseLink%>&jumbotron=wardsDashboard&workType=maintenance" class="btn btn-default">Maintenance
                    works</a>
                <a href="<%=baseLink%>&jumbotron=wardsDashboard&workType=emergency&"
                   class="btn btn-default round-corner-bottom-right">Emergency works</a>
            </div>
            <%
                }
            %>

        </div>
    </div>

    <div class="panel panel-default round-corner">
        <div class="panel-heading round-corner-top" style="text-align: center">Category-wise Dashboard</div>
        <div class="panel-body round-corner-bottom">
            <div id="minorWorkTypeChart" style="width: 100%; height: 40em"></div>
            <form method="post" action="">
                <div class="checkbox">

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="yearMinorType" value="2015"
                               onchange="this.form.submit()" <%=yearCheckedMinorTypeChart.get(2015)%>> 2015
                    </label>

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="yearMinorType" value="2016"
                               onchange="this.form.submit()" <%=yearCheckedMinorTypeChart.get(2016)%>> 2016
                    </label>

                    <label class="margin-left big-checkbox" style="margin-left: 22%; font-size: 10pt">
                        <input type="checkbox" name="yearMinorType" value="2017"
                               onchange="this.form.submit()" <%=yearCheckedMinorTypeChart.get(2017)%>> 2017
                    </label>
                </div>
            </form>
        </div>
    </div>

    <hr>
    <h3>13th Finance Summary</h3>
    <div class="row" style="height: 20em">
        <%
            for (int year = 2014; year < 2018; year++) {
        %>
        <div class="col-sm-3">
            <div id="13thfinance<%=year%>" class="piechart"></div>
        </div>
        <%
            }
        %>
    </div>
    <hr>
    <h3>14th Finance Summary</h3>
    <div class="row" style="height: 20em">
        <%
            for (int year = 2016; year < 2018; year++) {
        %>
        <div class="col-sm-3">
            <div id="14thfinance<%=year%>" class="piechart"></div>
        </div>
        <%
            }
        %>
    </div>
</div>

<%
    String[] wardDetails = Ward.getWardDetails();

    String allWardsString = wardDetails[0];
    String allWardsAmountSpent = wardDetails[1];
    String allWardsWorks = wardDetails[2];
    String allWardsCompletedWorks = wardDetails[3];
    String allWardsInprogressWorks = wardDetails[4];
    String allWardsPopulation = wardDetails[5];
    String allWardsPerCapitaExpenditure = wardDetails[6];

    String top50contractors = Contractor.getTop50ContractorsNames();
    String top50contractorsAmount = Contractor.getTop50ContractorsAmount();
    String top50contractorsTotalWorks = Contractor.getTop50ContractorsTotalWorks();
    String top50contractorsInprogressWorks = Contractor.getTop50ContractorsInprogressWorks();
    String top50contractorsCompletedWorks = Contractor.getTop50ContractorsCompletedWorks();

    String[] minorWorkTypeDetails = MinorWorkType.getMinorWorkTypeDetails(MinorWorkType.createMinorWorkTypes(queryMinorTypeChart));
    String minorWorkTypeMeanings = minorWorkTypeDetails[0];
    String minorWorkTypeCompletedWorks = minorWorkTypeDetails[1];
    String minorWorkTypeInprogressWorks = minorWorkTypeDetails[2];
    String minorWorkTypeTotalWorks = minorWorkTypeDetails[3];
    String minorWorkTypeAmountSpent = minorWorkTypeDetails[4];

%>
<script>
    $(function () {
        $('#wardsDashboardChart').highcharts({
            chart: {
                type: 'column'
            },
            tooltip: {
                borderRadius: 12,
                animation: true,
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
            title: {
                text: ''
            },
            credits: {
                enabled: true
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
            }
                <%
                if (workTypeParameter == null & yearParameterWardsChart == null || (yearParameterWardsChart != null && yearParameterWardsChart.length == 3)){
                %>
                , {
                    name: 'Population',
                    data: [<%=allWardsPopulation%>],
                    visible: false
                }, {
                    name: 'Per Capita Expenditure',
                    data: [<%=allWardsPerCapitaExpenditure%>],
                    visible: false
                }
                <%
                }
                %>
            ]
        });


        $('#topContractorsChart').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Top 50 Contractors by Amount'
            },
            credits: {
                enabled: true
            },
            xAxis: {
                categories: [<%=top50contractors%>]
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total contract amount',
                data: [<%=top50contractorsAmount%>],
                visible: true

            }, {
                name: 'Total works',
                data: [<%=top50contractorsTotalWorks%>],
                visible: false
            }, {
                name: 'Completed works',
                data: [<%=top50contractorsCompletedWorks%>],
                visible: false
            }, {
                name: 'In progress works',
                data: [<%=top50contractorsInprogressWorks%>],
                visible: false
            }]
        });

        $('#minorWorkTypeChart').highcharts({
            chart: {
                type: 'column'
            },
            tooltip: {
                borderRadius: 12,
                animation: true,
            },
            credits: {
                enabled: true
            },
            title: {
                text: ''
            },
            xAxis: {
                categories: [<%=minorWorkTypeMeanings%>],
                text: 'Wards'
            },
            yAxis: {
                title: {
                    text: 'Magnitude'
                }
            },
            series: [{
                name: 'Total works',
                data: [<%=minorWorkTypeTotalWorks%>],
                visible: true
            }, {
                name: 'Completed works',
                data: [<%=minorWorkTypeCompletedWorks%>],
                visible: true
            }, {
                name: 'In progress works',
                data: [<%=minorWorkTypeInprogressWorks%>],
                visible: true

            }, {
                name: 'Total amount spent',
                data: [<%=minorWorkTypeAmountSpent%>],
                visible: false
            }]
        });

    });
</script>

<script>
    <%
    for (int year = 2013; year < 2018; year++) {
    BasicDBObject finance13 = new BasicDBObject(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"), 43);
    finance13.append(LoadProperties.properties.getString("Work.Column.Year"),year);
    String[] finance13Details = Dashboard.workStatusPieChart(finance13);
    %>
    $(function () {

        $(document).ready(function () {

            // Build the chart
            $('#13thfinance<%=year%>').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: '13th Finance (General Basic) <%=year%>'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    name: 'Number of works',
                    colorByPoint: true,
                    data: [{
                        name: '<%=LoadProperties.properties.getString("StatusCompleted")%>',
                        y: <%=finance13Details[0]%>
                    }, {
                        name: '<%=LoadProperties.properties.getString("StatusInprogress")%>',
                        y: <%=finance13Details[1]%>
                    }]
                }]
            });
        });
    });
    <%
    }
    %>
</script>

<script>
    <%
    for (int year = 2016; year < 2018; year++) {
    BasicDBObject finance14 = new BasicDBObject(LoadProperties.properties.getString("Work.Column.SourceOfFinanceID"), 51);
    finance14.append(LoadProperties.properties.getString("Work.Column.Year"),year);
    String[] finance14Details = Dashboard.workStatusPieChart(finance14);
    %>
    $(function () {

        $(document).ready(function () {

            // Build the chart
            $('#14thfinance<%=year%>').highcharts({
                chart: {
                    plotBackgroundColor: null,
                    plotBorderWidth: null,
                    plotShadow: false,
                    type: 'pie'
                },
                title: {
                    text: '14th Finance (General Basic) <%=year%>'
                },
                tooltip: {
                    pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false
                        },
                        showInLegend: true
                    }
                },
                series: [{
                    name: 'Number of works',
                    colorByPoint: true,
                    data: [{
                        name: '<%=LoadProperties.properties.getString("StatusCompleted")%>',
                        y: <%=finance14Details[0]%>
                    }, {
                        name: '<%=LoadProperties.properties.getString("StatusInprogress")%>',
                        y: <%=finance14Details[1]%>
                    }]
                }]
            });
        });
    });
    <%
    }
    %>
</script>

<%@include file="footer.jsp" %>
<%@include file="contactmodal.jsp" %>

</body>
<%
        System.out.println("Time taken to load : " + (System.currentTimeMillis() - initialTime));
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<%
    } catch (Exception e) {
        System.out.println("Error" + e.getMessage());
        System.out.println("Stacktrace -- ");
        e.printStackTrace();
        String redirectURL = "error.jsp";
        response.sendRedirect(redirectURL);
    }
%>
</html>
