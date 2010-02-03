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
   
   String parentUri = request.getParameter("parentUri");
   String deleteAction= request.getParameter("deleteAction");
   if (deleteAction!=null && (deleteAction.equalsIgnoreCase("no"))) {
	response.sendRedirect(request.getContextPath()+"/listReports.jsp?uri="+parentUri);
      return;
   }

   String name = request.getParameter("name");
   String fullUri= request.getParameter("fullUri");

   if (fullUri!= null && fullUri.length()>0 ) {
     if ((deleteAction!= null) && (deleteAction.equalsIgnoreCase("yes"))) {
        try {
		  client.delete(fullUri);
   	  }   catch (Exception ex)
   	  {       
       	  out.println("<h1>Unable to delete " + fullUri+ "</h1>");
       	  out.println("<pre>");
		  out.flush();
		  java.io.PrintWriter pw = response.getWriter();
		  ex.printStackTrace(pw);
		  out.println("</pre>");
           	  return;
   	  } 
        response.sendRedirect(request.getContextPath()+"/listReports.jsp?uri="+parentUri);
     }   	
  }  
  else {
     if (parentUri.equals("/")) fullUri= parentUri + name;
     else fullUri= parentUri + "/" + name;
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
       
   <form action="deleteRepo.jsp?fullUri=<%= fullUri%>&parentUri=<%= parentUri %>" method=POST>
       <center>
       Are you sure you want to delete <%= fullUri %> ?<br>
       
       <table id="mainTable" border="0" cellpadding="2" cellspacing="2" height="100%" valign="top" align="center">

         <tr>
           <td align="center"><input name="deleteAction" type="submit" value="YES"></td>
           <td align="center"><input name="deleteAction" type="submit" value="NO"></td>
         </tr>
       </table>  
       <br>
       <br>     
       </center>
   </form>
    
    </body>
</html>
