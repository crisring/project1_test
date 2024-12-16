<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="비밀번호 찾기 1-1"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap CDN 시작 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style type="text/css">
.container {
	margin: 0px auto;
	margin-top: 20px;
    text-align: center;
    background-color: white;
    padding: 40px;
    border-radius: 10px;
    width: 450px;
    box-sizing: border-box;
}

.logo_link {
    display: block;
    margin-bottom: 20px;
    text-align: center;
}

.logo_fp1 {
    width: 180px;
    margin: 0 auto;
}

.input_group_fp1 {
    margin-top: 20px;
}

.inputId{
    border-radius: 5px;
    border: 1px solid #ccc;
    padding: 10px;
    width: 300px;
}

.group_text_fp1 {
    background-color: white;
    border: none;
}

.btn_submit {
    background-color: #28a745;
    color: white;
    border: none;
    padding: 10px;
    width: 345px;
    border-radius: 5px;
    margin-top: 20px;
    cursor: pointer;
}

.btn_submit:hover {
    background-color: #218838;
}

.ex_text{ 
	font-size: 12px;
	color: #bfc1c9;
 }


.links {
    margin-top: 15px;
    font-size: 13px;
    color: #007bff;
}

.links a {
    color: #55ba89;
    text-decoration: none;
}

.links a:hover {
    text-decoration: underline;
}
</style>
<script type="text/javascript">
$(function(){
	$("#btn_submit").click(function(){
		chkNull();
	});
});//ready

function chkNull(){
	if($("#user_id").val().trim() == ""){
		alert("아이디를 확인해주세요");
		$("#user_id").focus();
		return;
	}//end if
	
	$("#frm").submit();
	
}//chkNull
</script>
</head>
<body>

<div id="wrap">
<%--<jsp:include page="../common/header.jsp"/>--%>
<div class="container">
    <a href="../../index.jsp" class="logo_link">
        <img src="images/logo.png" alt="EGO EMPORIUM" class="logo_fp1">
    </a>
    <h6>비밀번호를 찾고자 하는 아이디를 입력해주세요.</h6>

    <form name="frm" id="frm" action="find_password_2.jsp" method="post">
    <div class="input-group input_group_fp1">
        <span class="input-group-text group_text_fp1">
            👤
        </span>
        <input class="inputId" type="text" id="user_id" name="user_id" placeholder="네이버 아이디 또는 단체 아이디" aria-label="아이디 입력">
    </div>

    <!-- 다음 버튼 -->
    <input type="button" id="btn_submit" class="btn_submit" value="다음"/>
    </form>

    <!-- 아이디 찾기 링크 -->
    <div class="links">
        <span class="ex_text">아이디가 기억나지 않는다면?</span>&nbsp;&nbsp; <a href="find_id.jsp">아이디 찾기</a>
    </div>
</div>

</div>
</body>
</html>









