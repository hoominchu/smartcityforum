<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 12/04/16
  Time: 10:20 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java"
         import="com.mongodb.DBCursor"
         import="org.apache.commons.lang3.StringEscapeUtils"
         import="smartcity.*"
%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.ArrayList" %>

<%
    try {
        String email = (String) session.getAttribute("email");
        Boolean subscription = false;

        String rootFolder;
        if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
            rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataOnWeb");
        } else {
            rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataLocal");
        }

        String workIDParameter = StringEscapeUtils.escapeHtml4(request.getParameter("workID"));

        //checking if the person is subscribed to the work if logged in
        if (email != null) {
            Alerts alerts = new Alerts();
            subscription = alerts.checkIfSubscribedToField1(email, Integer.parseInt(workIDParameter));
        }

        String jumbotronParameter = StringEscapeUtils.escapeHtml4(request.getParameter("jumbotron"));

        String baseLink = "workDetails.jsp?";
        String worksPage = "works.jsp?";

        String imagePath = rootFolder + workIDParameter + File.separator;

        BasicDBObject workIDQuery = new BasicDBObject();

        workIDQuery.put(LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(workIDParameter));

        ArrayList<Work> work = Work.createWorkObjects(workIDQuery);

        BasicDBObject billPaidQuery = new BasicDBObject();
        billPaidQuery.put(LoadProperties.properties.getString("Bill.Column.WorkID"), Integer.parseInt(workIDParameter));
        ArrayList<Bill> bills = Bill.createBills(billPaidQuery);

        int totalBillPaid = 0;

        String statusColorParameter;
        if (work.get(0).statusFirstLetterSmall.equalsIgnoreCase(LoadProperties.properties.getString("StatusInprogress"))) {
            statusColorParameter = "danger";
        } else {
            statusColorParameter = "success";
        }
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

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

    <!-- Add mousewheel plugin (this is optional) -->
    <script type="text/javascript" src="commonfiles/fancybox/lib/jquery.mousewheel-3.0.6.pack.js"></script>

    <!-- Add fancyBox -->
    <link rel="stylesheet" href="commonfiles/fancybox/source/jquery.fancybox.css?v=2.1.5" type="text/css"
          media="screen"/>
    <script type="text/javascript" src="commonfiles/fancybox/source/jquery.fancybox.pack.js?v=2.1.5"></script>

    <!-- Optionally add helpers - button, thumbnail and/or media -->
    <link rel="stylesheet" href="commonfiles/fancybox/source/helpers/jquery.fancybox-buttons.css?v=1.0.5"
          type="text/css" media="screen"/>
    <script type="text/javascript"
            src="commonfiles/fancybox/source/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>
    <script type="text/javascript" src="commonfiles/fancybox/source/helpers/jquery.fancybox-media.js?v=1.0.6"></script>

    <link rel="stylesheet" href="commonfiles/fancybox/source/helpers/jquery.fancybox-thumbs.css?v=1.0.7" type="text/css"
          media="screen"/>
    <script type="text/javascript" src="commonfiles/fancybox/source/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>

    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>


    <script>
        <%
            if (work.get(0).hasLocation){
            %>
        function initMap() {
            var mapDiv = document.getElementById('map');
            var myLatLng = {lat: <%=work.get(0).latitude%>, lng: <%=work.get(0).longitude%>};
            var map = new google.maps.Map(mapDiv, {
                zoom: 16,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scrollwheel: false,
                center: myLatLng
            });

            var marker = new google.maps.Marker({
                position: myLatLng,
                map: map,
                title: '<%=work.get(0).workDescriptionFinal%>'
            });
            <%
            }
            %>
            <%
            File workDir = new File(imagePath).getCanonicalFile();
            File[] files = workDir.listFiles();
            if (files != null) {
                for (File file : files) {
                    if (file.getName().endsWith(".kml")) {
            %>
            var workKML<%=file.getName().substring(0,file.getName().indexOf("."))%> = new google.maps.KmlLayer({
                url: '<%=LoadProperties.properties.getString("PathToKMLFilesRootFolder")%><%=workIDParameter%><%=File.separator%><%=file.getName()%>',
                map: map
            });

            <%
                    }
                }
            }
            %>
        }
    </script>

    <%--Javascript funcitons for subscribe and unsubscribe--%>
    <script>
        function subscribe() {
            document.getElementById("subscribeButton").disabled = true;
            window.location = "subscribe.jsp?unsubscribe=false&workID=<%=workIDParameter%>"
        }
        function unsubscribe() {
            document.getElementById("unsubscribeButton").disabled = true;
            window.location = "subscribe.jsp?unsubscribe=true&workID=<%=workIDParameter%>"
        }
    </script>

    <script>
        var x = document.getElementById("localert");

        function getLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(submitPosition, errorMessage, {enableHighAccuracy: true});
            }
        }

        function errorMessage() {
            x.innerHTML = "Geolocation is not supported by this browser.";
        }

        function submitPosition(position) {
            document.getElementById("lat").value = position.coords.latitude;
            document.getElementById("long").value = position.coords.longitude;
            document.getElementById("locationform").submit();
        }

        function deleteLocation() {
            document.getElementById("deletelocationform").submit();
        }
    </script>

    <script src="https://maps.googleapis.com/maps/api/js?key=<%=LoadProperties.properties.getString("GoogleMapsAPIKey")%>&callback=initMap"
            async defer></script>
</head>
<body>

<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<form action="location.jsp" name="locationform" id="locationform" method="post">
    <input type="hidden" name="lat" id="lat" value="">
    <input type="hidden" name="long" id="long" value="">
    <input type="hidden" name="workID" id="workID" value="<%=request.getParameter("workID")%>">
</form>

<form action="location.jsp" name="deletelocationform" id="deletelocationform" method="post">
    <input type="hidden" name="workID" value="<%=request.getParameter("workID")%>">
</form>

<div class="container">

    <div class="panel panel-default round-corner" style="text-align: center">
        <div class="panel-heading round-corner-top">Description</div>
        <div class="panel-body round-corner">
            <%=General.cleanText(work.get(0).workDescriptionEnglish)%>
        </div>

        <div class="btn-group btn-group-justified">
            <%
                if (!subscription) {
            %>
            <a href="#" id="subscribeButton" class="btn btn-default round-corner-bottom-left"
               style="background-color: #D0E9C6; border-width: 0px; font-size: 15px;"
               onclick="subscribe()">Click here to subscribe to this work!</a>
            <%
            } else {
            %>
            <a href="#" id="unsubscribeButton" class="btn btn-default round-corner-bottom-left"
               style="background-color: #EBCCCC; border-width: 0px; font-size: 15px;"
               onclick="unsubscribe()">Click here to unsubscribe to this work!</a>
            <%
                }
                if (LoginChecks.isAuthorisedUser(request)) {
                    if (work.get(0).hasLocation) {
            %>
            <a href="#" data-toggle="modal" data-target=".add-location-modal"
               class="btn btn-default round-corner-bottom-right"
               style="border-width: 0px; font-size: 15px; background-color: #F58471">Update the location of this
                work</a>
            <%
            } else {
            %>
            <a href="#" data-toggle="modal" data-target=".add-location-modal"
               class="btn btn-primary round-corner-bottom-right"
               style="border-width: 0px; font-size: 15px; background-color: #5BC0DE">Tag this work with location</a>
            <%
                    }
                }
            %>
        </div>
    </div>

    <div class="btn-group btn-group-justified">
        <a href="#"
           class="btn btn-default round-corner-top">Work Info</a>

        <%
            if ((Work.doesFileExist(rootFolder + workIDParameter + File.separator, ".kml")) || (work.get(0).hasLocation)) {
        %>
        <%--<a href="<%=baseLink%>workID=<%=workIDParameter%>&jumbotron=map" class="btn btn-default round-corner-top-right">Map</a>--%>
        <%
            }
        %>
        <%
            if (work.get(0).billPaid > 0) {
        %>
        <a href="<%=baseLink%>workID=<%=workIDParameter%>&jumbotron=billDetails"
           class="btn btn-default round-corner-top-right">Billing Details</a>
        <%
            }
        %>
    </div>

    <div class="jumbotron round-corner-bottom" style="padding: 0; margin-bottom: 2em">
        <%
            if (jumbotronParameter == null || jumbotronParameter.equals("billDetails")) {

                if (bills.size() > 0) {
        %>

        <table class="table table-striped table-hover" style="font-size: 10pt;">
            <thead>

            </thead>
            <tbody style="width: 100%;">
            <tr>
                <td> Main Category : <b><%=bills.get(0).mainCategory%>
                </b>
                </td>
            </tr>

            <tr>
                <td> Passed Category : <b><%=bills.get(0).passedCategory%>
                </b>
                </td>
            </tr>

            <tr>
                <td> Contractor : <b><%=bills.get(0).contractor%>
                </b>
                </td>
            </tr>
            </tbody>
        </table>
        <hr>
        <table class="table table-striped table-hover" style="font-size: 10pt; text-align: center">
            <thead>
            <tr>
                <th style="text-align: center"> Sl No.</th>
                <th style="text-align: center"> Description</th>
                <th style="text-align: center"> Pass Date</th>
                <th style="text-align: center"> Pass Amount</th>
                <th style="text-align: center"> Paid Date</th>
                <th style="text-align: center"> Paid Amount</th>
            </tr>
            </thead>
            <tbody>
            <%
                int slno = 0;
                for (Bill bill : bills) {
                    slno++;
                    totalBillPaid = totalBillPaid + Integer.parseInt(bill.paidAmount);
            %>
            <tr>
                <td><%=slno%>
                </td>
                <td><%=bill.descriptionEnglish%>
                </td>

                <td><%=bill.billPassDate%>
                </td>

                <td>&#8377 <%=General.rupeeFormat(bill.billPassAmount)%>
                </td>

                <td><%=bill.paidDate%>
                </td>

                <td>&#8377 <%=General.rupeeFormat(bill.paidAmount)%>
                </td>
            </tr>

            <%
                }
            %>
            </tbody>
        </table>
        <hr>
        <table>
            <tbody>
            <tr style="padding-bottom: 10px; text-align: center">
                Total bill paid : <b>&#8377 <%=General.rupeeFormat(Integer.toString(totalBillPaid))%>
            </b>
            </tr>
            </tbody>
        </table>
        <%
        } else {
        %>
        <%--<h4 style="text-align: center; padding: 15%;"><u><b>Bill not yet paid</b></u></h4>--%>
        <%
            }
        } else if (jumbotronParameter == null || jumbotronParameter.equals("map")) {
        %>
        <%--<div id="map" class="round-corner-bottom" style="width:100%; height: 26em; position: relative"></div>--%>
        <%
        } else if (jumbotronParameter.equals("info") || jumbotronParameter.equals("map") || jumbotronParameter == null) {
            for (Bill bill : bills) {
                totalBillPaid = totalBillPaid + Integer.parseInt(bill.paidAmount);
            }
        %>
        <div id="workInfo" style="width: 100%; position: relative;">
            <div class="panel panel-default round-corner-bottom">
                <div class="panel-body">
                    <div class="row">
                        <div class="col-sm-3 round-corner" style="overflow: auto;">
                            <div class="list-group round-corner">
                                <a href="#"
                                   class="list-group-item round-corner-top">
                                    Work ID <span class="badge"><%=work.get(0).workID%></span>
                                </a>
                                <a href="<%=worksPage%>wardNumber=<%=work.get(0).wardNumber%>" class="list-group-item">Ward <span class="badge"><%=work.get(0).wardNumber%></span>
                                </a>
                                <a href="<%=worksPage%>workTypeID=<%=work.get(0).workTypeID%>" class="list-group-item">Work
                                    Type <span class="badge"><%=work.get(0).workType%></span>
                                </a>
                                <a href="<%=worksPage%>sourceOfIncomeID=<%=work.get(0).sourceOfIncomeID%>" class="list-group-item">Source of Income <span class="badge"><%=work.get(0).sourceOfIncome%></span>
                                </a>
                                <a href="<%=worksPage%>year=<%=work.get(0).year%>" class="list-group-item">Year <span class="badge"><%=work.get(0).year%></span>
                                </a>
                                <a href="#" class="list-group-item">Work
                                    Order Date <span class="badge"><%=work.get(0).workOrderDate%></span>
                                </a>
                                <a href="<%=worksPage%>workTypeID=<%=work.get(0).workTypeID%>" class="list-group-item">Work Completion Date <span class="badge"><%=work.get(0).workCompletionDate%></span>
                                </a>
                                <a href="<%=worksPage%>contractorID=<%=work.get(0).contractorID%>" class="list-group-item">Contractor <span class="badge"><%=work.get(0).contractor%></span>
                                </a>
                                <a href="<%=worksPage%>workTypeID=<%=work.get(0).workTypeID%>" class="list-group-item">Contractor's contact <span class="badge">To be updated</span>
                                </a>
                                <a href="#" class="list-group-item">Amount Sanctioned : <span class="badge"><%=General.rupeeFormat(work.get(0).amountSanctionedString)%></span>
                                </a>
                                <a href="#" class="list-group-item">Amount paid :
                                    <%
                                    if (totalBillPaid != 0) { %>
                                    <span class="badge">&#8377 <%=General.rupeeFormat(Integer.toString(totalBillPaid))%></span>
                                    <%
                                    } else {
                                    %>
                                    <span class="badge">Bill not yet paid</span>
                                    <%
                                    }
                                    %>
                                </a>
                                <a href="#" class="list-group-item">Status <span class="badge"><%=work.get(0).statusfirstLetterCapital%></span>
                                </a>
                            </div>
                        </div>
                        <%
                            if (work.get(0).hasLocation) {
                        %>
                        <div class="col-sm-9 round-corner">
                            <div id="map" class="round-corner"
                                 style="width:100%; height: 29.75em; position: relative; text-align: center"></div>
                        </div>
                        <%
                            } else {
                        %>
                        <div class="col-sm-9 round-corner">
                            <div id="messagebox" class="round-corner"
                                 style="width:100%; height: 29.75em; position: relative; text-align: center"><p class="text-muted" style="font-size:12pt; padding-top: 25%">Map not available for this work</p></div>
                        </div>
                        <%
                            }
                        %>
                    </div>

                </div>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <%
        if (Database.workDetails.find(workIDQuery).size() > 0) {
    %>
    <table class="table-striped table-responsive sortable" id="myTable"
           style="margin-top:2em; width: 100%; min-width: 750px; table-layout: fixed">
        <thead>
        <tr>
            <th style="width: 3%; padding: 2px; text-align: center">Sl No.</th>
            <th style="width: 40%; padding: 2px; text-align: center">Work Details</th>
            <th style="width: 6%; padding: 2px; text-align: center">Measurement</th>
            <th style="width: 6%; padding: 2px; text-align: center">Unit</th>
            <th style="width: 10%; padding: 2px; text-align: center">Rate</th>
            <th style="width: 7%; padding: 2px; text-align: center">Amount</th>
        </tr>
        </thead>
        <tbody>

        <%
            //WorkResults wr = mymethod(request);
            Double totalSpent = 0.0;
            try {
                ArrayList<WorkDetails> workDetails = WorkDetails.createWorkDetails(workIDQuery);

                for (WorkDetails workDetail : workDetails) {
                    String stepNumber = workDetail.stepNumber;
                    String workStep = workDetail.workStep;
                    String measurement = workDetail.measurement;
                    String unit = workDetail.unit;
                    String rate = workDetail.rate;

                    Double totalAmount = workDetail.totalAmount;
                    Double truncatedTotal = workDetail.truncatedTotal;
                    String totalAmountString = workDetail.totalAmountString;

                    totalSpent = totalSpent + truncatedTotal;
        %>
        <tr>
            <td style="text-align: center"><%=stepNumber%>
            </td>
            <td style="padding: 1.2em"><%=workStep%>
            </td>
            <td style="text-align: center"><%=measurement%>
            </td>
            <td style="text-align: center"><%=unit%>
            </td>
            <td style="text-align: center"><%=rate%>
            </td>
            <td style="text-align: center"><%=General.rupeeFormat(totalAmountString)%>
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
    <h4>Total amount spent is &#8377 <%=General.rupeeFormat(Long.toString(totalSpent.longValue()))%>
    </h4>
    <%
        }
        File imageDir = new File(imagePath).getCanonicalFile();
        File[] workFiles = imageDir.listFiles();
    %>
    <hr>
    <h4><b>Official photos
        <%
            if (session.getAttribute("email") != null) {
        %>
        <span class="pull-right"><small> Hello, <%=session.getAttribute("nameOfUser")%>!</small></span><br><span
                class="pull-right"><a href="upload.jsp?workID=<%=workIDParameter%>" onclick="">Submit info</a></span>
        <%
            }
        %>
    </b></h4>
    <%
        if (!(Work.doesFileExist(rootFolder + workIDParameter + File.separator, ".jpg") || Work.doesFileExist(rootFolder + workIDParameter + File.separator, ".png"))) {
    %>
    <p class="text-warning">Photos yet to be uploaded</p>
    <%
    } else {
    %>
    <div class="work-images" style="height: 20em; margin-top: 2.5em; margin-bottom: 2.5em">

        <%
            if (workFiles != null) {
                for (File file : workFiles) {
                    if (!file.getName().endsWith(".kml") && !file.getName().startsWith(".")) {

                        String gpsLocation[] = ExifExtractor.getGPSCoordinatesOfJPEG(file);
                        String latitudeRef = gpsLocation[0];
                        String latitude = gpsLocation[1];
                        String longitudeRef = gpsLocation[2];
                        String longitude = gpsLocation[3];

                        String uploadDateNTime = ExifExtractor.getLastModifiedDateNTime(file);
        %>
        <div class="slick-slide">
            <a href="../smartcityData/works/<%=workIDParameter%>/<%=file.getName()%>" class="fancybox round-corner"
               rel="group"><img src="../smartcityData/works/<%=workIDParameter%>/<%=file.getName()%>"
                                class="round-corner"
                                style="height: 18em"></a>
            <i class="fa fa-cloud-upload" aria-hidden="true"></i>
            <small>&nbsp;<%=uploadDateNTime%>
            </small>
            <%
                if (latitude.length() > 1) {
            %>
            <small>
                &nbsp;&nbsp;|&nbsp;&nbsp;
                <a href="http://maps.google.com/maps?z=8&t=h&q=loc:<%=Geolocation.convertDegreetoDecimal(latitude, latitudeRef)%>+<%=Geolocation.convertDegreetoDecimal(longitude, longitudeRef)%>"
                   target="_blank">Map&nbsp;<i class="fa fa-map-marker" aria-hidden="true"></i>&nbsp;<i
                        class="fa fa-external-link" aria-hidden="true"></i>
                </a></small>
            <%
                }
            %>
        </div>
        <%
                    }
                }
            }
        %>
    </div>
    <%
        }
    %>
    <%
        try {
            DBCursor cursor = Database.workNotes.find(new BasicDBObject("Work ID", workIDParameter));
            if (cursor.size() != 0) {
    %>
    <hr>
    <h4><b>Official notes</b></h4>
    <div class="well round-corner">
        <%

            int slno = 1;
            //String notes = "There are no official notes for this work yet. If you have any feedback, please comment below.";

            while (cursor.hasNext()) {
                DBObject note = cursor.next();

                String notes = note.get("Notes") != null ? note.get("Notes").toString() : "null";

                //Cleaning notes and making it safe for HTML output
                String submittedBy = note.get("Submitted by") != null ? note.get("Submitted by").toString() : "null";
                String time = note.get("Time") != null ? note.get("Time").toString() : "null";
                String date = note.get("Date") != null ? note.get("Date").toString() : "null";

        %>
        <%=slno%>. <%=notes%>
        <small> &mdash; by <strong><%=submittedBy%>
        </strong> <em>at</em> <%=time%> <em>on</em> <%=date%>
        </small>
        <br>
        <%
                slno++;
            }
        %>
    </div>
    <%
        }
    %>
    <%
        } catch (Exception e) {
            System.out.println("Error from workDetails.jsp, notes section");
            System.out.println("Error message : " + e.getMessage());
            System.out.println("Cause : " + e.getCause());
            e.printStackTrace();
        }
    %>


    <hr>
    <h4><b>Citizens' feedback</b></h4>
    <div id="disqus_thread"></div>

    <script>
        /**
         * RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
         * LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables
         */

        var disqus_config = function () {
            //this.page.url = URL; // Replace PAGE_URL with your page's canonical URL variable
            this.page.identifier = <%=workIDParameter%>; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
        };

        (function () { // DON'T EDIT BELOW THIS LINE
            var d = document, s = d.createElement('script');

            s.src = '<%=LoadProperties.properties.getString("Disqus.linkTojs")%>';

            s.setAttribute('data-timestamp', +new Date());
            (d.head || d.body).appendChild(s);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript" rel="nofollow">comments
        powered by Disqus.</a></noscript>

</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('.work-images').slick({
            slidesToShow: 3,
            slidesToScroll: 1,
            dots: true,
            arrows: true,
            variableWidth: true,
            zindex: -100,
            infinite: false
        });
    });
</script>

<script type="text/javascript">
    $(document).ready(function () {
        $(".fancybox").fancybox({
            autoSize: true,
            autoWidth: true,
            autoHeight: true,
            fitToView: true,
            padding: 5,
            arrows: true,
            loop: false
        });
    });
</script>

<div class="modal fade add-location-modal">
    <div class="modal-dialog">
        <div class="modal-content round-corner">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Add or update location</h4>
            </div>
            <div class="modal-body">
                <form action="location.jsp" name="locationform" id="locationform" method="post">
                    <%
                        String latitude = "";
                        String longitude = "";

                        if (work.get(0).hasLocation) {
                            latitude = work.get(0).latitude;
                            longitude = work.get(0).longitude;
                        }
                    %>
                    <div class="form-group round-corner">
                        <label class="control-label round-corner" for="latitudeinput">Latitude</label>
                        <input class="form-control round-corner" name="lat" id="latitudeinput" type="text"
                               value="<%=latitude%>">
                    </div>
                    <div class="form-group round-corner">
                        <label class="control-label round-corner" for="longitudeinput">Longitude</label>
                        <input class="form-control round-corner" name="long" id="longitudeinput" type="text"
                               value="<%=longitude%>">
                    </div>
                    <input type="hidden" name="workID" value="<%=request.getParameter("workID")%>">
                    <div class="row">
                        <div class="col-xs-4"></div>
                        <input type="submit" class="btn btn-primary round-corner col-xs-4">
                        <div class="col-xs-4"></div>
                    </div>

                </form>
                <hr>
                <h4 class="text-muted" style="text-align: center">or</h4>
                <div class="row">
                    <div class="col-xs-3"></div>
                    <a href="#" onclick="getLocation()" class="btn btn-primary round-corner col-xs-6"
                       style="font-size: 15px; background-color: #5AB5D2">Use your GPS location</a>
                    <div class="col-xs-3"></div>
                </div>
                <%
                    if (work.get(0).hasLocation) {
                %>
                <hr>
                <h4 class="text-muted" style="text-align: center">or</h4>
                <div class="row">
                    <div class="col-xs-3"></div>
                    <a href="#" onclick="deleteLocation()" class="btn btn-danger round-corner col-xs-6"
                       style="font-size: 15px; background-color: #F58471">Remove location</a>
                    <div class="col-xs-3"></div>
                </div>
                <%
                    }
                %>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default round-corner" data-dismiss="modal">Close</button>
            </div>
        </div>
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