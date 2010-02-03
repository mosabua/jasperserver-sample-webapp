package com.jaspersoft.jasperserver.sample;
/*
 * WSClientSingleton.java
 *
 * Created on July 12, 2006, 4:56 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

/**
 *
 * @author gtoffoli
 */
import java.io.File;

import net.sf.jasperreports.engine.JasperPrint;
import com.jaspersoft.jasperserver.irplugin.JServer;

import com.jaspersoft.jasperserver.api.metadata.xml.domain.impl.*;

public class WSClient {

     private JServer server = null;
     private static String reportUnitDataSourceURI = "/datasources/JServerJdbcDS";
    
     public WSClient(String webServiceUrl, String username, String password)
     {
         server = new JServer();
         server.setUsername(username);
         server.setPassword(password);
         server.setUrl(webServiceUrl);
     }
     
     public java.util.List list(String uri) throws Exception
     {
        ResourceDescriptor rd = new ResourceDescriptor();
        rd.setWsType( ResourceDescriptor.TYPE_FOLDER);
        rd.setUriString(uri);
        return server.getWSClient().list(rd);
     }
     
     public ResourceDescriptor get(String uri) throws Exception
     {
        return get(uri, null);
     } 
     
     public ResourceDescriptor get(String uri, java.util.List args) throws Exception
     {
        return get(uri, null, args);
     } 
     
     public ResourceDescriptor get(String uri, File outputFile, java.util.List args) throws Exception
     {
        ResourceDescriptor rd = new ResourceDescriptor();
        rd.setUriString(uri);
        return server.getWSClient().get(rd, outputFile, args);
     } 
     
     public JasperPrint runReport(String reportUri, java.util.Map parameters) throws Exception
     {
        ResourceDescriptor rd = new ResourceDescriptor();
        rd.setWsType( ResourceDescriptor.TYPE_REPORTUNIT);
        rd.setUriString(reportUri);
      
        return server.getWSClient().runReport(rd, parameters);
     }
     
     public ResourceDescriptor put(String type, String name, String label, String desc, String parentFolder) throws Exception 
     {
 		ResourceDescriptor rd = new ResourceDescriptor();
 		rd.setName(name);
 		rd.setLabel(label);
 		rd.setDescription(desc);
 		rd.setParentFolder(parentFolder);
 		rd.setUriString(rd.getParentFolder() + "/" + rd.getName());
 		rd.setWsType(type);
 		rd.setIsNew(true);
 		
 		if (type.equalsIgnoreCase(ResourceDescriptor.TYPE_FOLDER)) {
 			return server.getWSClient().addOrModifyResource(rd, null);
 		}
 		else if (type.equalsIgnoreCase(ResourceDescriptor.TYPE_REPORTUNIT)) {
 			return putReportUnit(rd);
 		}
 		
 		//shouldn't reach here
 		return null;

 	}
     
     
     public ResourceDescriptor update(String name, String label, String desc, String parentFolder) throws Exception 
     {
    	ResourceDescriptor rd = get(parentFolder + "/" + name);
 		rd.setLabel(label);
 		rd.setDescription(desc);
 		rd.setIsNew(false);
 		
 		//remove children for the update to be effective
 		rd.setChildren(new java.util.ArrayList());
 		
 		return server.getWSClient().addOrModifyResource(rd, null);
 	}
     
     public void delete(String uri) throws Exception 
     {
    	ResourceDescriptor rd = new ResourceDescriptor();;
 		rd.setUriString(uri);
 		
 	    server.getWSClient().delete(rd);
 	}
     
     private ResourceDescriptor putReportUnit(ResourceDescriptor rd) throws Exception 
     {
		File resourceFile = null;

		ResourceDescriptor tmpDataSourceDescriptor = new ResourceDescriptor();
		tmpDataSourceDescriptor.setWsType(ResourceDescriptor.TYPE_DATASOURCE);
		tmpDataSourceDescriptor.setReferenceUri(reportUnitDataSourceURI);
		tmpDataSourceDescriptor.setIsReference(true);
		rd.getChildren().add(tmpDataSourceDescriptor);

		ResourceDescriptor jrxmlDescriptor = new ResourceDescriptor();
		jrxmlDescriptor.setWsType(ResourceDescriptor.TYPE_JRXML);
		jrxmlDescriptor.setName("test_jrxml");
		jrxmlDescriptor.setLabel("Main jrxml"); 
		jrxmlDescriptor.setDescription("Main jrxml"); 
		jrxmlDescriptor.setIsNew(true);
		jrxmlDescriptor.setHasData(true);
		jrxmlDescriptor.setMainReport(true);
		rd.getChildren().add(jrxmlDescriptor);
		
		resourceFile = new File(getFileResourceURL("test.jrxml"));
		
		return server.getWSClient().addOrModifyResource(rd, resourceFile);
		
     }   
     
     /** Fetches the URL of the Files in the classpath
 	 * @return file path
 	 **/
 	private String getFileResourceURL(String name) {
 		return  getClass().getClassLoader().getResource(name).getFile();
 	}
}
