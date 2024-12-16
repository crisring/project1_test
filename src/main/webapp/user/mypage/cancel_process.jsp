<%@page import="user.dao.OrderDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/common/session_chk.jsp"%>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 받기
String orderId = request.getParameter("orderId");
String cancelReason = request.getParameter("cancelReason");

// DB 업데이트 처리
OrderDAO oDAO = new OrderDAO();
try {
	// 1. order_cancel 테이블에 취소 이유 추가
	int cancelResult = oDAO.insertCancelReason(orderId, cancelReason);

	// 2. orders 테이블의 상태 업데이트
	int statusResult = oDAO.updateOrderStatus(orderId, "구매취소");

	if (cancelResult > 0 && statusResult > 0) {
%>
<script>
	alert("취소 요청이 완료되었습니다.");
	location.href = "order_list.jsp";
</script>
<%
} else {
%>
<script>
	alert("취소 요청 처리 중 문제가 발생했습니다.");
	history.back();
</script>
<%
}

} catch (SQLException se) {
se.printStackTrace();
%>
<script>
	alert("시스템 에러가 발생했습니다. 잠시 후 다시 시도해주세요.");
	history.back();
</script>
<%
}
%>