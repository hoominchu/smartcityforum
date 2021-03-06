<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileInputStream" %><%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 27/06/16
  Time: 2:53 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String redirectLink = "";
    String workIDParameter = request.getParameter("workID");
    if (workIDParameter != null) {
        redirectLink = "upload.jsp?workID="+workIDParameter;
    }
    else if (workIDParameter == null) {
        System.out.println(request.getHeader("Referer"));
        redirectLink = request.getHeader("Referer");
    }
    try {
        String clientID;
        if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
            clientID = LoadProperties.properties.getString("OAuthClientIDforWeb");
        }
        else {
            clientID = LoadProperties.properties.getString("OAuthClientIDforLocalHost");
        }
%>
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

    <meta name="google-signin-scope" content="profile email">
    <meta name="google-signin-client_id"
          content="<%=clientID%>">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

</head>
<body>

<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">
    <div class="row" style="text-align: center">
        <h3 style="padding-top: 2%">Sign in using Google Account</h3><br><br>
        <div class="g-signin2" data-onsuccess="onSignIn" data-theme="dark" style="margin-left: 45%; margin-bottom: 15%; position: relative"></div>
    </div>
</div>

<%@include file="footer.jsp" %>
<%@include file="contactmodal.jsp" %>

<script>
    function onSignIn(googleUser) {
        // Useful data for your client-side scripts:
        var profile = googleUser.getBasicProfile();
        console.log("ID: " + profile.getId()); // Don't send this directly to your server!
        console.log('Full Name: ' + profile.getName());
        console.log('Given Name: ' + profile.getGivenName());
        console.log('Family Name: ' + profile.getFamilyName());
        console.log("Image URL: " + profile.getImageUrl());
        console.log("Email: " + profile.getEmail());

        // The ID token you need to pass to your backend:
        var id_token = googleUser.getAuthResponse().id_token;
        console.log("ID Token: " + id_token);
        var url = "ajax/checkAuth.jsp";

        $.ajax({
            type: 'POST',
            url: url,
            contentType: "application/x-www-form-urlencoded; charset=UTF-8",
            dataType: "json",
            data: {id: googleUser.getAuthResponse().id_token},
            success: function (response) {
                $('#info-modal .modal-title #spinner').remove();
                if (response && response.status == 0) {
                    //location.pathname = location.pathname.replace(/(.*)\/[^/]*/, "$1/"+ 'dashboard');
                    window.location = "<%=redirectLink%>";
                }
                else {
                    //LOG("Showing error");
                    alert('Error: ' + response.error);
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert('There was an unexpected error in connecting to the server');
            }
        });
    }
</script>
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
