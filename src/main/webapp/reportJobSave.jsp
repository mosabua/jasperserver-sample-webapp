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
<%@page import="java.util.*"%>
<%@page import="com.jaspersoft.jasperserver.ws.scheduling.*"%>
<%@page import="com.jaspersoft.jasperserver.api.metadata.xml.domain.impl.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%  
   if (session == null) response.sendRedirect(request.getContextPath()+"/index.jsp");
   com.jaspersoft.jasperserver.sample.WSClient client = (com.jaspersoft.jasperserver.sample.WSClient)session.getAttribute("client");
   if (client == null) {response.sendRedirect(request.getContextPath()+"/index.jsp"); return;}
   
   ReportScheduler scheduler = (ReportScheduler) session.getAttribute("ReportScheduler");
   if (scheduler == null) {response.sendRedirect(request.getContextPath()+"/index.jsp"); return;}

   Job job = new Job();
   String reportUri = request.getParameter("reportUri");
   job.setReportUnitURI(reportUri);
   job.setLabel(request.getParameter("label"));
   job.setBaseOutputFilename(request.getParameter("outputName"));
   job.setOutputFormats(request.getParameterValues("output"));
   
   JobRepositoryDestination repoDest = new JobRepositoryDestination();
   repoDest.setFolderURI("/ContentFiles");//hardcoded!
   repoDest.setSequentialFilenames(request.getParameter("sequential") != null);
   job.setRepositoryDestination(repoDest);
   
   String triggerType = request.getParameter("triggerType");
   if (triggerType.equals("simple")) {
	   JobSimpleTrigger trigger = new JobSimpleTrigger();
	   trigger.setOccurrenceCount(-1);//recur indefinitely
	   trigger.setRecurrenceInterval(Integer.valueOf(request.getParameter("interval")));
	   trigger.setRecurrenceIntervalUnit(IntervalUnit.fromString(request.getParameter("intervalUnit")));
	   job.setSimpleTrigger(trigger);
   } else if (triggerType.equals("weekly")) {
	   JobCalendarTrigger trigger = new JobCalendarTrigger();
	   trigger.setMinutes(request.getParameter("weekDayMinute"));
	   trigger.setHours(request.getParameter("weekDayHour"));
	   trigger.setDaysType(CalendarDaysType.WEEK);
	   trigger.setWeekDays(new int[]{Integer.parseInt(request.getParameter("weekDay"))});
	   trigger.setMonths(new int[]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11});//all months
	   job.setCalendarTrigger(trigger);
   }
   
   String mailTo = request.getParameter("mailTo");
   if (mailTo != null && mailTo.length() > 0) {
	   JobMailNotification mail = new JobMailNotification();
	   mail.setToAddresses(new String[]{mailTo});
	   mail.setSubject("Reports");
	   mail.setMessageText("Some reports");
	   mail.setResultSendType(ResultSendType.SEND_ATTACHMENT);
	   job.setMailNotification(mail);
   }
   
	List parameters = new ArrayList();
	ResourceDescriptor reportUnit = client.get(reportUri);
	List children = reportUnit.getChildren();
	for (Iterator it = children.iterator(); it.hasNext(); ) {
		ResourceDescriptor child = (ResourceDescriptor) it.next();
		if (child.getWsType().equals(ResourceDescriptor.TYPE_INPUT_CONTROL)) {
			String name = child.getName();
			Object value = request.getParameter(name);
			JobParameter parameter = new JobParameter(name, value);
			parameters.add(parameter);
		}
	}
	
	if (!parameters.isEmpty()) {
		job.setParameters((JobParameter[]) parameters.toArray(new JobParameter[parameters.size()]));
	}
   
   Job savedJob = scheduler.scheduleJob(job);
   pageContext.setAttribute("savedJob", savedJob);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JasperServer Web Services Sample</title>
    </head>
    <body>

    <center><h1>JasperServer Web Services Sample</h1></center>
    <hr/>
    <h3>Saved job <c:out value="${savedJob.id}"/>.</h3>
     <hr/>
     <a href="<c:url value="reportSchedule.jsp"><c:param name="reportUri" value="${param['reportUri']}"/></c:url>">Back</a>
    <br/>
     <a href="index.jsp">Exit</a>
    </body>
</html>
