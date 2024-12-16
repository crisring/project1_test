<%@page import="user.dao.UserReviewDAO"%>
<%@page import="manage.review.ReviewVO"%>
<%@page import="user.dao.OrderDAO"%>
<%@page import="java.io.File"%>
<%@page import="java.io.IOException"%>
<%@page import="java.sql.SQLException"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/common/session_chk.jsp"%>
<%@ include file="/common/post_chk.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 등록 처리</title>
<script type="text/javascript">
	function showAlert(message, isSuccess) {
		alert(message);
		if (isSuccess) {
			location.href = "http://localhost/proejct1/index.jsp";
		} else {
			history.back();
		}
	}
</script>
</head>
<body>
	<%
	request.setCharacterEncoding("UTF-8");

	// 1. 업로드 저장 디렉토리 설정
	File saveDir = new File("C:/web_home/team_prj1/common/review_images");
	if (!saveDir.exists()) {
		saveDir.mkdirs();
	}

	// 2. 업로드 파일 최대 크기 설정 (5MB)
	int maxSize = 5 * 1024 * 1024;

	try {
		// 3. MultipartRequest 객체 생성 (파일 업로드 수행)
		MultipartRequest mr = new MultipartRequest(request, saveDir.getAbsolutePath(), maxSize, "UTF-8",
		new DefaultFileRenamePolicy());

		// 4. 파라미터 받기
		String orderId = mr.getParameter("orderId");
		String rating = mr.getParameter("rating");
		String reviewContent = mr.getParameter("reviewContent");
		String userId = sessionId;

		// 5. 업로드된 파일 정보
		String originalFileName = mr.getOriginalFileName("reviewImage"); // 원본 파일명
		String savedFileName = mr.getFilesystemName("reviewImage"); // 저장된 파일명

		// 6. product_id 조회
		OrderDAO oDAO = new OrderDAO();
		int productId = oDAO.selectProductId(orderId);

		// 7. ReviewVO에 데이터 설정
		ReviewVO rVO = new ReviewVO();
		rVO.setUserId(userId);
		rVO.setPrdNum(productId);
		rVO.setContent(reviewContent);
		rVO.setRating(Integer.parseInt(rating));
		if (savedFileName != null) {
			rVO.setReviewImg(savedFileName); // 저장된 파일명 설정
		}

		// 8. DB 저장 시도
		UserReviewDAO urDAO = UserReviewDAO.getInstance();
		int result = urDAO.insertReview(rVO);

		if (result > 0) {
			// 세션 데이터 삭제
			session.removeAttribute("reviewProductName");
			session.removeAttribute("reviewImgName");
			session.removeAttribute("reviewOrderId");
		} else {
			// 실패 시 업로드된 파일 삭제
			if (savedFileName != null) {
		File uploadedFile = new File(saveDir, savedFileName);
		if (uploadedFile.exists()) {
			uploadedFile.delete();
		}
			}
	%>
	<script>
		showAlert("리뷰 등록에 실패했습니다. 다시 시도해주세요.", false);
	</script>
	<%
	}
	} catch (Exception e) {
	e.printStackTrace();
	%>
	<script>
		showAlert("리뷰 등록 중 오류가 발생했습니다.", false);
	</script>
	<%
}
%>
</body>
</html>