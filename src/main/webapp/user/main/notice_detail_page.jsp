<%@page import="manage.notice.NoticeVO"%>
<%@page import="user.dao.UserNoticeDAO"%>
<%@page import="java.sql.SQLException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="공지사항 페이지"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
// 캐시 제어 헤더 추가
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);
%>
<%
String tempNum = request.getParameter("notice_id");
int noticeId = 0;

try {
	noticeId = Integer.parseInt(tempNum);
} catch (NumberFormatException nfe) {
	response.sendRedirect("notice.jsp");
	return;
} //end catch

UserNoticeDAO unDAO = UserNoticeDAO.getInstance();

NoticeVO nVO = null;

try {
	nVO = unDAO.selectOneNotice(noticeId);
	if (nVO != null) {
		unDAO.updateHits(nVO);//조회수 업데이트
		nVO.setHits(nVO.getHits() + 1);
	} else {
		response.sendRedirect("notice.jsp");
		return;
	} //end else
} catch (SQLException se) {
	se.printStackTrace();
	return;
} //end catch

pageContext.setAttribute("nVO", nVO);
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
.navDiv {
	display: flex;
	margin: 20px 0;
	border-top: 2px solid #dddddd;
	border-bottom: 2px solid #dddddd;
	padding: 5px;
	padding-left: 50px;
}

.navDiv a {
	text-decoration: none;
	color: black;
	padding: 20px 15px;
	font-size: 14px;
	font-weight: bold;
}

.navDiv a:hover {
	background-color: #ddd;
}

.notice_content {
	margin: 20px auto;
	width: 90%;
}

.notice_list {
	border-bottom: 2px solid #333;
	padding-bottom: 15px;
	text-align: right;
}

.table_text {
	font-size: 12px;
	text-decoration: none;
	color: gray;
}

.notice_title {
	font-weight: bold;
	font-size: 20px;
	border-bottom: 1px solid #ccc;
	padding-top: 20px;
	padding-bottom: 20px;
}

#category {
	color: #ff0000;
	margin: 5px;
}

.date_view {
	font-weight: normal;
	font-size: 13px;
	color: #aaa;
	margin: 7px;
}

.content_n {
	border-bottom: 1px solid #ccc;
	min-height: 300px;
	margin-bottom: -50px;
}
</style>
<script type="text/javascript">
	$(function() {

	});//ready
</script>
</head>
<body>
	<jsp:include page="/common/header.jsp" />
	<div class="notice_content">

		<div class="notice_list">
			<a href="notice.jsp" class="table_text">전체 공지사항 보기</a>
		</div>
		<div class="notice_title">
			<span id="category">[<c:out value="${nVO.category}" />]
			</span>
			<c:out value="${nVO.title}" />
			<div class="date_view">
				<span class="input_date"><c:out value="${nVO.createdAt}" /></span>
				조회수 <span class="notice_view"><c:out value="${nVO.hits}" /></span>
			</div>
		</div>

		<div class="content_n">
			<c:out value="${nVO.content}" />
		</div>

		<footer>
			<jsp:include page="/common/footer.jsp" />
		</footer>

	</div>
</body>
</html>