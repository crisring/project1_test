<%@page import="java.sql.SQLException"%>
<%@page import="manager.productlist.AdminProductManagementDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>

<%
String[] productIdsParam = request.getParameterValues("productIds");

if (productIdsParam != null) {
	int[] productIds = new int[productIdsParam.length];
	for (int i = 0; i < productIdsParam.length; i++) {
		productIds[i] = Integer.parseInt(productIdsParam[i]);
	}

	AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();
	try {
		int rowCnt = apmDAO.deleteProduct(productIds);
		response.getWriter().write("삭제 개수: " + rowCnt);
	} catch (SQLException e) {
		e.printStackTrace();
		response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "삭제 실패!");
	}
} else {
	response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 매개 변수");
}
%>