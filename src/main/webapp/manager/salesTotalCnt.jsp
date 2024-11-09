<%@page import="manager.productlist.AdminProductManagementDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>

<%
JSONObject jsonObj = new JSONObject();
int cnt = 0;

try {
	AdminProductManagementDAO apmDAO = AdminProductManagementDAO.getInstance();
	cnt = apmDAO.statusTotalCount(); // 판매 상태 수량을 가져옴
} catch (Exception e) {
	e.printStackTrace();
	jsonObj.put("error", "An error occurred: " + e.getMessage());
}

jsonObj.put("rowCnt", cnt); // JSON 객체에 rowCnt 속성으로 수량 추가
out.print(jsonObj.toJSONString()); // JSON 형식으로 출력
%>
