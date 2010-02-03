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

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.jaspersoft.jasperserver.api.metadata.xml.domain.impl.*;"%>
<%  
   if (session == null) response.sendRedirect(request.getContextPath()+"/index.jsp");
   com.jaspersoft.jasperserver.sample.WSClient client = (com.jaspersoft.jasperserver.sample.WSClient)session.getAttribute("client");
   
   if (client == null) response.sendRedirect(request.getContextPath()+"/index.jsp");
   
   String currentUri = request.getParameter("uri");
   if (currentUri == null || currentUri.length() ==0) currentUri = "/";
   if (currentUri.length() > 1 && currentUri.endsWith("/"))
       currentUri = currentUri.substring(0, currentUri.length()-1);
   
   ResourceDescriptor reportUnit = null;
   try {
      reportUnit  = client.get(currentUri);
   } catch (Exception ex)
   {
       out.println("<h1>Unable to get " + currentUri + "</h1>");
       out.println("<pre>");
	out.flush();
	java.io.PrintWriter pw = response.getWriter();
	ex.printStackTrace(pw);
	out.println("</pre>");
       //response.sendRedirect(request.getContextPath()+"/index.jsp");
       return;
   }
   
   request.setAttribute("reportUnit", reportUnit);
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
    <h2><%=reportUnit.getLabel()%></h2>
    
    <br>
    <br>
    </a><br>
    <form action="executeReport.jsp">
     <input type="hidden" name="uri" value="<%=currentUri%>">
     
     <jsp:include page="reportParameters.jsp"/>
     
     <br>
     Export format: <select name="format">
         <option value="html">HTML</option>
         <option value="pdf">PDF</option>
         <option value="xls">XLS</option>
     </select>
     
     
     
     <input type="submit" value="Run the report">
     </form>
     <br>
     <%
        if (request.getAttribute("hasParameters") != null)
        {
     %>
     Attention: some input controls may require a number. The date/time format used with the webservices is a Long (current time: <%=(new java.util.Date()).getTime()%>).
     <%
        }
     %>
     <hr>
     <a href="index.jsp">Exit</a>
    </body>
</html>
