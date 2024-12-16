
<%@page import="user.dao.UserInquiryDAO"%>
<%@page import="manage.inquiry.InquiryVO"%>
<%@page import="java.sql.SQLException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../common/session_chk.jsp"%>
<%@ include file="../../common/post_chk.jsp"%>
<%
request.setCharacterEncoding("UTF-8");

// 파라미터 받기
String userId = request.getParameter("userId");
String category = request.getParameter("inquiryType");
String title = request.getParameter("title");
String content = request.getParameter("content");

// InquiryVO 설정
InquiryVO iVO = new InquiryVO();
iVO.setUserId(userId);
iVO.setCategory(category);
iVO.setTitle(title);
iVO.setContent(content);

// UserInquiryDAO 생성 및 insert 수행
UserInquiryDAO uiDAO = UserInquiryDAO.getInstance();
try {
	uiDAO.insertInquiry(iVO);
%>
<script>
	alert("문의가 등록되었습니다.");
	location.href = "qa_list.jsp";
</script>
<%
} catch (SQLException se) {
se.printStackTrace();
%>
<script>
	alert("문의 등록 중 문제가 발생했습니다.");
	history.back();
</script>
<%
}
%>