<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info="아이디찾기1-1"
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

<!-- datepicker plugin -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.14.0/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.14.0/jquery-ui.js"></script>

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

.formDiv {
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

.find_id_input{
	width: 60%;
	margin: 0px auto;
	margin-top: 30px;
	
}

#find_id_btn_submit {
    width: 100px;
    margin-top: 50px;
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
	$("#find_id_btn_submit").click(function(){
		chkNull();
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

function chkNull(){
	if($("#name").val().trim() == ""){
		chkMsg("#name", "이름을");
		return;
	}//end if
	
	let phone = $('#phone').val();
    
    // 숫자만 남기고 '-' 제거 후 길이 확인
    phone = phone.replace(/[^0-9]/g, '');
    
    if (phone.length !== 11) {
        alert("휴대전화를 확인해주세요");
        $("#phone").focus();
        return;
    }//end if
    
    if ($("#birthdate").val().length !== 6) {
        alert("생년월일을 확인해주세요");
        $("#birthdate").focus();
        return;
    }//end if
    
    $("#idFrm").submit();
	
}
function chkMsg(formControl, msg){
	alert(msg+ " 입력해주세요");
	$(formControl).focus();
}
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

<!-- 폼 -->
<div class="formDiv">
    <form name="idFrm" id="idFrm" action="find_id_process.jsp" method="post">
    <div class="bold">아이디 찾기</div>
    <div class="sub"><hr style="border: 0; border-bottom: 2px solid #000;">이름, 휴대전화, 이메일주소를 입력하세요</div>
    
    <div class="find_id_input">
    <div class="input-group flex-nowrap input_text">
  	<span class="input-group-text" id="addon-wrapping"><label for="name">이름</label></span>
  	<input type="text" class="form-control" id="name" name="name" placeholder="이름" aria-label="Username" aria-describedby="addon-wrapping">
	</div>

	<div class="input-group flex-nowrap input_text">
  	<span class="input-group-text" id="addon-wrapping"><label for="phone">휴대전화</label></span>
  	<input type="text" class="form-control" id="phone" name="phone"  placeholder="휴대전화" aria-label="Username" aria-describedby="addon-wrapping">
	</div>

	<div class="input-group flex-nowrap input_text">
 	<span class="input-group-text" id="addon-wrapping"><label for="birth">생년월일</label></span>
 	<input type="text" class="form-control" id="birthdate" name="birthdate" placeholder="생년월일" aria-label="Username" aria-describedby="addon-wrapping" value="970429">
	</div>
    </div>
        
        <div class="find_id_button">
            <input type="button" id="find_id_btn_submit" value="다음">
        </div>
    </form>
</div>
</div>
</body>
</html>