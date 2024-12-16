<%@page import="user.vo.UserVO"%>
<%@page import="user.dao.UserAuthenticationDAO"%>
<%@page import="java.sql.SQLException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="비밀번호 찾기 1-2"%>
<%--<%@ include file="../common/post_chk.jsp" %>--%>
<%
request.setCharacterEncoding("UTF-8");
%>
<%
String userId = request.getParameter("user_id");

UserAuthenticationDAO uDAO = UserAuthenticationDAO.getInstance();
UserVO resultVO = null;
try {
	resultVO = uDAO.selectQuestion(userId);
} catch (SQLException se) {
	se.printStackTrace();
} //end catch

if (resultVO == null) {
%>
<script type="text/javascript">
        alert("해당 사용자를 찾을 수 없습니다. 다시 시도해주세요.");
        history.back();
    </script>
<%
return; // 이후 코드를 실행하지 않도록 리턴
}
%>
<%
String securityQuestion = resultVO.getSecurityQuestion_id();
String securityAnswer = resultVO.getSecurityAnswer();
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
.container {
	text-align: left;
	margin: 0px auto;
	margin-top: 20px;
	padding: 40px;
	border-radius: 10px;
	width: 500px;
}

.logo_link {
	display: block;
	margin-bottom: 20px;
	text-align: center;
}

.logo_fp2 {
	width: 180px;
	margin: 0 auto;
}

h4 {
	font-weight: bold;
}

hr {
	border: 0;
	border-bottom: 2px solid #000;
	width: 100%;
	margin-bottom: 20px;
}

.description {
	margin-top: 10px;
	margin-bottom: 20px;
	font-size: 14px;
	color: #666;
}

.input_text {
	width: 30px;
}

.btn_submit {
	display: block;
	margin: 100px auto;
	background-color: #28a745;
	color: white;
	border: none;
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
}

.btn_submit:hover {
	background-color: #218838;
}
</style>
<script type="text/javascript">
$(function(){
	$("#btn_submit").click(function(){
		var provideAnswer="<%=securityAnswer%>";
		var userAnswer = $("#securityAnswer").val();
		
		if(userAnswer == provideAnswer){
			window.open('find_password_3.jsp?userId=<%=userId%>
	',
								'idDup', 'width=550, height=450, top='
										+ (window.screenY + 200) + ', left='
										+ (window.screenX + 300));
					} else {
						alert("답변이 일치하지 않습니다. 다시 시도해주세요.");
					}//end else

				});
	});//ready
</script>
</head>
<body>
	<div id="wrap">
		<div class="container">
			<a href="../../index.jsp" class="logo_link"> <img
				src="images/logo.png" alt="EGO EMPORIUM" class="logo_fp2">
			</a>
			<h4>비밀번호 찾기</h4>
			<hr>
			<p class="description">회원가입 시 입력했던 질문의 답을 입력하세요</p>
			<!-- 질문 및 답변칸 -->
			<div class="input-group flex-nowrap">
				<span class="input-group-text" id="addon-wrapping">비밀번호 확인 질문</span>
				<input type="text" class="form-control input_text"
					name="securityQuestion" value="<%=securityQuestion%>"
					aria-label="Username" aria-describedby="addon-wrapping"
					readonly="readonly">
			</div>

			<div class="input-group flex-nowrap">
				<span class="input-group-text" id="addon-wrapping">비밀번호 확인 답변</span>
				<input type="text" class="form-control input_text"
					name="securityAnswer" id="securityAnswer" placeholder="답변을 입력하세요"
					aria-label="Username" aria-describedby="addon-wrapping">
			</div>


			<!-- 다음 버튼 -->
			<button id="btn_submit" class="btn_submit">다음</button>
		</div>
	</div>
</html>









