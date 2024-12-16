<%@page import="user.dao.UserInquiryDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../common/session_chk.jsp"%>
<%
try {
	// 파라미터 받기
	String inquiryId = request.getParameter("inquiryId");
	String userId = sessionId;

	System.out.println("inquiryId" + inquiryId);
	System.out.println("userId" + userId);

	// DAO 인스턴스 생성
	UserInquiryDAO uiDAO = UserInquiryDAO.getInstance();

	// 삭제 수행 (userId 체크 포함)
	int result = uiDAO.deleteInquiry(inquiryId, userId);

	if (result > 0) {
%>
<script>
	alert("문의사항이 삭제되었습니다.");
	location.href = "qa_list.jsp";
</script>
<%
} else {
%>
<script>
	alert("문의사항 삭제에 실패했습니다.");
	history.back();
</script>
<%
}
} catch (Exception e) {
e.printStackTrace();
%>
<script>
	alert("문의사항 삭제 중 오류가 발생했습니다.");
	history.back();
</script>
<%
}
%>