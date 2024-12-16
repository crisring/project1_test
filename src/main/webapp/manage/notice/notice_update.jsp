<%@page import="manage.notice.NoticeVO"%>
<%@page import="manage.notice.MangeNoticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리 페이지</title>
<link rel="stylesheet"
	href="http://localhost/proejct1/common/css/admin.css">

<!-- Bootstrap CDN -->
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_20240911.css">
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_Sidbar.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

<style>
.notice_title {
	height: 10%;
	border: 1px solid #333;
	font-weight: bold;
	font-size: 30pt;
	border-radius: 20px;
	text-align: center;
}

.notice_list {
	height: 80%;
	margin-top: 20px;
	padding-top: 20px;
	border: 1px solid #333;
	border-radius: 20px;
}

.notice-form {
	width: 100%;
	border-collapse: separate;
	border-spacing: 0 15px;
}

.notice-form .label {
	width: 150px;
	text-align: left;
	padding-right: 20px;
	vertical-align: top;
}

.notice-form .required {
	color: red;
	margin-right: 5px;
}

.notice-form input, .notice-form select, .notice-form textarea {
	width: 100%;
}

.button-group {
	text-align: center;
}

.button-group .btn {
	width: 150px;
	height: 50px;
}
</style>
</head>
<body>

	<c:import url="../../common/jsp/sidebar2.jsp" />

	<!-- 메인 콘텐츠 영역 -->
	<div class="main-content">
		<div class="content-box">
			<div class="notice_title">공지사항 수정</div>
			<div class="notice_list">
				<%
				int noticeId = Integer.parseInt(request.getParameter("noticeId")); // 공지사항 ID를 파라미터로 받아옴
				MangeNoticeDAO mnDAO = MangeNoticeDAO.getInstance();
				NoticeVO nVO = mnDAO.selectOneNotice(noticeId);

				// 가져온 공지사항 데이터를 JSP에서 사용할 수 있도록 request 속성에 추가
				request.setAttribute("notice", nVO);
				%>
				<!-- noticeId를 hidden input으로 추가 -->
				<input type="hidden" id="noticeId" value="<%=noticeId%>">
				<table class="table notice-form">
					<tr>
						<td class="label"><span class="required">*</span>분류</td>
						<td>
							<!-- id를 categoryId로 수정 --> <select name="category"
							id="categoryId" style="width: 20%">
								<option value="N/A">선택하세요</option>
								<option value="1"
									<%=nVO.getCategory_id() == 1 ? "selected" : ""%>>배송</option>
								<option value="2"
									<%=nVO.getCategory_id() == 2 ? "selected" : ""%>>주문</option>
						</select>
						</td>
					</tr>
					<tr>
						<td class="label"><span class="required">*</span>제목</td>
						<td><input type="text" id="title" value="<%=nVO.getTitle()%>"></td>
					</tr>
					<tr>
						<td class="label"><span class="required">*</span>공지사항 상세</td>
						<td><textarea id="content" rows="10"
								placeholder="선택한 공지사항의 내용 출력" style="resize: none;"><%=nVO.getContent()%></textarea></td>
					</tr>
				</table>
				<div class="button-group">
					<button class="btn btn-success" id="updateBtn">수정</button>
					<button class="btn btn-warning" id="cancelBtn">취소</button>
				</div>
			</div>
		</div>
		<script>
		$(function () {
		    $('#updateBtn').click(function () {
		        // 유효성 검사
		        if (!$('#title').val()) {
		            alert("제목을 입력해 주세요.");
		            return;
		        }
		        if (!$('#content').val()) {
		            alert("내용을 입력해 주세요.");
		            return;
		        }
		        if ($('#categoryId').val() === "N/A") {
		            alert("카테고리를 선택해 주세요.");
		            return;
		        }

		        // 파라미터 설정
		        var param = {
		            noticeId: $('#noticeId').val(),    // hidden input에서 가져옴
		            title: $('#title').val(),
		            content: $('#content').val(),
		            category: $('#categoryId').val()    // select의 id를 categoryId로 수정
		        };

		        $.ajax({
		            url: "update_notice.jsp",
		            type: "post",
		            data: param,
		            dataType: "json",
		            error: function (xhr) {
		                console.log(xhr.status);
		                alert("공지사항이 정상적으로 수정되지 못하였습니다");
		            },
		            success: function (jsonObj) {
		                if (jsonObj.result) {
		                    if (!jsonObj.updateStatus) {
		                        alert("공지사항 수정에 실패하였습니다.");
		                    } else {
		                        alert("공지사항이 성공적으로 수정되었습니다.");
		                        location.href = "notice_list.jsp";
		                    }
		                } else {
		                    alert("요청이 실패했습니다. 서버 오류가 발생했습니다.");
		                }
		            }
		        });
		    });

		    // 취소 버튼 이벤트 핸들러를 ready 함수 안으로 이동
		    $('#cancelBtn').click(() => {
		        location.href = 'notice_list.jsp';
		    });
		}); // ready 함수 끝
</script>
	</div>
</body>
</html>