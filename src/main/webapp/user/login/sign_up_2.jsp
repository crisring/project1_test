<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="회원가입1-1"
    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Insert title here</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<!-- bootstrap CDN 시작 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- jQuery CDN 시작 -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<!-- datepicker plugin -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.14.0/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.14.0/jquery-ui.js"></script>

<style type="text/css">
.container {
    width: 700px;
    margin: 0 auto;
    margin-top: 70px;
    padding: 20px;
    border-radius: 10px;
    position: relative;
}

.login_logo{
    position: absolute;
    top: -80px;
    left: 20%; 
    margin-bottom: 20px;
}

body {
    font-family: Arial, sans-serif;
    background-color: #fff;
    margin: 0;
    padding: 20px;
}

#signup_form {
    width: 500px;
    margin: 0 auto;
    background-color: #fff;
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 8px;
}

.radio_wrap{
	display: flex;
    justify-content: center;
}

.btn_radio{
	width: 40%;
    padding: 8px;
    margin-bottom: 16px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

label {
    display: block;
    margin-bottom: 8px;
    font-weight: bold;
}

input, select {
    width: 100%;
    padding: 8px;
    margin-bottom: 16px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.password_wrap {
    position: relative;
}

.password_wrap button {
    position: absolute;
    right: 8px;
    top: 8px;
    background: none;
    border: none;
    cursor: pointer;
}
.id_wrap {
    position: relative;
}

.id_wrap button {
    position: absolute;
    font-size: 14px;
    color: #333;
    right: 8px;
    top: 8px;
    background: none;
    border: none;
    cursor: pointer;
}

.id_wrap button:hover{
	color: #aaaaff
}

#signup_btn {
    width: 100%;
    padding: 10px;
    margin-top : 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
}

#signup_btn:hover {
    background-color: #45a049;
}

</style>
<!-- 다음 우편번호 API 시작 -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 다음 우편번호 API 끝 -->
<script type="text/javascript">
$(function(){
	$("#signup_btn").click(function(){
		event.preventDefault();
		
		const selectedValue = $("#security_question").val();
		if (selectedValue) {
			// 숫자로 변환하여 설정
			$("#security_question").val(Number(selectedValue));
		}
		
		chkNull();
	});
	
	$("#findZipcode").click(function(){
		searchZipcode();
	});
	
	$( "#birthdate" ).datepicker({
		changeMonth: true,
		changeYear: true,
		showOtherMonths: true,
		showMonthAfterYear:true,
		yearRange: "c-99:c+99",
        dateFormat: "ymmdd",
        yearSuffix: "년",
        monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
        monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'], 
        dayNamesMin: [ "일", "월", "화", "수", "목", "금", "토" ],
   		prevText: "이전월",
   		nextText: "다음월"
   	});
	
	$('#phone').on('input', function() {
        let phone = $(this).val();

        // 숫자만 남기고 '-' 제거
        phone = phone.replace(/[^0-9]/g, '');

        // 숫자 11자리를 초과하지 않도록 제한
        if (phone.length > 11) {
            phone = phone.substring(0, 11);
        }

        // 포맷 적용
        if (phone.length >= 7) {
            phone = phone.replace(/(\d{3})(\d{4})(\d{0,4})/, "$1-$2-$3");
        } else if (phone.length >= 4) {
            phone = phone.replace(/(\d{3})(\d{0,4})/, "$1-$2");
        }

        // 최종 형식화된 값을 입력란에 넣기
        $(this).val(phone);
    });
	
});//ready

function searchZipcode(){
	new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수
            var extraRoadAddr = ''; // 참고 항목 변수

            // 법정동명이 있을 경우 추가한다. (법정리는 제외)
            // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
            if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                extraRoadAddr += data.bname;
            }
            // 건물명이 있고, 공동주택일 경우 추가한다.
            if(data.buildingName !== '' && data.apartment === 'Y'){
               extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
            }
            // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
            if(extraRoadAddr !== ''){
                extraRoadAddr = ' (' + extraRoadAddr + ')';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById("addr1").value = roadAddr;
            document.getElementById("addr2").focus();
        }
    }).open();
}//searchZipcode

function chkNull(){
	if($("#userId").val().trim() == ""){
		chkMsg("#userId", "아이디를");
		return;
	}//end if
	if($("#idDupFlag").val() != "Y"){
		alert("아이디 중복확인을 해주세요");
		$("#userId").focus();
		return;
	}
	if($("#password").val().trim() == ""){
		chkMsg("#password", "비밀번호를");
		return;
	}//end if
	if($("#password").val() != $("#chk_password").val()){
		alert("비밀번호를 다시 확인해주세요");
		$("#password").focus();
		return;
	}//end if
	if($("#email").val().trim() == ""){
		chkMsg("#email", "이메일을");
		return;
	}//end if
    if(!validateEmail($("#email").val())) {
        alert("이메일 형식이 맞지 않습니다. 예: test@test.com");
        $("#email").focus();
        return;
    }
    if($("#phone").val().trim() == ""){
		chkMsg("#phone", "휴대전화를");
		return;
	}//end if
	if($("#name").val().trim() == ""){
		chkMsg("#name", "이름을");
		return;
	}//end if
	
	let phone = $('#phone').val();
    
    // 숫자만 남기고 '-' 제거 후 길이 확인
    phone = phone.replace(/[^0-9]/g, '');
    
    if (phone.length !== 11) {
        alert("휴대전화를 다시 입력해주세요");
        $("#phone").focus();
        return;
    }//end if
	
	
	
	
	
	$("#signup_form").submit();
	
}//chkNull

//유효성검사, 경고메시지 및 포커스 설정
function chkMsg(formControl, msg){
	alert(msg+ " 입력해주세요");
	$(formControl).focus();
}

//이메일 유효성 검사 함수
function validateEmail(email) {
    // 이메일 형식을 확인하는 정규식
    const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    return emailPattern.test(email);
}

//아이디 중복확인
function idDup(){
	//1. 현재창에 아이디를 가져와서
	var id=document.getElementById('userId').value;
	//2. query string 만들어서 팝업을 띄운다
	window.open("id_dup.jsp?id="+id, "idDup",
			"width=485, height=390, top="+(window.screenY+100)+
			", left="+(window.screenX+200));
	
}

function togglePasswordVisibility() {
    const passwordInput = document.getElementById('password');
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
}
function toggleChkPasswordVisibility() {
    const passwordInput = document.getElementById('chk_password');
    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordInput.setAttribute('type', type);
}
</script>
</head>
<body>
<div id="wrap">
<div class="container">
	<a href="../../index.jsp" class="login_logo_link">
		<img src="http://192.168.10.218/jsp_prjhttp://localhost/proejct1/user/login/images/logo.png" alt="EGO EMPORIUM" class="login_logo">
	</a>
	
    <form id="signup_form" action="signup_process.jsp" method="post">
    	<div class="id_wrap">
        <input type="text" id="userId" name="userId" placeholder="아이디" value="test">
        <button type="button" id="id_dup" onclick="idDup()">중복확인</button>
        <input type="hidden" id="idDupFlag" name="idDupFlag"/>
    	</div>

        <div class="password_wrap">
            <input type="password" id="password" name="password" placeholder="비밀번호" value="test1">
            <button type="button" id="togglePassword" onclick="togglePasswordVisibility()">👁️‍🗨️</button>
        </div>
        <div class="password_wrap">
            <input type="password" id="chk_password" name="chk_password" placeholder="비밀번호 확인"  value="test1">
            <button type="button" id="togglechkPassword" onclick="toggleChkPasswordVisibility()">👁️‍🗨️</button>
        </div>
		
        <input type="email" id="email" name="email" placeholder="이메일 주소" value="test@test.com">

        <input type="text" id="name" name="name" placeholder="이름" value="테스트">

        <input type="text" id="birthdate" name="birthdate" pattern="\d{6}" placeholder="생년월일 6자리" value="970429">

		<div class="radio_wrap">
        <input type="radio" class="btn-check" id="male" name="gender" value="M">
        <label class="btn btn_radio" for="male">남자</label>
        <input type="radio" class="btn-check" id="female" name="gender" value="F">
        <label class="btn btn_radio" for="female">여자</label>
		</div>
        
        <input type="text" id="phone" name="phone" placeholder="휴대전화번호" maxlength="13" value="010-1111-2222"><!--  pattern="\d{3}-\d{4}-\d{4}" required -->

        <label for="security_question">비밀번호 확인 질문</label>
        <select id="security_question" name="security_question">
            <option value="">질문을 선택하세요</option>
            <option value="1">기억에 남는 추억의 장소는?</option>
            <option value="2">자신의 보물 제1호는?</option>
            <option value="3">가장 기억에 남는 선생님 성함은?</option>
            <option value="4">인상 깊게 읽은 책 이름은?</option>
            <option value="5">자신이 두번째로 존경하는 인물은?</option>
        </select>

        <label for="security_answer">비밀번호 확인 답변</label>
        <input type="text" id="security_answer" name="security_answer" value="테스트">
		
		<div class="zipcode">
        <label for="zipcode">우편 번호</label>
        <input type="text" id="zipcode" name="zipcode" readonly="readonly" style="width: 70px;" value="13480">
        <input type="button" value="우편번호 검색" id="findZipcode" class="btnMy" style="width: 140px">
		</div>
		
		<div class="addr">
		<input type="text" name="addr1" id="addr1" readonly="readonly" style="margin-bottom: 3px"  value="경기 성남시 분당구 대왕판교로 477"> 
		<input type="text" name="addr2" id="addr2" value="1">
		</div>
		
	
        <button id="signup_btn">완료</button>
    </form>
</div>

</div>
</body>
</html>