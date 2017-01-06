<%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 28/06/16
  Time: 12:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.mongodb.BasicDBObject,org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%@ page import="java.io.File" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="smartcity.*" %>
<%
    try {
        String workIDParameter = request.getParameter("workID");
        workIDParameter = StringEscapeUtils.escapeHtml4(workIDParameter);

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
    //Inserting the notes entered in the DB
    DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    Date date = new Date();
    try {
        String notes = request.getParameter("notes");
        if (notes != null && notes.length() > 0) {
            //Cleaning notes entered.
            //notes = UserInputSanitizer.sanitize(notes);

            notes = General.capitalizeFirstLetter(notes);
            notes = StringEscapeUtils.escapeHtml4(notes);

            BasicDBObject document = new BasicDBObject();
            document.put("Work ID", workIDParameter);
            document.put("Notes", notes);
            document.put("Submitted by", session.getAttribute("nameOfUser"));
            document.put("Date", dateFormat.format(date));
            document.put("Time", timeFormat.format(date));
            Database.workNotes.insert(document);

            DataEntryDifference dataEntryDifference = new DataEntryDifference(workIDParameter, "Work");
            dataEntryDifference.headers.add("Work Notes");
            dataEntryDifference.previousValues.add("null");
            dataEntryDifference.newValues.add(notes);
        }
    } catch (Exception e) {
        System.out.println("Error message from uploadscript.jsp : " + e.getMessage());
        System.out.println("Cause : " + e.getCause());
        e.printStackTrace();
%>
<script>
    window.location = "workDetails.jsp?workID=" + <%=workIDParameter%>;
</script>
<%
            }

            //Uploading images and KML files on the server
            int MAX_MEMORY_SIZE = 1024 * 1024 * 20;
            final int MAX_REQUEST_SIZE = 1024 * 1024 * 10;
            DiskFileItemFactory factory = new DiskFileItemFactory();
            // Sets the size threshold beyond which files are written directly to disk.
            factory.setSizeThreshold(MAX_MEMORY_SIZE);
            // Sets the directory used to temporarily store files that are larger
            // than the configured size threshold. We use temporary directory for java
            factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
            // constructs the folder where uploaded file will be stored

            String rootFolder = "";
            //System.out.println(request.getRequestURL() + "\n" + request.toString());
            if (request.getRequestURL().toString().contains(LoadProperties.properties.getString("WebsiteName"))) {
                rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataOnWeb");
            } else {
                rootFolder = LoadProperties.properties.getString("PathToStoreWorksDataLocal");
            }

            new File(rootFolder + File.separator + workIDParameter).mkdir();
            String uploadFolder = rootFolder + File.separator + workIDParameter + File.separator;
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
                DataEntryDifference dataEntryDifference = new DataEntryDifference(workIDParameter,"Work");
                dataEntryDifference.headers.add("Photos");
                dataEntryDifference.previousValues.add("-");
                dataEntryDifference.newValues.add(Integer.toString(items.size()));

                response.sendRedirect("uploadsuccess.jsp?workID=" + workIDParameter);
            } catch (Exception e) {
                System.out.println("Error while uploading : " + e.getMessage());
                e.printStackTrace();
                response.sendRedirect("uploadsuccess.jsp?workID=" + workIDParameter);
            }
        }
    } catch (Exception e) {
        System.out.println("Error message from uploadscript.jsp : " + e.getMessage());
        System.out.println("Cause : " + e.getCause());
        e.printStackTrace();
        response.sendRedirect("error.jsp");
    }
%>
