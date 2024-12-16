<%@page import="user.dao.UserAuthenticationDAO"%>
<%@page import="kr.co.sist.chipher.DataEncryption"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../common/post_chk.jsp"%>
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
$(function(){

});//ready
</script>
</head>
<body>
	<div id="wrap">
		<jsp:useBean id="uVO" class="user.vo.UserVO" scope="page" />
		<jsp:setProperty property="*" name="uVO" />
		<%
		UserAuthenticationDAO uDAO = UserAuthenticationDAO.getInstance();
		boolean isSuccess = false;

		try {

			String questionIdStr = request.getParameter("security_question");
			if (questionIdStr != null && !questionIdStr.isEmpty()) {
				uVO.setQuestion_id(Integer.parseInt(questionIdStr));
			} //end if
			uVO.setGender(request.getParameter("gender"));
			uVO.setAddress1(request.getParameter("addr1"));
			uVO.setAddress2(request.getParameter("addr2"));
			uVO.setBirth(request.getParameter("birthdate"));
			uVO.setSecurityAnswer(request.getParameter("security_answer"));

			DataEncryption de = new DataEncryption("abcdef0123456789");

			//비밀번호 일방향 HASH
			uVO.setPassword(DataEncryption.messageDigest("SHA-1", uVO.getPassword()));
			//상세주소 양방향
			uVO.setAddress2(de.encrypt(uVO.getAddress2()));

			uDAO.insertUser(uVO);
			isSuccess = true;

		} catch (SQLException se) {
			se.printStackTrace();
			isSuccess = false;
		} //end catch
		%>
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
		<script type="text/javascript">
<%if (isSuccess) {%>
		Swal.fire({
	          icon: 'success',
	          title: '회원가입 완료!',
	          text: '다시 로그인 해주세요.',
	          confirmButtonText: '확인'
	     }).then((result) => {
	         if (result.isConfirmed) {
	             // 확인 버튼을 눌렀을 때 현재 창을 login_page_o.jsp로 이동
	             window.location.href = "login_page_o.jsp";
	         }//end if
	     });
<%} else {%>
		alert("회원가입중 문제 발생");
		location.href="login_page_o.jsp";
<%}%>
</script>

	</div>
</body>
</html>