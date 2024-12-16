<%@page import="manage.inquiry.InquiryVO"%>
<%@page import="user.dao.UserInquiryDAO"%>
<%@page import="user.vo.InquirySearchVO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/common/session_chk.jsp"%>
<%
// 검색 키워드 받기
String keyword = request.getParameter("keyword");

// InquirySearchVO 설정
InquirySearchVO isVO = new InquirySearchVO();
isVO.setUserId(sessionId);
isVO.setKeyword(keyword);

// 문의사항 목록 조회
UserInquiryDAO uiDAO = UserInquiryDAO.getInstance();
List<InquiryVO> inquiryList = uiDAO.selectUserAllInquiry(isVO);

// pageContext에 저장
pageContext.setAttribute("inquiryList", inquiryList);
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
body {
	font-family: Arial, sans-serif;
	margin: 20px;
}

h2 {
	margin-bottom: 20px;
	text-align: center;
}

.logo {
	text-align: center;
	margin-bottom: 20px;
}

.logo img {
	max-width: 200px;
}

.search_bar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
}

.search_bar input {
	width: 50%; /* 검색바 길이 증가 */
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.search_bar button {
	padding: 10px 15px;
	background-color: #9E9E9E; /* 회색으로 변경 */
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	margin-left: 5px;
}

.search_bar button:hover {
	background-color: #7E7E7E; /* 호버 시 더 어두운 회색 */
}

.qa-table {
	width: 100%;
	border-collapse: collapse;
}

.qa-table th, .qa-table td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: center;
}

.qa-table th {
	background-color: #f2f2f2;
}

.qa-item {
	cursor: pointer;
}

.qa-content {
	display: none; /* 초기 상태는 숨김 */
	background-color: #f9f9f9;
	padding: 10px;
	margin-top: 10px;
	border: 1px solid #ddd;
	border-radius: 5px;
}

.admin-reply {
	margin-top: 10px;
	border: 1px dashed #ccc;
	padding: 10px;
	border-radius: 5px;
}

.modal {
	display: none;
	position: fixed;
	z-index: 1;
	left: 0;
	top: 0;
	width: 100%;
	height: 100%;
	overflow: auto;
	background-color: rgba(0, 0, 0, 0.4);
	padding-top: 60px;
}

.modal-content {
	background-color: #fefefe;
	margin: 5% auto;
	padding: 20px;
	border: 1px solid #888;
	width: 50%;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.close {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
}

.close:hover, .close:focus {
	color: black;
	text-decoration: none;
	cursor: pointer;
}

table td {
	padding: 10px;
	vertical-align: middle;
}

.input-group {
	margin-bottom: 15px;
}

.input-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.input-group input, .input-group textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
}

.warning-text {
	padding: 10px;
	background-color: #f9f9f9;
	border: 1px solid #ddd;
	border-radius: 5px;
	font-size: 0.9em;
	color: #555;
	line-height: 1.6;
	margin-bottom: 20px;
}

.button-group {
	display: flex;
	justify-content: center;
	gap: 10px;
}

.button-group button {
	padding: 10px 20px;
	background-color: #4CAF50;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
}

.button-group button.cancel {
	background-color: #f44336;
}

.button-group button:hover {
	opacity: 0.9;
}

#inquiryText {
	height: 150px; /* 텍스트 에리어 크기 고정 */
	resize: none; /* 크기 조절 비활성화 */
}
</style>
<script type="text/javascript">
	$(function() {

	});//ready
</script>
</head>
<body>
	<header>
		<jsp:include page="/common/header.jsp" />
	</header>
	<br>
	<h2>Q&A 목록</h2>

	<div class="search_bar">
		<div style="display: flex; align-items: center;">
			<input type="text" id="search_Input" placeholder="제목을 검색하세요...">
			<button onclick="searchQuestions()">검색</button>
		</div>
		<button onclick="openModal()">문의하기</button>
	</div>

	<table class="qa-table">
		<thead>
			<tr>
				<th>번호</th>
				<th>문의 종류</th>
				<th style="width: 40%;">제목</th>
				<th>문의자</th>
				<th>등록일</th>
			</tr>
		</thead>
		<tbody id="qaList">
			<c:choose>
				<c:when test="${empty inquiryList}">
					<tr>
						<td colspan="5">등록된 문의사항이 없습니다.</td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach var="inquiry" items="${inquiryList}">
						<tr class="qa-item">
							<td>${inquiry.inquiry_id}</td>
							<td>${inquiry.category}</td>
							<td style="text-align: left;" onclick="toggleDetails(this)">${inquiry.title}</td>
							<td>${inquiry.userId}</td>
							<td>${inquiry.create_at}</td>
						</tr>
						<tr class="qa-content" style="display: none;">
							<td colspan="5" style="text-align: left;"></td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<!-- 문의하기 모달 -->
	<div id="myModal" class="modal">
		<div class="modal-content">
			<span class="close" onclick="closeModal()">&times;</span>
			<h2>문의하기</h2>

			<!-- 문의 폼 테이블 형식 -->
			<form id="qaForm" action="qa_process.jsp" method="post">
				<table>
					<tr>
						<td style="background-color: #f0f0f0;"><strong>문의 종류</strong></td>
						<td colspan="4"><label><input type="radio"
								name="inquiryType" value="상품" required> 상품</label> <label><input
								type="radio" name="inquiryType" value="배송"> 배송</label> <label><input
								type="radio" name="inquiryType" value="취소"> 취소</label></td>
					</tr>
					<tr>
						<td style="background-color: #f0f0f0;"><strong>아이디</strong></td>
						<td colspan="4"><input type="text" name="userId"
							value="<%=sessionId%>" readonly
							style="background-color: #f0f0f0; width: 80%;"></td>
					</tr>
					<tr>
						<td style="background-color: #f0f0f0;"><strong>제목</strong></td>
						<td colspan="4"><input type="text" name="title"
							placeholder="문의 제목" style="width: 80%;" required></td>
					</tr>
					<tr>
						<td style="background-color: #f0f0f0;"><strong>내용</strong></td>
						<td colspan="4"><textarea name="content"
								placeholder="문의 내용을 작성하세요..."
								style="width: 80%; height: 150px; resize: none;" required></textarea>
						</td>
					</tr>
					<tr>
						<td colspan="5" class="warning-text"><strong>문의 시
								유의해주세요!</strong><br> 회원간 직거래로 발생하는 피해에 대해 책임지지 않습니다.<br>
							주민등록번호, 연락처 등의 정보는 타인에게 노출될 경우 개인정보 도용의 위험이 있으니 주의해 주시기 바랍니다.<br>
							비방, 광고, 불건전한 내용의 글은 관리자에 의해 삭제될 수 있습니다.</td>
					</tr>
				</table>

				<div class="button-group">
					<button type="button" onclick="submitQA()">확인</button>
					<button type="button" class="cancel" onclick="closeModal()">취소</button>
				</div>
			</form>
		</div>
	</div>

	<script>
		function searchQuestions() {
			const keyword = document.getElementById("search_Input").value;
			location.href = "qa_list.jsp?keyword="
					+ encodeURIComponent(keyword);
		}

		document.getElementById("search_Input").addEventListener("keypress",
				function(event) {
					if (event.key === "Enter") {
						searchQuestions();
					}
				});

		window.onload = function() {
			const urlParams = new URLSearchParams(window.location.search);
			const keyword = urlParams.get('keyword');
			if (keyword) {
				document.getElementById("search_Input").value = decodeURIComponent(keyword);
			}
		}

		function submitQA() {
			// 필수 입력값 확인
			const type = document
					.querySelector('input[name="inquiryType"]:checked');
			const title = document.querySelector('input[name="title"]').value
					.trim();
			const content = document.querySelector('textarea[name="content"]').value
					.trim();

			if (!type) {
				alert('문의 종류를 선택해주세요.');
				return;
			}
			if (!title) {
				alert('제목을 입력해주세요.');
				return;
			}
			if (!content) {
				alert('내용을 입력해주세요.');
				return;
			}
			if (content.length < 10) {
				alert('내용은 최소 10자 이상 입력해주세요.');
				return;
			}

			// 폼 제출
			document.getElementById('qaForm').submit();
		}

		function closeModal() {
			document.getElementById("myModal").style.display = "none";
			document.getElementById("qaForm").reset(); // 폼 초기화
		}

		function openModal() {
			document.getElementById("myModal").style.display = "block";
		}

		function toggleDetails(cell) {
			const row = cell.parentElement;
			const contentRow = row.nextElementSibling;
			const inquiryId = row.querySelector('td:first-child').textContent;

			if (contentRow.style.display === 'none'
					|| contentRow.style.display === '') {
				$
						.ajax({
							type : "POST",
							url : "get_inquiry_content.jsp",
							dataType : "json",
							data : {
								inquiryId : inquiryId
							},
							success : function(response) {

								const content = response.content || '내용이 없습니다.';
								const answer = response.answer || '답변이 없습니다.';

								const td = contentRow.querySelector('td');

								// 내용 div
								const contentDiv = document
										.createElement('div');
								contentDiv.style.padding = '10px';
								contentDiv.style.backgroundColor = '#f8f9fa';
								contentDiv.style.borderRadius = '5px';
								contentDiv.innerHTML = '<strong style="display: block; margin-bottom: 10px;">내용:</strong>'
										+ '<div style="padding: 10px; background-color: white; border-radius: 5px;">'
										+ content + '</div>';

								// 답변 div
								const answerDiv = document.createElement('div');
								answerDiv.style.padding = '10px';
								answerDiv.style.backgroundColor = '#f8f9fa';
								answerDiv.style.borderRadius = '5px';
								answerDiv.innerHTML = '<strong style="display: block; margin-bottom: 10px;">답변:</strong>'
										+ '<div style="padding: 10px; background-color: white; border-radius: 5px;">'
										+ answer + '</div>';

								// 삭제 버튼 div
								const buttonDiv = document.createElement('div');
								buttonDiv.style.textAlign = 'right';
								buttonDiv.style.marginTop = '10px';

								const deleteButton = document
										.createElement('button');
								deleteButton.textContent = '삭제';
								deleteButton.style.padding = '5px 10px';
								deleteButton.style.backgroundColor = '#dc3545';
								deleteButton.style.color = 'white';
								deleteButton.style.border = 'none';
								deleteButton.style.borderRadius = '3px';
								deleteButton.style.cursor = 'pointer';
								deleteButton.onclick = function() {
									if (confirm('정말 삭제하시겠습니까?')) {
										location.href = 'delete_inquiry.jsp?inquiryId='
												+ inquiryId;
									}
								};

								buttonDiv.appendChild(deleteButton);

								td.innerHTML = '';
								td.appendChild(contentDiv);
								td.appendChild(answerDiv);
								td.appendChild(buttonDiv);

								contentRow.style.display = 'table-row';
							},
							error : function(xhr) {
								console.error("Error:", xhr);
								alert("내용을 가져오는데 실패했습니다.");
							}
						});
			} else {
				contentRow.style.display = 'none';
			}
		}
	</script>
</body>
</html>