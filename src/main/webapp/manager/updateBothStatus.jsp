<!-- updateBothStatus.jsp -->
<%@page import="manager.saleslist.AdminSalesManagementDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%
String orderType = request.getParameter("orderType");
String deliveryType = request.getParameter("deliveryType");
String[] orderIdsParam = request.getParameterValues("orderIds");

if (orderIdsParam != null && (orderType != null || deliveryType != null)) {
	int[] orderIds = new int[orderIdsParam.length];
	for (int i = 0; i < orderIdsParam.length; i++) {
		orderIds[i] = Integer.parseInt(orderIdsParam[i]);
	}

	AdminSalesManagementDAO asmDAO = AdminSalesManagementDAO.getInstance();
	try {
		int rowsUpdated = asmDAO.updateDeliveryOrderStatus(orderType, deliveryType, orderIds);
		response.getWriter().write("변경 개수: " + rowsUpdated);
	} catch (SQLException e) {
		e.printStackTrace();
		response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "변경 실패!");
	}
} else {
	response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 매개 변수");
}
%>
