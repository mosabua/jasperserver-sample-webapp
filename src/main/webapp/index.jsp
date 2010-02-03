<%--
 Copyright (C) 2005 - 2007 JasperSoft Corporation.  All rights reserved.
 http://www.jaspersoft.com.

 Unless you have purchased a commercial license agreement from JasperSoft,
 the following license terms apply:

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License version 2 as published by
 the Free Software Foundation.

 This program is distributed WITHOUT ANY WARRANTY; and without the
 implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 See the GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, see http://www.gnu.org/licenses/gpl.txt
 or write to:

 Free Software Foundation, Inc.,
 59 Temple Place - Suite 330,
 Boston, MA  USA  02111-1307
--%>

<%@page import="com.jaspersoft.jasperserver.ws.scheduling.ReportSchedulerFacade"%>
<%@page import="java.net.URL"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%
   String errorMessage = "";
   if (request.getParameter("username") != null &&
       request.getParameter("username").length() > 0)
   {
       String username = request.getParameter("username");
       String password = request.getParameter("password");
       
       com.jaspersoft.jasperserver.sample.WSClient client = new com.jaspersoft.jasperserver.sample.WSClient(
               this.getServletContext().getInitParameter("webServiceUrl"),
               username,
               password);
       
       String reportSchedulingWebServiceUrl = getServletContext().getInitParameter("reportSchedulingWebServiceUrl");
       ReportSchedulerFacade reportScheduler = new ReportSchedulerFacade(new URL(reportSchedulingWebServiceUrl), 
               username, password);
       
       try 
       {
           client.list(""); // Trick to check if the user is valid...
           if (session == null) session = request.getSession(true);
           session.setAttribute("client", client);
           
           session.setAttribute("ReportScheduler", reportScheduler);
           
           response.sendRedirect(request.getContextPath()+"/listReports.jsp");
       
       } catch (Exception ex)
       {
           ex.printStackTrace();
           errorMessage = ex.getMessage();
       }
           
   }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JasperServer Web Services Sample</title>
    </head>
    <body>

    <h1><center>JasperServer Web Services Sample</center></h1>
    <hr>
    
   <h2><font color="red"><%=errorMessage%></font></h2>
   <center>
   <form action="index.jsp" method=POST>

       Type in a JasperServer username and password (i.e. jasperadmin/jasperadmin)<br><br>
       
       Username <input type="text" name="username"><br>
       Password <input type="password" name="password"><br>
       
       <br>
       <input type="submit" value="Enter">  
       
   </form>
    </center>
    
    
    </body>
</html>
