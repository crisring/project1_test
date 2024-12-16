<%@page import="user.vo.UserVO"%>
<%@page import="user.dao.UserAuthenticationDAO"%>
<%@page import="java.sql.SQLException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ include file="../../common/post_chk.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap CDN 시작 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style type="text/css">
</style>
<script type="text/javascript">
	$(function() {

	});//ready
</script>
</head>
<body>
	<div id="wrap">
		<jsp:useBean id="uVO" class="user.vo.UserVO" scope="page" />
		<jsp:setProperty property="*" name="uVO" />
		<jsp:setProperty name="uVO" property="birth" param="birthdate" />
		<%
		UserAuthenticationDAO uDAO = UserAuthenticationDAO.getInstance();

		UserVO resultVO = null;

		try {
			// uDAO를 통해 DB에서 조회
			resultVO = uDAO.selectUserId(uVO);
		} catch (SQLException se) {
			se.printStackTrace();
			System.out.println("SQLState: " + se.getSQLState());
			System.out.println("Error Code: " + se.getErrorCode());
		} //end catch

		// 조회 결과에 따른 분기
		if (resultVO != null) {
		%>
		<!-- 조회된 user_id와 name을 find_id_2.jsp로 전달 -->
		<form id="redirectForm" action="find_id_2.jsp" method="post">
			<input type="hidden" name="user_id" value="<%=resultVO.getUserId()%>">
			<input type="hidden" name="name" value="<%=resultVO.getName()%>">
		</form>
		<script>
			$(function() {
				$('#redirectForm').submit(); // 폼 자동 제출로 find_id_2.jsp로 이동
			});//ready
		</script>
		<%
		} else {
		%>
		<script>
			alert("해당 정보로 조회된 아이디가 없습니다.");
			history.back(); // 이전 페이지로 이동
		</script>
		<%
		} //end else
		%>
	</div>
</body>
</html>