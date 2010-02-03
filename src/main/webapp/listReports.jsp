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
 
   String parentUri = "/";
   if (currentUri.length() > 1 && currentUri.lastIndexOf("/") >=0)
       parentUri = currentUri.substring(0, currentUri.lastIndexOf("/"));
   
   java.util.List list = null;
   try {
      list  = client.list(currentUri);
   } catch (Exception ex)
   {
       
       out.println("<h1>Unable to list " + currentUri + "</h1>");
       out.println("<pre>");
	out.flush();
	java.io.PrintWriter pw = response.getWriter();
	ex.printStackTrace(pw);
	out.println("</pre>");
       //response.sendRedirect(request.getContextPath()+"/index.jsp");
       return;
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
    <h3>List report</h3>
    Current Directory: <%=currentUri%><br>
    <br>
    <a href="?uri=<%=parentUri%>">[..]</a><br>
    <table id="mainTable" border="2" cellpadding="2" cellspacing="2" height="100%" valign="top">
    <tr><td align="center">NAME</td><td align="center">LABEL</td><td colspan="3" align="center">OPERATIONS</td><tr>
    <% 
       for (int i=0; i<list.size(); ++i)
       {
            ResourceDescriptor rd =
                   (ResourceDescriptor) list.get(i);
            String type = rd.getWsType();
            if ( !((type.equals( ResourceDescriptor.TYPE_FOLDER)) ||
                   (type.equals( ResourceDescriptor.TYPE_REPORTUNIT))
                   || type.equals(ResourceDescriptor.TYPE_CONTENT_RESOURCE))) {
                continue;
            }
    %>
        <tr>
           <td>
    <%
            if (type.equals( ResourceDescriptor.TYPE_FOLDER ))
            {
    %>
               <a href="?uri=<%=rd.getUriString()%>">[<%=rd.getName()%>]</a><br>
    <%
            }
            else if (type.equals( ResourceDescriptor.TYPE_REPORTUNIT))
            {
    %>
               <a href="runReport.jsp?uri=<%=rd.getUriString()%>"><b><%=rd.getName()%></b></a><br>
    <%
            }
            else if (type.equals(ResourceDescriptor.TYPE_CONTENT_RESOURCE))
            {
    %>
               <a href="content<%=rd.getUriString()%>"><b><%=rd.getName()%></b></a><br>
    <%
            }
    %>
          </td>
          <td><%=rd.getLabel()%></td>
          <td><a href="modifyRepo.jsp?uri=<%=currentUri%>&name=<%=rd.getName()%>">Edit</a></td>
          <td><a href="deleteRepo.jsp?parentUri=<%=currentUri%>&name=<%=rd.getName()%>">Delete</a></td>
          <td align="center">
    <%
            if (type.equals(ResourceDescriptor.TYPE_REPORTUNIT))
            {
    %>
          	<a href="reportSchedule.jsp?reportUri=<%= rd.getUriString() %>">Schedule</a>
    <%
            } 
            else
            {
    %>
    		-
    <%
            }
    %>
          </td>
       </tr>

    <%
       }
    %>
     </table>
     <br>
     <a href="addToRepo.jsp?uri=<%=currentUri%>">[Add New Resource ...]</a>
     <br>
     <br>
     <hr>
     <a href="index.jsp">Exit</a>
    </body>
</html>
