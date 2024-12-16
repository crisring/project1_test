<%@ page import="manage.util.AdminVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${empty userData}">
	<c:redirect url="http://localhost/proejct1/manage/admin_login.jsp" />
</c:if>

<%
AdminVO userData = (AdminVO) session.getAttribute("userData");
if (userData == null) {
	response.sendRedirect("http://localhost/proejct1/manage/admin_login.jsp");
	return;
}
String sessionId = userData.getAdmin_id();
%>

