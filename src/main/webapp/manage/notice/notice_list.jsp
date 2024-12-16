<%@page import="manage.notice.NoticeVO"%>
<%@page import="manage.notice.MangeNoticeDAO"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/common/jsp/admin_session_chk.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>공지사항 리스트 페이지</title>
<link rel="stylesheet"
	href="http://localhost/proejct1/common/css/admin.css">
<link rel="stylesheet"
	href="http://localhost/proejct1/common/css/main_Sidbar.css">
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_20240911.css">

<!-- Bootstrap CDN -->

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
<body>
	<!-- 헤더와 사이드바 임포트-->
	<c:import url="../../common/jsp/sidebar2.jsp" />

	<!-- 메인 콘텐츠 영역 -->
	<div class="main-content">
		<div class="content-box">
			<div class="notice_title">공지사항 리스트</div>

			<div class="notice_list">
				<jsp:useBean id="nVO" class="manage.notice.NoticeVO" scope="page" />
				<jsp:useBean id="sVO" class="manage.notice.SearchVO" scope="page" />
				<%
				MangeNoticeDAO mnDAO = MangeNoticeDAO.getInstance();
				int pageSize = 10; // 한 페이지당 게시물 수
				String pageParam = request.getParameter("page");
				int currentPage = (pageParam != null) ? Integer.parseInt(pageParam) : 1; // 기본 페이지 1
				int totalCount = mnDAO.selectTotalCount(sVO);
				int totalPages = (int) Math.ceil((double) totalCount / pageSize); // 전체 페이지 수 계산
				int startRow = (currentPage - 1) * pageSize; // 시작 행 번호
				List<NoticeVO> listnotice = mnDAO.selectAllNotice(startRow, pageSize); // 페이지별 공지사항 조회
				request.setAttribute("totalCount", totalCount);
				request.setAttribute("totalPages", totalPages);
				request.setAttribute("currentPage", currentPage);

				request.setAttribute("currentPage", currentPage);
				%>
				<span style="text-align: left; margin-left: 10px">공지사항 목록(총 <%=totalCount%>개)
				</span>
				<table class="table table-hover" style="text-align: center">
					<thead>
						<tr>
							<th><input type="checkbox" id="selectAll"></th>
							<th>번호</th>
							<th>카테고리</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성 일시</th>
						</tr>
					</thead>
					<tbody class="table-group-divider">
						<%
						if (listnotice != null && !listnotice.isEmpty()) {
							for (NoticeVO tempVO : listnotice) {
						%>
						<tr>
							<td><input type="checkbox" class="selectItem"
								value="<%=tempVO.getNotice_id()%>"></td>
							<td><%=tempVO.getNotice_id()%></td>
							<td><%=tempVO.getCategory_id()%></td>
							<%
							 int noticeId = tempVO.getNotice_id();
							 %>
							<td><a href="notice_update.jsp?noticeId=<%= noticeId %>"><%=tempVO.getTitle()%></a> 
							 </td>
							<td><%=tempVO.getAdmin_Id()%></td>
							<td><%=tempVO.getCreated_at()%></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>
				</table>
			</div>
			<div class="button-group" style="text-align: right;">
				<button class="btn btn-success" id="createBtn"
					onclick="location.href='notice_add.jsp'">공지사항 등록</button>
				<button class="btn btn-danger" id="deleteBtn">선택 삭제</button>
			</div>
			<script>
				$(function() {
					// "모든 항목 선택" 체크박스 클릭 시 모든 체크박스 선택/해제
					$('#selectAll').change(
							function() {
								$('.selectItem').prop('checked',
										$(this).prop('checked'));
							});

					// "선택 삭제" 버튼 클릭 시
					$('#deleteBtn').click(function() {
					    var selectedIds = [];

					    // 체크된 공지사항 ID 수집
					    $('.selectItem:checked').each(function() {
					        selectedIds.push($(this).val());
					    });

					    if (selectedIds.length === 0) {
					        alert('삭제할 공지사항을 선택해 주세요.');
					        return;
					    }

					    // Ajax를 사용하여 삭제 요청
					    $.ajax({
					        url: 'notice_delete.jsp',
					        type: 'POST',
					        data: {
					            ids: selectedIds.join(',')  // 배열을 쉼표로 구분된 문자열로 변환
					        },
					        dataType: 'json',
					        success: function(response) {
					            console.log('Response:', response);  // 응답 확인용
					            if (response.success) {
					                alert('선택한 공지사항이 삭제되었습니다.');
					                location.reload();
					            } else {
					                alert('삭제에 실패했습니다. 다시 시도해주세요.');
					            }
					        },
					        error: function(xhr, status, error) {
					            console.error('Error:', xhr.responseText);
					            alert('서버 오류로 삭제를 처리할 수 없습니다.');
					        }
					    });
					});
				});
			</script>
			<style>
.page-nation {
	display: flex;
	justify-content: center;
}
</style>
			<div class="page-nation">
				<ul class="pagination">
					<li class="page-item <%=(currentPage == 1) ? "disabled" : ""%>">
						<a class="page-link"
						href="notice_list.jsp?page=<%=currentPage - 1%>">이전</a>
					</li>
					<%
					for (int i = 1; i <= totalPages; i++) {
					%>
					<li class="page-item <%=(i == currentPage) ? "active" : ""%>">
						<a class="page-link" href="notice_list.jsp?page=<%=i%>"><%=i%></a>
					</li>
					<%
					}
					%>
					<li
						class="page-item <%=(currentPage == totalPages) ? "disabled" : ""%>">
						<a class="page-link"
						href="notice_list.jsp?page=<%=currentPage + 1%>">다음</a>
					</li>
				</ul>
			</div>

		</div>
	</div>
</body>
</html>
