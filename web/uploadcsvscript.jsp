<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 28/06/16
  Time: 12:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="smartcity.LoginChecks" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="smartcity.LoadProperties" %>
<%
    try {
        //Use the following checks (full code blocks of if conditions) wherever you want to give access to only authorized users.

        //Checking if the user is logged in to Google
        if (!LoginChecks.isLoggedInGoogle(request)) {
            response.sendRedirect("logincsv.jsp");
        }
        //Checking if the user is NOT a superuser from HDMC side.
        //Redirecting to workdetails page because the user is logged in to gmail but is not a super user.
        if (!LoginChecks.isSuperUser(request)) {
            session.invalidate();
%>
<script>
    alert("You are not authorised to login. Contact 'inspection.hdmc@gmail.com' to get access.");
    window.location = "index.jsp";
</script>
<%
}
//Checking if authorised user is logged in and if true, letting him/her access the page.
else if (LoginChecks.isSuperUser(request)) {

            //Uploading images and KML files on the server
            int MAX_MEMORY_SIZE = 1024 * 1024 * 50;
            final int MAX_REQUEST_SIZE = 1024 * 1024 * 50;
            DiskFileItemFactory factory = new DiskFileItemFactory();
            // Sets the size threshold beyond which files are written directly to disk.
            factory.setSizeThreshold(MAX_MEMORY_SIZE);
            // Sets the directory used to temporarily store files that are larger
            // than the configured size threshold. We use temporary directory for java
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            // constructs the folder where uploaded file will be stored

            String rootFolder;
            if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
                rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataOnWeb");
            } else {
                rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataLocal");
            }

            String uploadFolder = rootFolder;
            // Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);
            // Set overall request size constraint
            upload.setSizeMax(MAX_REQUEST_SIZE);
            try {
                // Parse the request
                List items = upload.parseRequest(request);
                for (Object item1 : items) {
                    FileItem item = (FileItem) item1;
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();
                        String filePath = uploadFolder + File.separator + fileName;
                        File uploadedFile = new File(filePath);
                        // saves the file to upload directory
                        item.write(uploadedFile);
                    }
                }
                response.sendRedirect("uploadsuccesscsv.jsp");
            } catch (Exception e) {
                System.out.println("Error while uploading : " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("uploadsuccesscsv.jsp");
            }
        }
    } catch (Exception e) {
        System.out.println("Error message from uploadcsvscript.jsp : " + e.getMessage());
        System.out.println("Cause : " + e.getCause());
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
%>
