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
--%><%@page import="net.sf.jasperreports.engine.*,net.sf.jasperreports.engine.export.*,com.jaspersoft.jasperserver.sample.*"%><%

   if (session == null) response.sendRedirect(request.getContextPath()+"/index.jsp");
   com.jaspersoft.jasperserver.sample.WSClient client = (com.jaspersoft.jasperserver.sample.WSClient)session.getAttribute("client");
   
   if (client == null) response.sendRedirect(request.getContextPath()+"/index.jsp");
   
   String currentUri = request.getParameter("uri");
   if (currentUri == null || currentUri.length() ==0) currentUri = "/";
   if (currentUri.length() > 1 && currentUri.endsWith("/"))
       currentUri = currentUri.substring(0, currentUri.length()-1);
   
   com.jaspersoft.jasperserver.api.metadata.xml.domain.impl.ResourceDescriptor reportUnit = null;
   java.io.OutputStream os = null;
   try {
       
       java.util.Enumeration enum_params = request.getParameterNames();
       java.util.Map hashMap = new java.util.HashMap();
       while (enum_params.hasMoreElements())
       {
           String key = ""+enum_params.nextElement();
           System.out.println( key+" => " + request.getParameter( key ) + "\n");
           hashMap.put( key, request.getParameter( key ) );
       }
       
      JasperPrint print = client.runReport( currentUri, hashMap );
      
      net.sf.jasperreports.engine.JRExporter exporter=null;
      
      if (request.getParameter("format") == null || request.getParameter("format").equals("html"))
      {
          response.setContentType("text/html");
          response.setCharacterEncoding("UTF-8");
          
          exporter = new  net.sf.jasperreports.engine.export.JRHtmlExporter();
          
          JRHyperlinkProducerMapFactory producerFactory = new JRHyperlinkProducerMapFactory();
          producerFactory.addProducer("ReportExecution", new ReportExecutionHyperlinkProducer());
          exporter.setParameter(JRExporterParameter.HYPERLINK_PRODUCER_FACTORY, producerFactory);
      
          request.getSession().setAttribute(net.sf.jasperreports.j2ee.servlets.ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, print);
          exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "image?image=");
      }
      else if (request.getParameter("format").equals("pdf"))
      {
          response.setContentType("application/pdf");
          
        exporter = new  net.sf.jasperreports.engine.export.JRPdfExporter();    
      }
      else if (request.getParameter("format").equals("xls"))
      {
          response.setContentType("application/msexcel");
          response.setHeader("Content-Disposition"," inline; filename=report.xls"); 
        exporter = new  net.sf.jasperreports.engine.export.JExcelApiExporter();
      }
      
      os = response.getOutputStream();
      exporter.setParameter(JRExporterParameter.OUTPUT_STREAM,os);
      exporter.setParameter(JRExporterParameter.JASPER_PRINT,print);
      exporter.exportReport();
      return;
   
   } catch (Exception ex)
   {
       
       ex.printStackTrace();
       if (os != null)
       {
           java.io.PrintWriter pw = new java.io.PrintWriter(os);
           pw.write("<h1>Error running report</h1><code>");
           ex.printStackTrace(pw);
           pw.write("</code>");
       }
       else
       {
           out.write("<h1>Error running report</h1><code>");
           out.write(ex.getMessage()+"<br><br>");
           ex.printStackTrace( new java.io.PrintWriter(out ));
           out.write(ex.getMessage()+"</code>");
           
       }
       
       return;
   }
%>