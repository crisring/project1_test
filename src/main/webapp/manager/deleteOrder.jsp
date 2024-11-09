<%@page import="manager.saleslist.AdminSalesManagementDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>

<%
String[] orderIdsParam = request.getParameterValues("orderIds");

if (orderIdsParam != null) {
	int[] orderIds = new int[orderIdsParam.length];
	for (int i = 0; i < orderIdsParam.length; i++) {
		orderIds[i] = Integer.parseInt(orderIdsParam[i]);
	}

	AdminSalesManagementDAO asmDAO = AdminSalesManagementDAO.getInstance();
	try {
		int rowCnt = asmDAO.deleteOrders(orderIds);
		response.getWriter().write("삭제 개수: " + rowCnt);
	} catch (SQLException e) {
		e.printStackTrace();
		response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "삭제 실패!");
	}
} else {
	response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 매개 변수");
}
%>