<%
    session.setAttribute("email", null);
    session.setAttribute("nameOfUser", null);
    session.setAttribute("userID", null);

    String redirectLink = request.getHeader("Referer");

    //checking if referer is profile.jsp. If yes redirecting to browse.jsp to avoid looping.
    if (redirectLink.endsWith("profile.jsp")) {
        redirectLink = "browse.jsp";
    }
%>

<script>
    window.location = '<%=redirectLink%>'
</script>