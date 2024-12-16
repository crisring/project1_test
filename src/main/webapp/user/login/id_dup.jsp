<%@page import="user.dao.UserAuthenticationDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="아이디 중복확인"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- bootstrap CDN 시작-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>
<!-- bootstrap CDN 끝-->

<style type="text/css">
#wrap {
	width: 452px;
	height: 400px;
	margin: 0px auto;
}

#idBg {
	width: 452px;
	height: 400px;
	background: #FFFFFF url(images/id_dup_bg.png) no-repeat;
	position: relative;
}

#resultDiv {
	margin-top: 10px;
	margin-bottom: 10px;
	padding-top: 280px;
	padding-left: 30px
}

#idFrm {
	position: absolute;
	top: 220px;
	left: 70px
}
</style>
<!-- bootstrap CDN 시작-->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
	crossorigin="anonymous"></script>

<!-- jQuery CDN 시작-->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<script type="text/javascript">
	$(function() {
		$("#btn").click(function() {
			chkNull();
		});//click

		$("#id").keydown(function(evt) {
			if (evt.which == 13) {
				chkNull();
			}//end if
		});//click

		$("#btnUse").click(function() {
			useId();
		});//click

	});//ready

	function useId() {
		//자식창의 아이디를 가져와서
		var id = $("#id").val();
		//부모창에 전달한 후
		opener.window.document.getElementById("userId").value = id;
		//1.부모창에 중복확인한 상태를 저장할수 있는 HTML Form Control(hidden)을 만들고
		// 값을 설정 한 후 
		//2.가입 버튼 눌렀을 때 중복확인한 상태의 아이디인지를 검사 한 후 
		//3.회원가입 페이지로 이동
		opener.window.document.getElementById("idDupFlag").value = 'Y';
		//자식창 닫기
		self.close();
	}//useId

	function chkNull() {
		var id = $("#id").val();

		if (id.replace(/ /g, "") == "") {
			alert("아이디는 필수 입력!!");
			$("#id").val("");
			$("#id").focus();
			return;
		}//end if

		$("#idDupFrm").submit();
	}
</script>
</head>
<body>
	<div id="wrap">
		<div id="idBg">
			<form name="idDupFrm" id="idDupFrm" action="id_dup.jsp">
				<div id="idFrm">
					<input type="text" name="id" id="id" class="inputBox"
						value="${ param.id }" /> <input type="button" id="btn"
						value="아이디 중복확인" class="btnMy" style="width: 140px" /> <input
						type="text" style="display: none" />
					<!-- web browser에서 키입력을 받는 HTML Form Control이 하나인 경우
		엔터를 치면 자동으로 submit 이된다.(자바스크립 유효성 검증을 실패해도 submit이된다.)
		=> <input type="text" 보이지 않게 생성하면 된다. -->
				</div>
			</form>
			<%
			String id = request.getParameter("id");

			if (id != null && !"".equals(id)) {
				UserAuthenticationDAO uDAO = UserAuthenticationDAO.getInstance();

				boolean selectFlag = uDAO.selectDupId(id);

				if (selectFlag) {
			%>
			<div id="resultDiv">
				입력하신 아이디는 <span id="resultMsg" style="color: #FF0000">사용중인 </span>아이디
				입니다.
			</div>
			<%
			} else {
			%>
			<div id="resultDiv">
				입력하신
				<%=id%>
				아이디는(은) <span id="resultMsg">사용 가능 한 </span> 아이디 입니다.
			</div>
			<div style="text-align: center">
				<input type="button" value="사용" id="btnUse" class="btn btn-info" />
			</div>
			<%
			} //end else
			} //end if
			%>

		</div>
	</div>
</body>
</html>