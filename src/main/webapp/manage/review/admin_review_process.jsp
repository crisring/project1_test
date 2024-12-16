<%@page import="manage.review.ReviewVO"%>
<%@page import="manage.review.AdminReviewDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.SQLException"%>
<%
request.setCharacterEncoding("UTF-8");
%>

<%
// 초기 메시지와 성공 플래그
String msg = "잘못된 요청입니다.";
boolean success = false;

try {
	// reviewId를 정수로 바로 파싱
	int reviewId = Integer.parseInt(request.getParameter("reviewId"));

	// DAO 호출
	AdminReviewDAO arDAO = AdminReviewDAO.getInstance();
	ReviewVO rVO = new ReviewVO();
	rVO.setReviewId(reviewId);

	// 삭제 처리
	int rowCount = arDAO.deleteReview(rVO);

	if (rowCount > 0) {
		msg = "리뷰가 성공적으로 삭제되었습니다.";
		success = true;
	} else {
		msg = "리뷰 삭제에 실패했습니다. 해당 리뷰를 찾을 수 없습니다.";
	}
} catch (NumberFormatException e) {
	msg = "유효하지 않은 리뷰 ID입니다.";
	e.printStackTrace();
} catch (SQLException e) {
	msg = "데이터베이스 오류가 발생했습니다.";
	e.printStackTrace();
}
%>

<script>
    alert('<%=msg%>');
<%if (success) {%>
	if (window.opener) {
		window.opener.location.reload(); // 부모 창 새로고침
	}
	window.close(); // 팝업 닫기
<%} else {%>
	history.back(); // 이전 페이지로 이동
<%}%>
	
</script>
