<%@ page import="com.mongodb.BasicDBObject" %>
<%@ page import="smartcity.General" %>
<%@ page import="smartcity.LoginChecks" %>
<%@ page import="smartcity.Work" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 27/06/16
  Time: 5:42 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String referer = request.getHeader("referer");
    String worksPage = "works.jsp?";
    String workIDParameter = StringEscapeUtils.escapeHtml4(request.getParameter("workID"));

    //Use the following checks (full code blocks of if conditions) wherever you want to give access to only authorized users.

    //Checking if the user is logged in to Google
    if (!LoginChecks.isLoggedInGoogle(request)) {
        response.sendRedirect("login.jsp?workID=" + workIDParameter);
    }
    //Checking if the user is NOT authorised from HDMC side.
    //Redirecting to workdetails page because the user is logged in to gmail but is not an authorized user.
    if (!LoginChecks.isAuthorisedUser(request)) {
        session.invalidate();
%>
<script>
    alert("You are not authorised to login. Contact 'inspection.hdmc@gmail.com' to get access.");
    window.location = "workDetails.jsp?workID=" + <%=workIDParameter%>;
</script>
<%
}

//Checking if authorised user is logged in and if true, letting him/her access the page.
else if (LoginChecks.isAuthorisedUser(request)) {
    //String workIDParameter = request.getParameter("workID");

    try {

        BasicDBObject workIDQuery = new BasicDBObject();
        workIDQuery.put(LoadProperties.properties.getString("Work.Column.WorkID"), Integer.parseInt(workIDParameter));
        ArrayList<Work> work = Work.createWorkObjects(workIDQuery);
%>
<html>
<head>
    <title><%=LoadProperties.properties.getString("Allpages.PageTitle")%></title>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="images/<%=LoadProperties.properties.getString("FaviconName")%>" type="image/x-icon"/>
    <script src="commonfiles/sorttable.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap.css">
    <script src="commonfiles/jquery.min.js"></script>
    <script src="commonfiles/bootstrap.min.js"></script>
    <link rel="stylesheet" href="commonfiles/bootstrap-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf-responsive.css">
    <link rel="stylesheet" href="commonfiles/scf.css">
    <script src="commonfiles/dropzone.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/dropzone.css"/>
    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

    <script>
        var Dropzone = require("dropzone");
    </script>
</head>
<body>

<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">
    <%
        if (LoginChecks.isSuperUser(request)) {
    %>
    <div class="btn-group btn-group-justified round-corner" style="margin-bottom: 1.5em">
        <a href="uploadcsv.jsp" class="btn btn-default round-corner">Upload CSV files</a>
    </div>
    <%
        }
    %>
    <div class="panel panel-default round-corner" style="text-align: center">
        <div class="panel-heading round-corner-top">Description</div>
        <div class="panel-body round-corner">
            <a href="workDetails.jsp?workID=<%=workIDParameter%>"><%=General.cleanText(work.get(0).workDescriptionEnglish)%>
            </a>
            <div id="workInfo" class="round-corner" style="width: 100%; position: relative; margin-top: 1em">
                <div class="panel panel-default round-corner">
                    <div class="panel-body round-corner">

                        <table class="table table-striped table-hover" style="font-size: 10pt;">
                            <thead style="text-align: center; padding: 3px">
                            <b>Info</b>
                            </thead>
                            <tbody>
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
                                <td style="text-align: right; width: 50%"> Amount Sanctioned :</td>
                                <td style="text-align: left"><b>
                                    &#8377 <%=General.rupeeFormat(work.get(0).amountSanctionedString)%>
                                </b>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <form name="photos-dropped" action="uploadscript.jsp?workID=<%=workIDParameter%>"
              class="dropzone round-corner pull-left"
              style="border: dashed 4px darkgrey; height: 25em; display: inline-block; width: 49%; overflow:scroll" id="filesDropzone"
              method="post"
              enctype="multipart/form-data">
        </form>
        <form name="kml-dropped" action="uploadscript.jsp?workID=<%=workIDParameter%>"
              class="dropzone round-corner pull-right pull-right"
              style="border: dashed 4px darkgrey; height: 25em; width: 49%; display: inline-block; overflow: scroll" id="kmlDropzone"
              method="post"
              enctype="multipart/form-data">
        </form>
    </div>
    <div class="row">
        <div class="form-group">
            <label class="control-label" for="notes"><h4>Add notes about the work</h4></label>
            <form name="work-notes" action="uploadscript.jsp?workID=<%=workIDParameter%>" method="post" id="notes-form"
                  accept-charset="UTF-8">
                <input name="notes" class="form-control input-lg round-corner" type="text" id="notes"
                       style="width: 100%; overflow: auto">
            </form>
        </div>
    </div>
    <button class="btn btn-default round-corner" style="margin-left: 46%" onclick="submitfiles()">Upload</button>


</div>
<script>
    function logoutAlert() {
        var r = confirm("You will be logged out of Gmail on all the windows. Do you want to continue?");
        if (r == true) {
            window.location = "https://mail.google.com/mail/u/0/?logout&hl=en";
        }
    }

    function submitfiles() {
        document.getElementById("filesDropzone").submit();
        document.getElementById("kmlDropzone").submit();
        document.getElementById("notes-form").submit();
        var count = Dropzone.files.length.toString();
        document.getElementById("number-of-files").value = count;
        document.getElementById("numOfFilesForm").submit();
    }

    Dropzone.options.filesDropzone = {
        dictDefaultMessage: "<i class=\"fa fa-picture-o fa-5\" style='font-size: 25pt' aria-hidden=\"true\"></i> &nbsp; Drag and drop your <b class='text-primary'>images</b> here or click here to browse...",
        acceptedFiles: "image/*"
    };

    Dropzone.options.kmlDropzone = {
        dictDefaultMessage: "<i class=\"fa fa-map-marker fa-5\" style='font-size: 25pt' aria-hidden=\"true\"></i> &nbsp; Drag and drop your <b class='text-primary'>KML</b> files here or click here to browse...",
        acceptedFiles: ".kml"
    }

</script>
<form action="uploadsuccess.jsp" method="post" id="numOfFilesForm">
    <input type="hidden" name="number-of-files" id="number-of-files">
</form>

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
<%
    }
%>
