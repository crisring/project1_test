<%@page import="manager.saleslist.AdminSalesManagementDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONObject"%>

<%
JSONObject jsonObj = new JSONObject();
int cnt = 0;

try {
	AdminSalesManagementDAO asmDAO = AdminSalesManagementDAO.getInstance();
	cnt = asmDAO.statusTotalCount(); // 판매 상태 수량을 가져옴
} catch (Exception e) {
	e.printStackTrace();
	jsonObj.put("error", "오류가 발생했습니다: " + e.getMessage());
}

jsonObj.put("rowCnt", cnt); // JSON 객체에 rowCnt 속성으로 수량 추가
out.print(jsonObj.toJSONString()); // JSON 형식으로 출력
%>
