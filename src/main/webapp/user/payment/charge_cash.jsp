<%@page import="user.dao.UserCashDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="/common/session_chk.jsp"%>

<%
// 임시 userId 설정 (실제로는 로그인 세션에서 가져와야 함)
String userId = sessionId;

// 현재 보유 캐시 조회
UserCashDAO cashDAO = new UserCashDAO();
int currentCash = cashDAO.selectUserCash(userId);

request.setAttribute("currentCash", currentCash);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>네이버페이 캐시 충전</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<style>
.container {
	max-width: 600px;
	margin: 50px auto;
	padding: 20px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.current-cash {
	background: #f8f9fa;
	padding: 20px;
	margin-bottom: 20px;
	border-radius: 5px;
}

.charge-options {
	display: grid;
	grid-template-columns: repeat(3, 1fr);
	gap: 10px;
	margin-bottom: 20px;
}

.charge-option {
	padding: 15px;
	border: 1px solid #ddd;
	border-radius: 5px;
	text-align: center;
	cursor: pointer;
}

.charge-option:hover, .charge-option.selected {
	background: #e9ecef;
	border-color: #03c75a;
}

.custom-amount {
	margin-bottom: 20px;
}

.custom-amount input {
	width: 100%;
	padding: 10px;
	margin-top: 5px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

.charge-button {
	width: 100%;
	padding: 15px;
	background: #03c75a;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.charge-button:disabled {
	background: #ddd;
	cursor: not-allowed;
}
</style>
</head>
<body>
	<div class="container">
		<div class="naver-pay-logo">
			<span>N</span> 네이버페이 충전
		</div>

		<div class="current-cash">
			<h3>현재 보유 네이버페이</h3>
			<p class="amount">
				<fmt:formatNumber value="${currentCash}" type="number" />
				원
			</p>
		</div>

		<div class="charge-options">
			<div class="charge-option" data-amount="10000">1만원</div>
			<div class="charge-option" data-amount="30000">3만원</div>
			<div class="charge-option" data-amount="50000">5만원</div>
			<div class="charge-option" data-amount="100000">10만원</div>
			<div class="charge-option" data-amount="300000">30만원</div>
			<div class="charge-option" data-amount="500000">50만원</div>
		</div>

		<div class="custom-amount">
			<label for="customAmount">직접 입력</label> <input type="number"
				id="customAmount" min="1000" step="1000" placeholder="충전할 금액을 입력하세요">
		</div>

		<div class="payment-method">
			<h3>결제수단 선택</h3>
			<div class="method-options">
				<label> <input type="radio" name="method" value="card"
					checked> 신용/체크카드
				</label> <label> <input type="radio" name="method" value="bank">
					계좌이체
				</label>
			</div>
		</div>

		<button class="charge-button" disabled>네이버페이 충전하기</button>
	</div>

	<script>
    $(document).ready(function() {
        let selectedAmount = 0;

        // 충전 옵션 선택
        $('.charge-option').click(function() {
            $('.charge-option').removeClass('selected');
            $(this).addClass('selected');
            selectedAmount = parseInt($(this).data('amount'));
            $('#customAmount').val('');
            $('.charge-button').prop('disabled', false);
        });

        // 직접 입력
        $('#customAmount').on('input', function() {
            let amount = parseInt($(this).val());
            if(amount >= 1000) {
                $('.charge-option').removeClass('selected');
                selectedAmount = amount;
                $('.charge-button').prop('disabled', false);
            } else {
                $('.charge-button').prop('disabled', true);
            }
        });

        // 충전하기 버튼 클릭
        $('.charge-button').click(function() {
            if(selectedAmount <= 0) {
                alert('충전할 금액을 선택하거나 입력해주세요.');
                return;
            }

            if(confirm(selectedAmount.toLocaleString() + '원을 충전하시겠습니까?')) {
                const method = $('input[name="method"]:checked').val();
                $.ajax({
                    url: 'process_charge.jsp',
                    type: 'POST',
                    data: {
                        userId: '<%=userId%>
		', // 작은따옴표로 감싸기
																	amount : selectedAmount,
																	method : method
																},
																success : function(
																		response) {
																	if (response.success) {
																		alert('네이버페이 충전이 완료되었습니다.');
																		// opener가 있는 경우 (팝업으로 열린 경우)
																		if (opener) {
																			opener.location
																					.reload(); // 부모 창 새로고침
																			window
																					.close(); // 현재 창 닫기
																		} else {
																			// 일반 페이지로 열린 경우
																			location.href = 'payment.jsp?productId=${param.productId}&color=${param.color}&size=${param.size}';
																		}
																	} else {
																		alert('충전 중 오류가 발생했습니다: '
																				+ response.message);
																	}
																},
																error : function() {
																	alert('충전 처리 중 오류가 발생했습니다.');
																}
															});
												}
											});
						});
	</script>
</body>
</html>