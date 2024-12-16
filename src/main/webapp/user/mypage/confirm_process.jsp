<%@page import="user.dao.OrderDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../common/session_chk.jsp"%>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 받기
String productName = request.getParameter("productName");
String imgName = request.getParameter("imgName");
String orderId = request.getParameter("orderId"); // 추가된 부분

// DB 업데이트 처리
OrderDAO oDAO = new OrderDAO();
try {
	// order_status 업데이트 메서드 호출
	int result = oDAO.updateOrderStatus(orderId, "구매확정"); // 추가된 부분

	if (result > 0) { // 업데이트가 성공했을 때만 리뷰 모달 표시
		// 세션에 리뷰 모달 표시를 위한 정보 저장
		session.setAttribute("showReviewModal", "true");
		session.setAttribute("reviewProductName", productName);
		session.setAttribute("reviewImgName", imgName);
		session.setAttribute("reviewOrderId", orderId);
	}
} catch (SQLException se) {
	se.printStackTrace();
}

// 주문 목록 페이지로
response.sendRedirect("order_list.jsp");
%>