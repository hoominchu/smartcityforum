<%
    session.setAttribute("email", null);
    session.setAttribute("nameOfUser", null);
    session.setAttribute("userID", null);

    String redirectLink = request.getHeader("Referer");
%>

<script>
    window.location = '<%=redirectLink%>'
</script>