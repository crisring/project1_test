<%@page import="manage.productlist.AdminProductManagementDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%
String saleType = request.getParameter("saleType");
String[] productIdsParam = request.getParameterValues("productIds");

if (productIdsParam != null && saleType != null) {
	int[] productIds = new int[productIdsParam.length];
	for (int i = 0; i < productIdsParam.length; i++) {
		productIds[i] = Integer.parseInt(productIdsParam[i]);
	}

	AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();
	try {
		int rowsUpdated = apmDAO.updateSaleStatus(saleType, productIds);
		response.getWriter().write("변경 개수: " + rowsUpdated);
	} catch (SQLException e) {
		e.printStackTrace();
		response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "변경 실패!");
	}
} else {
	response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 매개 변수");
}
%>