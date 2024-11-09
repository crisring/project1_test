<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Map"%>

<%
response.setContentType("application/json");
try {
	double sellingPrice = Double.parseDouble(request.getParameter("sellingPrice"));
	double discountAmount = Double.parseDouble(request.getParameter("discountAmount"));

	// 할인된 가격 계산
	double discountedPrice = sellingPrice - discountAmount;
	if (discountedPrice < 0) {
		discountedPrice = 0; // 할인 금액이 판매 가격보다 클 경우 0으로 설정
	}

	// JSON 응답 문자열 생성
	String jsonResponse = String.format("{\"discountedPrice\": %.2f, \"discountAmount\": %.2f}", discountedPrice,
	discountAmount);

	response.getWriter().write(jsonResponse); // 클라이언트로 응답 출력
} catch (NumberFormatException e) {
	response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	String errorResponse = "{\"error\": \"Invalid input. Please ensure sellingPrice and discountAmount are valid numbers.\"}";
	response.getWriter().write(errorResponse);
}
%>
