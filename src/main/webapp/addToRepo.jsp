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
   String name = request.getParameter("name");
   String label = request.getParameter("label");
   String desc = request.getParameter("description");
   String type = request.getParameter("type");

   if ((name!= null && name.length()>0 ) && (label!=null && label.length()>0 ) && (type!=null && type.length()>0 ) && 
       (desc!=null && desc.length()>0 ) && (currentUri !=null && currentUri .length()>0 ) ) {
   	ResourceDescriptor rd = null;
   	try {
      	rd  = client.put(type,name,label,desc,currentUri);
   	} catch (Exception ex)
   	{       
       	out.println("<h1>Unable to add " + name + " to " + currentUri + "</h1>");
       	out.println("<pre>");
		out.flush();
		java.io.PrintWriter pw = response.getWriter();
		ex.printStackTrace(pw);
		out.println("</pre>");
       	//response.sendRedirect(request.getContextPath()+"/listReports.jsp?uri="+currentUri);
       	return;
   	} 
      response.sendRedirect(request.getContextPath()+"/listReports.jsp?uri="+currentUri);
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
       
   <form action="addToRepo.jsp?uri=<%= currentUri %>" method=POST>
       <center>
       <h3> Add New Resource</h3>
       
       <table id="mainTable" border="2" cellpadding="2" cellspacing="2" height="100%" valign="top" align="center">
       <tr><td colspan="2" align="left">Please enter the properties:</td></tr>
       <tr><td>Type:</td>
           <td>
             <select name="type">
               <option value="<%=ResourceDescriptor.TYPE_REPORTUNIT%>"><%=ResourceDescriptor.TYPE_REPORTUNIT%> **</option>
               <option value="<%=ResourceDescriptor.TYPE_FOLDER%>"><%=ResourceDescriptor.TYPE_FOLDER%></option>
             </select>
       </td></tr>
       <tr><td>Parent Folder:</td><td> <%= currentUri %> </td></tr>
       <tr><td>Name*:</td><td> <input type="text" name="name" <% if (name!= null) { %> value="<%= name %>" <% }%>></td></tr>
       <tr><td>Label*:</td><td> <input type="text" name="label" <% if (label!= null) { %> value="<%= label %>" <% }%>></td></tr>
       <tr><td>Description*:</td><td> <input type="text" name="description" <% if (desc!= null) { %> value="<%= desc %>" <% }%> ></td></tr>
       <tr></tr>
       <tr><td colspan="2" align="center"><input type="submit" value="Enter""></td></tr>
       </table> 

       </center> 
       <br>
       <table id="notes" border="0" cellpadding="2" cellspacing="2" height="100%" valign="top" align="center">
       <tr><td>*</td><td>You need to enter these values</td></tr>
       <tr><td>**</td><td>This will use the test.jrxml file in your samples directory</td></tr>
       </table>  
       <br>     
       
   </form>
    
    </body>
</html>
