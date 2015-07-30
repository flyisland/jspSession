<!doctype html public "-//w3c/dtd HTML 4.0//en">
<!-- Copyright (c) 2011, Oracle and/or its affiliates. All Rights Reserved.-->
<%@ page import="javax.naming.Context,
                 javax.naming.InitialContext,
                 java.lang.System,
                 java.io.PrintWriter,
                 java.util.Enumeration,
                 javax.management.MBeanServer,
                 javax.management.ObjectName" %>

<%!
  String serverName;
  String failoverMessage="";
  private static final String PREFIX_LABEL="SessionServlet.";

  private String getServerName() throws Exception {
    try {
      Context ctx = new InitialContext();
			MBeanServer mbeanServer = (MBeanServer)ctx.lookup("java:comp/env/jmx/runtime");

			String runtimeServiceName =  "com.bea:Name=RuntimeService,Type=weblogic.management.mbeanservers.runtime.RuntimeServiceMBean";

			// Create Objectname for the runtime service
      ObjectName runtimeService = new ObjectName(runtimeServiceName);

			// Get the ObjectName for the ServerRuntimeMBean ObjectName
      ObjectName serverRuntime = (ObjectName) mbeanServer.getAttribute(runtimeService,"ServerRuntime");

			// Get the name of the server
			String serverName = (String) mbeanServer.getAttribute(serverRuntime,"Name");
      if (serverName == null) return "";
      else return serverName;
    }
    catch (Exception e) {
      throw e;
    }
  }

  private String removePrefix(String name) {
    if (name.startsWith(PREFIX_LABEL))
      name = name.substring(PREFIX_LABEL.length());
    return name;
  }

  private String addPrefix(String name) {
    if (!name.startsWith(PREFIX_LABEL))
      name = PREFIX_LABEL + name;
    return name;
  }
%>

<html>
<head>
<title>Session Testing</title>
</head>
<body>

<%
  try {
    serverName = getServerName();
%>
      <p>The server currently hosting this session is <B><%= serverName %><B><%= failoverMessage %></p>
<%
    if (request.getParameter("AddValue") != null) {
      String nameField = request.getParameter("NameField");
      if (nameField != null && nameField.trim().length() > 0)
        session.setAttribute(addPrefix(nameField.trim()),
                      request.getParameter("ValueField"));
    } else if (request.getParameter("DeleteValue") != null) {
      session.removeAttribute(addPrefix(request.getParameter("NameField")));
    }
%>
      <br>
      <center>
      <table border=1 cellspacing="2" cellpadding=5 width=400 bgcolor=#EEEEEE>
        <th colspan=2>Session<br></th>
        <tr>
          <td><B>Name</B></td>
          <td><B>Value</B></td>
        </tr>
<%
    Enumeration sessionNames = session.getAttributeNames();
    String name;
    while (sessionNames.hasMoreElements()) {
      name = (String)sessionNames.nextElement();
      if (!name.startsWith(PREFIX_LABEL)) continue;
      if (removePrefix(name).length() < 1) continue;
%>
        <tr>
          <td><%= removePrefix(name) %></td>
          <td>&nbsp;<%= "" + session.getAttribute(name) %></td>
        </tr>
<%
    } // end of while loop for session names
%>
      </table>
      </center>
<br>

<form method="post" name="Session" action="">
  <center>
  <table border="0" cellspacing="2" cellpadding="5" width="400">
    <th>Name to add/delete</th>
    <th>Value</th>
    <tr>
      <td><input type="text" name="NameField"></td>
      <td><input type="text" name="ValueField"></td>
    </tr>
    <tr>
      <td colspan="2" align=center><input type="submit" value="Add" name="AddValue"></td>
    </tr>
    <tr>
      <td colspan="2" align=center><input type="submit" value="Delete" name="DeleteValue"></td>
    </tr>
  </table>
  </center>
</form>

<%
  }
  catch (Exception ex) {
    ex.printStackTrace(new PrintWriter(out));
  }
%>
</body>
