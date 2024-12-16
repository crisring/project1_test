<%@page import="user.vo.OrderListVO"%>
<%@page import="user.vo.ShippingVO"%>
<%@page import="user.dao.ShippingDAO"%>
<%@page import="user.dao.OrderDAO"%>
<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/common/session_chk.jsp"%>
<%
OrderDAO oDAO = new OrderDAO();
ShippingDAO sDAO = new ShippingDAO();
List<ShippingVO> shippingList = sDAO.selectAllShipping(sessionId);
List<OrderListVO> orderList = oDAO.SelectOrderList(sessionId);
pageContext.setAttribute("orderList", orderList);
pageContext.setAttribute("shippingList", shippingList);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 목록</title>
<link rel="stylesheet" href="/user/css/main.css">
<link rel="stylesheet" href="/user/css/order_list.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
</head>
<body>
	<jsp:include page="/common/header.jsp" />

	<c:choose>
		<c:when test="${empty orderList}">
			<div class="no-orders">주문정보가 없습니다.</div>
		</c:when>
		<c:otherwise>
			<div class="orders-grid">
				<c:forEach var="order" items="${orderList}">
					<div
						class="order-container ${order.confirmed ? 'order-confirmed' : ''}">
						<div class="order-info">
							<img src="/common/images/${order.imgName}"
								alt="${order.productName}" />
							<div class="product-name">
								<h2>${order.productName}</h2>
							</div>
						</div>

						<div class="progress-container">
							<div class="progress-bar">
								<div class="progress-steps">
									<div
										class="step ${order.shippingStatus eq '배송준비' || order.shippingStatus eq '배송중' || order.shippingStatus eq '배송완료' ? 'active' : ''}">
										<div class="circle"></div>
										<span>배송 준비중</span>
									</div>
									<div
										class="step ${order.shippingStatus eq '배송중' || order.shippingStatus eq '배송완료' ? 'active' : ''}">
										<div class="circle"></div>
										<span>배송중</span>
									</div>
									<div
										class="step ${order.shippingStatus eq '배송완료' ? 'active' : ''}">
										<div class="circle"></div>
										<span>배송 완료</span>
									</div>
								</div>
								<div class="progress-line" data-status="${order.shippingStatus}"></div>
							</div>
						</div>

						<div class="confirm-message"
							style="display: ${order.confirmed ? 'block' : 'none'}">구매가
							확정되었습니다.</div>

						<div class="button-container">
							<button
								class="confirm-btn ${order.confirmed ? 'btn-confirmed' : ''}"
								data-order-id="${order.orderId}"
								${order.confirmed ? 'disabled' : ''}>${order.confirmed ? '구매확정 완료' : '구매 확정'}
							</button>
							<button class="cancel"
								${order.confirmed ? 'style="display: none;"' : ''}>취소
								요청</button>
						</div>
					</div>
				</c:forEach>
			</div>
		</c:otherwise>
	</c:choose>

	<!-- 리뷰 작성 모달 -->
	<div id="reviewModal" class="modal">
		<div class="modal-content">
			<span class="close modal-close">&times;</span>
			<h3>주문 하신 상품이 마음에 드셨나요?</h3>
			<br>
			<div>
				소중한 경험을 리뷰로 남겨주세요.<br> 더 나은 서비스 제공과 다른 이용자들의 선택에 <br> 큰
				도움이 됩니다
			</div>
			<br>
			<div class="review-container">
				<button type="button" class="review">리뷰 쓰러가기</button>
			</div>
		</div>
	</div>

	<!-- 취소 요청 모달 -->
	<div id="cancelModal" class="modal">
		<div class="modal-content">
			<span class="close modal-close">&times;</span>
			<form id="cancelForm" action="cancel_process.jsp" method="post">
				<div class="order-info">
					<img src="" alt="" id="cancelModalImg" />
					<div>
						<h2 class="product-name" id="cancelModalName"></h2>
					</div>
				</div>
				<div class="reason-label">
					<span>상세 이유 입력</span> <span id="cancelCharCount">0/100자</span>
				</div>

				<textarea id="cancelReason" name="cancelReason"
					placeholder="취소 이유를 입력해주세요."
					oninput="updateCharCount('cancelReason', 'cancelCharCount')"></textarea>

				<input type="hidden" id="cancelProductName" name="productName">
				<input type="hidden" id="cancelImgName" name="imgName"> <input
					type="hidden" id="cancelOrderId" name="orderId">
				<button type="button" class="submit-btn"
					onclick="submitCancelRequest()">확인</button>
				<button type="button" class="cancel-btn"
					onclick="closeModal('cancelModal')">닫기</button>
			</form>
		</div>
	</div>

	<!-- 리뷰 작성 모달 -->
	<div id="reviewModal" class="modal">
		<div class="modal-content">
			<span class="close modal-close">&times;</span>
			<h3>주문 하신 상품이 마음에 드셨나요?</h3>
			<br>
			<div>
				소중한 경험을 리뷰로 남겨주세요.<br> 더 나은 서비스 제공과 다른 이용자들의 선택에 <br> 큰
				도움이 됩니다
			</div>
			<br>
			<div class="review-container">
				<button type="button" class="review" onclick="goToReviewPage()">
					리뷰 쓰러가기</button>
			</div>
		</div>
	</div>

	<script>
		$(function() {
			// 구매확정 버튼 클릭 이벤트
			$('.confirm-btn').click(
					function(e) {
						e.preventDefault();
						const $button = $(this);
						const orderId = $button.data('order-id');
						const $orderContainer = $button
								.closest('.order-container');
						const productName = $orderContainer.find(
								'.product-name h2').text();
						const imgName = $orderContainer.find('.order-info img')
								.attr('src').split('/').pop();

						if (confirm('구매를 확정하시겠습니까?')) {
							$.ajax({
								url : 'confirm_process.jsp',
								type : 'POST',
								data : {
									orderId : orderId,
									productName : productName,
									imgName : imgName
								},
								success : function() {
									// UI 업데이트
									updateConfirmedUI($orderContainer);

									// 리뷰 모달 표시
									setTimeout(function() {
										showReviewModal(productName, imgName,
												orderId);
									}, 500);
								},
								error : function() {
									alert('구매확정 처리 중 오류가 발생했습니다.');
								}
							});
						}
					});

			// 구매확정 UI 업데이트 함수
			function updateConfirmedUI($container) {
				// 주문 컨테이너에 confirmed 클래스 추가
				$container.addClass('order-confirmed');

				// 버튼 변경
				$container.find('.confirm-btn').text('구매확정 완료').prop(
						'disabled', true).addClass('btn-confirmed');

				// 취소 버튼 숨기기
				$container.find('.cancel').hide();

				// 진행 상태 표시 변경
				$container.find('.progress-steps .step').addClass('completed');
				$container.find('.progress-line').addClass('completed');

				// 확정 메시지 표시
				if ($container.find('.confirm-message').length === 0) {
					$container.find('.button-container').before(
							'<div class="confirm-message">구매가 확정되었습니다.</div>');
				}
			}

			// 리뷰 모달 표시 함수
			function showReviewModal(productName, imgName, orderId) {
				$('#reviewModal').data({
					'productName' : productName,
					'imgName' : imgName,
					'orderId' : orderId
				}).show();
			}

			// 취소 요청 모달 표시 함수
			function showCancelModal(productName, imgName, orderId) {
				document.getElementById('cancelModalImg').src = '/common/images/'
						+ imgName;
				document.getElementById('cancelModalImg').alt = productName;
				document.getElementById('cancelModalName').textContent = productName;
				document.getElementById('cancelProductName').value = productName;
				document.getElementById('cancelImgName').value = imgName;
				document.getElementById('cancelOrderId').value = orderId;
				$('#cancelModal').show();
			}

			// 취소 버튼 클릭 이벤트
			$('.cancel').click(
					function() {
						const $orderContainer = $(this).closest(
								'.order-container');
						const productName = $orderContainer.find(
								'.product-name h2').text();
						const imgName = $orderContainer.find('.order-info img')
								.attr('src').split('/').pop();
						const orderId = $orderContainer.data('order-id');
						showCancelModal(productName, imgName, orderId);
					});

			// 리뷰 버튼 클릭 이벤트
			$(document).on('click', '.review', function() {
				const modalData = $('#reviewModal').data();

				$.ajax({
					type : "POST",
					url : "set_review_session.jsp",
					data : {
						productName : modalData.productName,
						imgName : modalData.imgName,
						orderId : modalData.orderId
					},
					success : function() {
						window.location.href = "review_write.jsp";
					},
					error : function(xhr) {
						console.error('Error:', xhr.status);
						alert('리뷰 페이지 이동 중 오류가 발생했습니다.');
					}
				});
			});

			// 모달 닫기 이벤트들
			$('.modal-close').click(function() {
				$(this).closest('.modal').hide();
			});

			$(document).keydown(function(e) {
				if (e.keyCode === 27) { // ESC 키
					$('.modal').hide();
				}
			});

			// 취소 요청 제출
			function submitCancelRequest() {
				const reason = $('#cancelReason').val();

				if (!reason) {
					alert('취소 사유를 입력해주세요.');
					return;
				}

				if (reason.length < 10) {
					alert('취소 사유를 10자 이상 입력해주세요.');
					return;
				}

				if (confirm('정말 취소 요청하시겠습니까?')) {
					$.ajax({
						url : 'cancel_process.jsp',
						type : 'POST',
						data : $('#cancelForm').serialize(),
						success : function(response) {
							alert('취소 요청이 접수되었습니다.');
							closeModal('cancelModal');
							location.reload();
						},
						error : function() {
							alert('취소 요청 처리 중 오류가 발생했습니다.');
						}
					});
				}
			}

			// 문자 수 카운터 업데이트
			function updateCharCount(textareaId, countId) {
				const textarea = document.getElementById(textareaId);
				const charCount = document.getElementById(countId);
				const length = textarea.value.length;
				charCount.textContent = length + '/100자';
			}

			// 모달 닫기 함수
			function closeModal(modalId) {
				const modal = document.getElementById(modalId);
				if (modal) {
					modal.style.display = 'none';
					if (modalId === 'cancelModal') {
						document.getElementById('cancelReason').value = '';
						document.getElementById('cancelCharCount').textContent = '0/100자';
					}
				}
			}

			// 페이지 로드 시 세션 체크
			$(window)
					.on(
							'load',
							function() {
	<%if (session.getAttribute("showReviewModal") != null && session.getAttribute("showReviewModal").equals("true")) {%>
		const reviewProductName = "${reviewProductName}";
								const reviewImgName = "${reviewImgName}";
								const reviewOrderId = "${reviewOrderId}";
								showReviewModal(reviewProductName,
										reviewImgName, reviewOrderId);
	<%}%>
		});
		});
	</script>
</body>
</html>