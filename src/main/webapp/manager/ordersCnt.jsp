<%@page import="manager.saleslist.AdminSalesManagementDAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%
JSONObject jsonObj = new JSONObject();
int cnt = 0;

try {
	String ordersStatus = request.getParameter("ordersStatus");

	// salesStatus가 null이 아니고 비어있지 않은지 확인
	if (ordersStatus != null && !ordersStatus.isEmpty()) {
		AdminSalesManagementDAO asmDAO = AdminSalesManagementDAO.getInstance();
		cnt = asmDAO.selectOrdersStatusCount(ordersStatus);

	} else {
		// salesStatus가 제공되지 않을 경우 예외 처리
		throw new IllegalArgumentException("ordersStatus parameter is required.");
	}
} catch (Exception e) {
	e.printStackTrace();
	jsonObj.put("error", "An error occurred: " + e.getMessage()); // 오류 메시지를 JSON에 추가
}

jsonObj.put("rowCnt", cnt);
out.print(jsonObj.toJSONString());
%>
