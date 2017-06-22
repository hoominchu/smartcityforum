<%@ page import="java.util.List" %>
<%@ page import="smartcity.*" %><%--
  Created by IntelliJ IDEA.
  User: minchu
  Date: 21/06/17
  Time: 10:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session.getAttribute("email") == null) {
        response.sendRedirect("login.jsp");
    } else if (LoginChecks.isSuperUser(request)) {
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

    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="commonfiles/slick/slick-theme.css"/>

    <script type="text/javascript" src="commonfiles/slick/slick.min.js"></script>

</head>
<body>
<%@include file="navbar.jsp" %>
<%@include file="header.jsp" %>

<div class="container">
    <div class="btn-group btn-group-justified round-corner-top">
        <a href="#" class="btn btn-default round-corner-top-left">Add work</a>
        <a href="#" class="btn btn-default">Upload CSV</a>
        <a href="#" class="btn btn-default round-corner-top-right">Update Database</a>
    </div>

    <%
        List<String> contractorNames = Contractor.getAllContractorNames();
    %>
    <div class="well bs-component round-corner-bottom">
        <form class="form-horizontal">
            <fieldset>
                <legend>Work Info</legend>
                <div class="form-group">
                    <label for="workID" class="col-lg-2 control-label">Work ID</label>
                    <div class="col-lg-4">
                        <input type="text" class="form-control round-corner" id="workID" placeholder="Work ID">
                    </div>
                    <label for="wardNumber" class="col-lg-2 control-label">Ward Number</label>
                    <div class="col-lg-4 round-corner">
                        <select class="form-control round-corner" id="wardNumber">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="workTypeID" class="col-lg-2 control-label">Work Type ID</label>
                    <div class="col-lg-3 round-corner">
                        <select class="form-control round-corner" id="workTypeID">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                    <label for="workType" class="col-lg-2 control-label">Work Type</label>
                    <div class="col-lg-5 round-corner">
                        <select class="form-control round-corner" id="workType">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="minorID" class="col-lg-2 control-label">Minor Work Type ID</label>
                    <div class="col-lg-3 round-corner">
                        <select class="form-control round-corner" id="minorID">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                    <label for="minorType" class="col-lg-2 control-label">Minor Work Type</label>
                    <div class="col-lg-5 round-corner">
                        <select class="form-control round-corner" id="minorType">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="sourceOfIncomeID" class="col-lg-2 control-label">Source of Income ID</label>
                    <div class="col-lg-3 round-corner">
                        <select class="form-control round-corner" id="sourceOfIncomeID">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                    <label for="sourceOfIncome" class="col-lg-2 control-label">Source of Income</label>
                    <div class="col-lg-5 round-corner">
                        <select class="form-control round-corner" id="sourceOfIncome">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label for="workOrderDate" class="col-lg-2 control-label">Work Order Date</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner form_datetime" id="workOrderDate" placeholder="">
                    </div>
                    <label for="workCompletionDate" class="col-lg-2 control-label">Work Completion Date</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner form_datetime" id="workCompletionDate" placeholder="">
                    </div>
                    <label for="yearOfWork" class="col-lg-2 control-label">Year</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner form_datetime" id="yearOfWork" placeholder="">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-lg-2 control-label">Status</label>
                    <div class="col-lg-10">
                        <div class="radio">
                            <label>
                                <input type="radio" name="status" id="inprogress" value="inprogress" checked="">
                                <p class="text-danger">In progress</p>
                            </label>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <label>
                                <input type="radio" name="status" id="completed" value="completed" checked="">
                                <p class="text-success">Completed</p>
                            </label>
                        </div>
                    </div>
                </div>
                <br>
                <legend>Descriptions</legend>
                <div class="form-group">
                    <label for="workDescriptionEnglish" class="col-lg-2 control-label">Word Description English</label>
                    <div class="col-lg-10">
                        <textarea class="form-control round-corner" rows="3" id="workDescriptionEnglish"></textarea>
                        <span class="help-block">Work description in English.</span>
                    </div>
                </div>
                <div class="form-group">
                    <label for="workDescriptionKannada" class="col-lg-2 control-label">Word Description Kannada</label>
                    <div class="col-lg-10">
                        <textarea class="form-control round-corner" rows="3" id="workDescriptionKannada"></textarea>
                        <span class="help-block">Work description in Kannada.</span>
                    </div>
                </div>
                <br>
                <legend>Amounts</legend>
                <div class="form-group">
                    <label for="estimateAmount" class="col-lg-2 control-label">Estimate Amount</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner" id="estimateAmount" placeholder="">
                    </div>
                    <label for="amountPutToTender" class="col-lg-2 control-label">Amount put to tender</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner" id="amountPutToTender" placeholder="">
                    </div>
                    <label for="amountSanctioned" class="col-lg-2 control-label">Amount Sanctioned</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner" id="amountSanctioned" placeholder="">
                    </div>
                </div>
                <br>
                <legend>Tender Dates</legend>
                <div class="form-group">
                    <label for="technicalSanctionDate" class="col-lg-2 control-label">Technical Sanction Date</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner form_datetime" id="technicalSanctionDate" placeholder="">
                    </div>
                    <label for="tenderNotificationDate" class="col-lg-2 control-label">Tender Notification Date</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner form_datetime" id="tenderNotificationDate" placeholder="">
                    </div>
                    <label for="tenderApprovalDate" class="col-lg-2 control-label">Tender Approval Date</label>
                    <div class="col-lg-2">
                        <input type="text" class="form-control round-corner form_datetime" id="tenderApprovalDate" placeholder="">
                    </div>
                </div>
                <br>
                <legend>Contractor</legend>
                <div class="form-group">
                    <label for="contractor" class="col-lg-2 control-label">Contractor</label>
                    <div class="col-lg-5 round-corner">
                        <select class="form-control round-corner" id="contractor">
                            <%
                                for (String contractorName :
                                        contractorNames) {
                                 %>
                            <option><%=contractorName%></option>
                            <%
                                }
                            %>

                        </select>
                    </div>
                    <label for="contractorID" class="col-lg-2 control-label">Contractor ID</label>
                    <div class="col-lg-3 round-corner">
                        <select class="form-control round-corner" id="contractorID">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </div>
                </div>
                <hr>
                <div class="form-group">
                    <div class="col-lg-10 col-lg-offset-2">
                        <button type="reset" class="btn btn-default round-corner">Cancel</button>
                        <button type="submit" class="btn btn-primary round-corner">Submit</button>
                    </div>
                </div>
            </fieldset>
        </form>
    </div>
</div>
<%@include file="footer.jsp" %>
<%@include file="contactmodal.jsp" %>
</body>
</html>
<%
        } catch (Exception e) {
            System.out.println("Error" + e.getMessage());
            System.out.println("Stacktrace -- ");
            e.printStackTrace();
            String redirectURL = "error.jsp";
            response.sendRedirect(redirectURL);
        }
    }
%>