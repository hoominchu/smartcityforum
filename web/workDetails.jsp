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
        function initMap() {
            var mapDiv = document.getElementById('map');
            var map = new google.maps.Map(mapDiv, {
                zoom: 10,
                mapTypeId: google.maps.MapTypeId.ROADMAP,
                scrollwheel: false
            });
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

    <script src="https://maps.googleapis.com/maps/api/js?key=<%=LoadProperties.properties.getString("GoogleMapsAPIKey")%>&callback=initMap"
            async defer></script>
</head>
<body>

<%@include file="navbar.jsp" %>

<%@include file="header.jsp" %>

<div class="container">

    <div class="panel panel-default round-corner" style="text-align: center">
        <div class="panel-heading round-corner-top">Description</div>
        <div class="panel-body round-corner">
            <%=General.cleanText(work.get(0).workDescriptionEnglish)%>
        </div>
        <%
            if (!subscription) {
        %>
        <%--button to subscribe--%>
        <button id="subscribeButton" class="btn btn-default btn-block round-corner-bottom"
                style="background-color: #D0E9C6; border-width: 0px; font-size: 15px;"
                onclick="subscribe()">Click here to subscribe to this work!
        </button>
        <%
        } else {
        %>
        <%--button to unsubscribe--%>
        <button id="unsubscribeButton" class="btn btn-default btn-block round-corner-bottom"
                style="background-color: #EBCCCC; border-width: 0px; font-size: 15px;"
                onclick="unsubscribe()">Click here to unsubscribe from this work!
        </button>
        <%
            }
        %>
    </div>

    <div class="btn-group btn-group-justified">
        <a href="<%=baseLink%>workID=<%=workIDParameter%>&jumbotron=info"
           class="btn btn-default round-corner-top-left">Work Info</a>

        <%
            if (Work.doesFileExist(rootFolder + workIDParameter + File.separator, ".kml")) {
        %>
        <a href="<%=baseLink%>workID=<%=workIDParameter%>&jumbotron=map" class="btn btn-default round-corner-top-left">Map</a>
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

        <table class="table table-striped table-hover" style="font-size: 10pt; text-align: center">
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
        <h4 style="text-align: center; padding: 15%;"><u><b>Bill not yet paid</b></u></h4>
        <%
            }
        } else if (jumbotronParameter == null || jumbotronParameter.equals("map")) {
        %>
        <div id="map" class="round-corner-bottom" style="width:100%; height: 26em; position: relative"></div>
        <%
        } else if (jumbotronParameter.equals("info")) {
            for (Bill bill : bills) {
                totalBillPaid = totalBillPaid + Integer.parseInt(bill.paidAmount);
            }
        %>
        <div id="workInfo" style="width: 100%; position: relative;">
            <div class="panel panel-default">
                <div class="panel-body">

                    <table class="table table-striped table-hover" style="font-size: 10pt;">
                        <thead>

                        </thead>
                        <tbody>
                        <tr>
                            <td style="text-align: right; width: 50%"> Work ID :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>workID=<%=work.get(0).workID%>"><%=work.get(0).workID%>
                            </a>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Ward :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>wardNumber=<%=work.get(0).wardNumber%>"><%=work.get(0).wardNumber%>
                            </a>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Work Type :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>workTypeID=<%=work.get(0).workTypeID%>"><%=work.get(0).workType%>
                            </a>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Source of Income :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>sourceOfIncomeID=<%=work.get(0).sourceOfIncomeID%>"><%=work.get(0).sourceOfIncome%>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Year :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>year=<%=work.get(0).year%>"><%=work.get(0).year%>
                            </a>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Work Order Date :</td>
                            <td style="text-align: left"><b><%=work.get(0).workOrderDate%>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Work Completion Date :</td>
                            <td style="text-align: left"><b><%=work.get(0).workCompletionDate%>
                            </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right; width: 50%"> Contractor :</td>
                            <td style="text-align: left"><b><a
                                    href="<%=worksPage%>contractorID=<%=work.get(0).contractorID%>"><%=work.get(0).contractor%>
                            </a>
                            </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right; width: 50%"> Contractor's contact :</td>
                            <td style="text-align: left"><b>Not available</b>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right; width: 50%"> Amount Sanctioned :</td>
                            <td style="text-align: left"><b>
                                &#8377 <%=General.rupeeFormat(work.get(0).amountSanctionedString)%>
                            </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="text-align: right; width: 50%"> Amount Paid :</td>
                            <td style="text-align: left"><b><%
                                if (totalBillPaid != 0) { %>
                                &#8377 <%=General.rupeeFormat(Integer.toString(totalBillPaid))%>
                                <%
                                } else {
                                %>
                                Bill not yet paid
                                <%
                                    }
                                %>
                            </b>
                            </td>
                        </tr>

                        <tr class="<%=statusColorParameter%>">
                            <td style="text-align: right; width: 50%"> Status :</td>
                            <td style="text-align: left"><b
                                    style="color: <%=work.get(0).statusColor%>"><%=work.get(0).statusfirstLetterCapital%>
                            </b>
                            </td>
                        </tr>
                        <%
                            if (work.get(0).statusfirstLetterCapital.equalsIgnoreCase(LoadProperties.properties.getString("StatusCompleted"))) {
                        %>
                        <tr>
                            <td style="width: 50%; padding-top: 12px; height: 2em; text-align: center; font-size: 10pt">
                                If you are
                                unsatisfied with the quality of this work or have any other complaints, <a
                                    href="http://www.mrc.gov.in/janahita/LoadGrievanceForm"> click here.</a></td>
                        </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
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