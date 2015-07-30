<html>
<head>
<title>Session Testing</title>
</head>
<body>
<%@ page import="java.util.Date" %>
<table>
  <%
    long dateTimes = session.getCreationTime();
    if( dateTimes > 0 ) {
  %>
  <tr>
    <td>Your last access time is: </td>
    <td><%= new Date(dateTimes) %></td>
  </tr>
  <%
    }
  %>
  <tr>
    <td>Now is: </td>
    <td><%= new Date() %></td>
  </tr>
</table>
<%
  Integer count = (Integer)session.getAttribute("COUNT");
  // If COUNT is not found, create it and add it to the session
  if ( count == null ) {

    count = new Integer(1);
    session.setAttribute("COUNT", count);
  }
  else {
    count = new Integer(count.intValue() + 1);
    session.setAttribute("COUNT", count);
  }
%>
<p>
  You have visited this site: <b><%= count %></b> times.
</p>
<p>
  This JSP is runing on server <b>"<%= System.getProperty("weblogic.Name") %>"</b>.
</p>
</body>
</html>
