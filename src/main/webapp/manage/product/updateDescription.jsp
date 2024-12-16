<%@page import="manage.productlist.AdminProductManagementDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>

<%
String productIdParam = request.getParameter("productId");
String description = request.getParameter("description");

if (productIdParam != null && description != null) {

	try {
		int productId = Integer.parseInt(productIdParam);

		AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();
		apmDAO.updateDescription(description, productId); // Call your method
		response.setStatus(HttpServletResponse.SC_OK);
	} catch (SQLException e) {
		response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		e.printStackTrace();
	}
	return;
}
%>