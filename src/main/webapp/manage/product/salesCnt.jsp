<%@page import="manage.productlist.AdminProductManagementDAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%
JSONObject jsonObj = new JSONObject();
int cnt = 0;

try {
	String salesStatus = request.getParameter("salesStatus");

	// salesStatus가 null이 아니고 비어있지 않은지 확인
	if (salesStatus != null && !salesStatus.isEmpty()) {
		AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();
		cnt = apmDAO.selectSalesStatusCount(salesStatus);

	} else {
		// salesStatus가 제공되지 않을 경우 예외 처리
		throw new IllegalArgumentException("salesStatus parameter is required.");
	}
} catch (Exception e) {
	e.printStackTrace();
	jsonObj.put("error", "An error occurred: " + e.getMessage()); // 오류 메시지를 JSON에 추가
}

jsonObj.put("rowCnt", cnt);
out.print(jsonObj.toJSONString());
%>
