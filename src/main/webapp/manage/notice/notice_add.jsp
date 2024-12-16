<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../common/jsp/admin_session_chk.jsp"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>공지사항 등록 페이지</title>
<link rel="stylesheet" href="admin.css">
<jsp:useBean id="nVO" class="manage.notice.NoticeVO" />
<jsp:useBean id="ncVO" class="manage.notice.NoticeCategoryVO" />
<jsp:setProperty property="*" name="nVO" />
<jsp:setProperty property="*" name="ncVO" />


<!-- Bootstrap CDN -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="http://localhost/proejct1/common/css/main_20240911.css">
<link rel="stylesheet"
	href="http://localhost/proejct1/common/css/main_Sidbar.css">

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
	<!-- 헤더와 사이드바 임포트-->
	<c:import url="../../common/jsp/sidebar2.jsp" />


	<!-- 메인 콘텐츠 영역 -->
  <div class="main-content">
    <div class="content-box">
      <div class="notice_title">공지사항 등록</div>
      <div class="notice_list">
        <form id="noticeForm">
          <table class="table notice-form">
            <tr>
              <td class="label"><span class="required">*</span>분류</td>
              <td><select name="category" id="category" style="width: 20%" required>
                <option value="N/A">선택하세요</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
              </select></td>
            </tr>
            <tr>
              <td class="label"><span class="required">*</span>제목</td>
              <td><input type="text" name="title" id="title" required></td>
            </tr>
            <tr>
              <td class="label"><span class="required">*</span>공지사항 상세</td>
              <td><textarea name="content" id="content" rows="10" placeholder="공지사항 내용을 작성해주세요" style="resize:none;" required></textarea></td>
            </tr>
          </table>
          <div class="button-group">
            <button class="btn btn-success" type="button" id="addBtn">등록</button>
            <button class="btn btn-warning" type="button" onclick="location.href='notice_list.jsp'">취소</button>
          </div>
        </form>
      </div>
    </div>
  </div>

  <script>
    $(document).ready(function() {
        // 등록 버튼 클릭 시
        $('#addBtn').click(function() {
            var formData = {
                category: $('#category').val(),
                title: $('#title').val(),
                content: $('#content').val()
            };

            // 폼 데이터 검증 (간단한 예)
            if (formData.category === 'N/A' || formData.title === '' || formData.content === '') {
                alert('모든 필드를 작성해주세요.');
                return;
            }

            // AJAX 요청
            $.ajax({
                url: 'notice_create.jsp',
                type: 'POST',
                data: formData,
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        alert('공지사항 등록에 성공하였습니다.');
                        window.location.href = 'notice_list.jsp';  // 등록 후 공지사항 목록 페이지로 리다이렉트
                    } else {
                        alert('공지사항 등록에 실패하였습니다.');
                    }
                },
                error: function(xhr, status, error) {
                    console.error(xhr.status + ": " + xhr.responseText);
                    alert("서버 오류가 발생하였습니다. 다시 시도해주세요.");
                }
            });
        });
    });
  </script>
</body>
</html>