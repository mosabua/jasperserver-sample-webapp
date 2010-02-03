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

<%@page import="com.jaspersoft.jasperserver.api.metadata.xml.domain.impl.*;"%>
     
   <table border=0>
    <%
    com.jaspersoft.jasperserver.sample.WSClient client = (com.jaspersoft.jasperserver.sample.WSClient)session.getAttribute("client");
    ResourceDescriptor reportUnit = (ResourceDescriptor) request.getAttribute("reportUnit");
    
    
       int parametersCount = 0;
       java.util.List list = reportUnit.getChildren();
       
       // Find the datasource uri...
       String dsUri = null;
       for (int i=0; i<list.size(); ++i)
       {
           ResourceDescriptor rd =
                   (ResourceDescriptor) list.get(i);

           if (rd.getWsType().equals(ResourceDescriptor.TYPE_DATASOURCE))
           {
                 dsUri = rd.getReferenceUri();
           }
           else if (rd.getWsType().equals( ResourceDescriptor.TYPE_DATASOURCE) ||
                    rd.getWsType().equals( ResourceDescriptor.TYPE_DATASOURCE_JDBC) ||
                    rd.getWsType().equals( ResourceDescriptor.TYPE_DATASOURCE_JNDI) ||
                    rd.getWsType().equals( ResourceDescriptor.TYPE_DATASOURCE_BEAN))
           {
                            dsUri = rd.getUriString();
           }
       }
       
       
       // Show all input controls
       for (int i=0; i<list.size(); ++i)
       {
            ResourceDescriptor rd =
                   (ResourceDescriptor) list.get(i);

            
            
            if (rd.getWsType().equals( ResourceDescriptor.TYPE_INPUT_CONTROL))
            {
                parametersCount++;
                %>
        <tr><td><%=rd.getLabel()%></td><td>
    <%   
                if (rd.getControlType() == ResourceDescriptor.IC_TYPE_BOOLEAN)
                {
    %>
        <input type="checkbox" name="<%=rd.getName()%>" value="true">
    <%                
                }
                else if (rd.getControlType() == ResourceDescriptor.IC_TYPE_SINGLE_VALUE)
                {
    %>
        <input type="text" name="<%=rd.getName()%>">
    <%                
                }
                else if (rd.getControlType() == ResourceDescriptor.IC_TYPE_SINGLE_SELECT_LIST_OF_VALUES)
                {
    %>
        <select name="<%=rd.getName()%>">
                <%
                   // Get the child with the list...
                   java.util.List rdChildren = rd.getChildren();
                   ResourceDescriptor listOfValuesRd = null;
                   
                   for (int j=0; j<rdChildren.size(); ++j)
                    {
                        listOfValuesRd = (ResourceDescriptor)rdChildren.get(j);
                        if (listOfValuesRd.getWsType().equals(listOfValuesRd.TYPE_LOV))
                        {
                            break;
                        }
                        else listOfValuesRd = null;
                    }
                    
                    if (listOfValuesRd != null)
                    {
                        java.util.List listOfValues = listOfValuesRd.getListOfValues();
                        for (int j=0; j<listOfValues.size(); ++j)
                        {
                            ListItem item = 
                               (ListItem) listOfValues.get(j);
                        %>
                            <option value="<%=item.getValue()%>"><%=item.getLabel()%></option>
                        <%  
                        }
                    }
                %>
        </select>
    <%                
                }
                else if (rd.getControlType() == ResourceDescriptor.IC_TYPE_SINGLE_SELECT_QUERY)
                {
    %>
        <select name="<%=rd.getName()%>">
                <%
                   // Get the list of entries....
                   java.util.List args = new java.util.ArrayList();
                   args.add(new Argument( Argument.IC_GET_QUERY_DATA, dsUri));
                   rd = client.get(rd.getUriString(), args);
                    
                   if (rd.getQueryData() != null)
                    {
                        java.util.List rows = rd.getQueryData();
                        for (int j=0; j<rows.size(); ++j)
                        {
                            InputControlQueryDataRow item = 
                               (InputControlQueryDataRow)rows.get(j);
                        
                               StringBuffer label = new StringBuffer();
                               for (int k=0; k<item.getColumnValues().size(); ++k)
                               {
                                   label.append( ((k >0) ? " | " : "") );
                                   label.append( item.getColumnValues().get(k));
                               }
                            %>
                        
                            <option value="<%=item.getValue()%>"><%=label%></option>
                        <%  
                        }
                    }
                %>
        </select>
    <%                
                }
        %>
        </td><td><% if (rd.getDescription()!= null) rd.getDescription();%></td></tr>
    <%            
            }
       }
       
       if (parametersCount > 0) {
    	   request.setAttribute("hasParameters", Boolean.TRUE);
       }
    %>
    </table>
