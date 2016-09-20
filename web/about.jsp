<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 08/06/16
  Time: 2:06 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    try {
%>
<html>
<head>
    <title><%=LoadProperties.properties.getString("Allpages.PageTitle")%></title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/<%=LoadProperties.properties.getString("FaviconName")%>" type="image/x-icon"/>
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <script src="commonfiles/jquery.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

</head>
<body>
<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">
    <hr>
    <h2>About the project</h2>
    <div class="row">
        <div class="col-xs-8">
            <div id="about-project">
                <p>The Smart City Forum project helps local governments be transparent and get feedback from citizens about their public works. It is based on the principle of open data and citizen participation in local government. As a demonstration, it is being deployed with the data provided by the Hubballi-Dharwad Municipal Corporation (HDMC) in the state of Karnataka in India at <a href="http://hack4hd.org/smartcity">hack4hd.org</a>.</p>

                <p>This project has two main uses. The first use is for city administrators and local political leaders to track their own works and spending, leading to more clarity in decision-making. For example, city managers can look at the dashboard of ongoing works, get information about ward wise expenditure, funding patterns, visualize various parameters on a map, etc. They can also monitor the works by checking both official and citizen-submitted images and comments.</p>

                <p>The second use is for citizens to actively track what is happening around them in their city. A citizen can easily find information about publicly funded works in their ward, or anywhere else. For example, people can get information on the detailed work specifications, funding for the work, precise GPS coordinates of the work, etc. Further, they can directly comment on works and upload their own pictures to give accurate, on-the-ground feedback to city officials, and discuss the project with other citizens.</p>

                <p>Other cities can easily adopt this software by plugging in their data in a simple, CSV based format. It is free and open source. Contact Prof. Hangal at the Trivedi Center for Political Data (hangal@ashoka.edu.in) for more information. Software developers interested in contributing extensions are also welcome.</p>

                <p>This project was started as a part of a Smart City Hackathon held in Hubballi Dharwad (hack4hd.org), and developed further by the Trivedi Center for Political Data.</p>

                <p>Citizens of Hubballi-Dharwad are invited to give us feedback, suggestions and comments via email at inspection.hdmc@gmail.com.</p>
            </div>
        </div>
        <div class="col-xs-4">
            <img src="images/scf_color.png" width="80%" style="margin-top: 30%">
        </div>
    </div>
    <hr>
    <h2>Features</h2>

    <div class="about-images" style="height: 37em;">
        <div class="about-slide slick-slide"><img src="images/about/map.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Maps to show the location of the work</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/chart.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Dynamic dashboards</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/citizen_comments.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Citizen's feedback through photos and comments</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/overview_and_works.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Overview and description of works</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/work_info.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>List of all works with their information</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/bill_details.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Details of the work and bills paid</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/geolocation_of_photos.png"
                                                  style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Locate geotagged photos on map</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/official_comments.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Official comments about the work</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/info_upload.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Easy uploading of images, maps and notes</h3></div>
        </div>
        <div class="about-slide slick-slide"><img src="images/about/corporator_info.png" style="height: 31em"
                                                  class="round-corner shadow-box">
            <div class="about-description"><h3>Corporator's info made accessible</h3></div>
        </div>
    </div>

    <hr style="margin-top: 3em">

    <!--
    <h2>People</h2>
    <div style="margin-top: 3em">
        <div class="row">
            <div class="col-sm-4">
                <img src="images/about/minchu.jpg" class="img-circle" height="160px" width="160px"
                     style="margin-left: 25%">
                <div class="name">Minchu Kulkarni</div>
                <div class="designation">Designer and Developer</div>
                <div class="about-person text-muted">
                    <small>
                        Minchu is studying computer science at Ashoka University.
                    </small>
                </div>
            </div>
            <div class="col-sm-4">
                <img src="images/about/mrinalini.jpg" class="img-circle" height="160px" width="160px"
                     style="margin-left: 25%">
                <div class="name">Mrinalini Kalkeri</div>
                <div class="designation">Project Head</div>
                <div class="about-person text-muted">
                    <small>
                        Mrinalini Kalkeri heads the MIS Cell at Hubli-Dharwad Municipal Corporation.
                    </small>
                </div>
            </div>

            <div class="col-sm-4">
                <img src="images/about/mrinalini.jpg" class="img-circle" height="160px" width="160px"
                     style="margin-left: 25%">
                <div class="name">Mrinalini Kalkeri</div>
                <div class="designation">Project Head</div>
                <div class="about-person text-muted">
                    <small>
                        Prof. Hangal got his Ph.D. in Computer Science at Stanford University, where he worked on social
                        computing and human-computer interaction in the Mobisocial and HCI Labs.His thesis explored
                        novel
                        applications for the digital life-logs that millions of consumers are collecting. Prof. Hangal
                        has also
                        worked on multiprocessor computer architecture, virtual machine compilers, software engineering
                        and
                        debugging tools.
                    </small>
                </div>
            </div>

        </div>
    </div>

    <hr>
    -->

    <h2>In collaboration with</h2>
    <div style="margin: 1em; display: block;">
        <div class="row">
            <div class="col-xs-5">
                <a href="http://tcpd.ashoka.edu.in" target="_blank"><img src="images/about/TCPD-Logo.png" height="80px" style="margin-bottom: 3em;"></a>
            </div>
        </div>
    </div>
    <br>
    <hr>
    <h4>Open source libraries and plugins used</h4>
    <div style="margin: 1em">
        <div class="row">
            <div class="col-xs-2">
                Highcharts
            </div>
            <div class="col-xs-2">
                Font Awesome
            </div>
            <div class="col-xs-2">
                dropzone.js
            </div>
            <div class="col-xs-2">
                MongoDB
            </div>
            <div class="col-xs-2">
                Tomcat
            </div>
            <div class="col-xs-2">
                Disqus
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        $('.about-images').slick({
            slidesToShow: 1,
            slidesToScroll: 1,
            dots: true,
            arrows: true,
            autoplay: true,
            centerMode: true,
            variableWidth: true,
            zindex: -100,
            adaptiveHeight: true,
            autoplaySpeed: 6500,
            centerPadding: '80px',
            pauseOnHover: false
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
