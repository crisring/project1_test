<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="비밀번호 찾기 1-3"
    %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String userId=request.getParameter("userId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="shotcut icon" href="http://192.168.10.218/jsp_prj/common/images/favicon.ico"/>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

<!-- bootstrap CDN 시작 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style type="text/css">
.container {
    text-align: left;
    margin:0 auto;
    margin-top: 30px;
    padding: 40px;
    border-radius: 10px;
    width: 500px;
}

.logo-link {
    display: block;
    margin-bottom: 20px;
    text-align: center;
}

.logo {
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

.input_text span{ 
	width: 140px;	
}

#btn_submit {
    display: block;
    margin: 50px auto;
    background-color: #28a745;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
}

#btn_submit:hover {
    background-color: #218838;
}

</style>
<script type="text/javascript">
$(function(){
	$("#btn_submit").click(function(){
		chkNull();
	});
});//ready

function chkNull(){
	if($("#password").val().trim() == ""){
		alert("비밀번호를 확인해주세요");
		$("#password").focus();
		return;
	}//end if
	if($("#password").val() != $("#chkPassword").val()){
		alert("비밀번호를 다시 확인해주세요");
		$("#password").focus();
		return;
	}//end if
	$("#frm").submit();
	
}//chkNull
</script>
</head>
<body>
<div id="wrap">
<div class="container">
    <h4>비밀번호 변경</h4>
    <hr>
    <form name="frm" id="frm" action="find_password_process.jsp" method="post">
    <p class="description">새 비밀번호를 입력해 주세요!!!</p>
    <div class="input-group flex-nowrap input_text">
  	<span class="input-group-text" id="addon-wrapping">새 비밀번호</span>
  	<input type="password" class="form-control" id="password" name="password" placeholder="새 비밀번호" aria-label="Username" aria-describedby="addon-wrapping">
	</div>

	<div class="input-group flex-nowrap input_text">
  	<span class="input-group-text" id="addon-wrapping">비밀번호 확인</span>
  	<input type="password" class="form-control" id="chkPassword" name="chkPassword"  placeholder="비밀번호 확인" aria-label="Username" aria-describedby="addon-wrapping">
	</div>
	
	<input type="hidden" name="userId" value="<%= userId %>">
    <!-- 다음 버튼 -->
    <input type="button" id="btn_submit" value="다음">
    </form>
</div>
</div>
</body>
</html>









