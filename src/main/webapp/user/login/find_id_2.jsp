<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="아이디찾기1-2"
    %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../common/post_chk.jsp" %>
<% 
request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
<!-- bootstrap CDN 시작 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style type="text/css">
.containerDiv {
    margin: 0px auto;
    text-align: center;
}
.find_links {
	width: 100%;
	line-height:50px;
    background-color: #af7de7;
    padding: 10px;
    color: white;
    top: 0;
    left: 0;
    right: 0;
}
.find_links a {
    color: white;
    text-decoration: none;
    margin: 0 20px;
    font-size: 16px;
}

.img_div{ 
	display:inline-block; 
	width:0px; 
	height:10px;
	float: left;
}

#logo_img{ 
	border-radius:50%;
}

.form_container {
    margin: 0px auto;
    padding-top: 30px;
    background-color: #fff;
}

.input_text{
	width: 400px;
	height: 50px;
}

.input_text span{
	width: 100px;
}

.bold{
	width: 60%;
	margin: 0px auto;
    text-align: left;
    font-size: 20px;
    font-weight: bold;
}

.sub{
	width: 60%;
	margin: 0px auto;
    text-align: left;
    font-size: 12px;
    margin-bottom: 20px;
}

.resultDiv{
	margin:0 auto;
	width:500px;
	height:200px;
	padding-top : 80px;
	background-color: #f2f2f2;
}

.resultDiv span{
	font-weight: bold;
}

#find_id_2_btn_submit {
    width: 100px;
    margin-top: 20px;
    padding: 10px;
    background-color: #d2d2d2;
    color: white;
    border: 1px solid #aaa;
    cursor: pointer;
}

.input-group label:hover{
	cursor: text;
}

</style>
<script type="text/javascript">
$(function(){
	$("#find_id_2_btn_submit").click(function(){
		window.location.href="login_page_o.jsp";
	});
});//ready
</script>
</head>
<body>
<div class="containerDiv">
<!-- 상단 아이디 찾기 / 비밀번호 찾기 -->
<div class="find_links">
	<div class="img_div">
	<a href="../../index.jsp" class="manu-link">
	<img src="https://shop-phinf.pstatic.net/20240806_143/1722911189831GfusA_PNG/45699262431325566_112145065.png?type=m120" width="50" height="50" id="logo_img">
	</a>
	</div>
    <a href="find_id.jsp">아이디 찾기</a>
    <a href="find_password_1.jsp">비밀번호 찾기</a>
</div>
<% 
    String user_id = request.getParameter("user_id");
    String name = request.getParameter("name");
%>
<!-- 폼 -->
<div class="form_container">
    <form action="#">
    <div class="bold">아이디 찾기</div>
    <div class="sub"><hr style="border: 0; border-bottom: 2px solid #000;"></div>
    
    <div class="resultDiv">
    <span><%= name %></span>님의 아이디는 <span><%= user_id %></span>입니다.
    </div>
    
    <div class="buttonDiv">
        <input type="button" id="find_id_2_btn_submit" value="확인">
    </div>
    </form>
</div>
</div>
</body>
</html>