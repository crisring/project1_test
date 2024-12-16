<%@page import="manage.review.ReviewUtil"%>
<%@page import="manage.review.ReviewVO"%>
<%@page import="manage.review.AdminReviewDAO"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ include file="../../common/jsp/admin_session_chk.jsp"%>

<jsp:useBean id="sVO" class="manage.review.ReviewSearchVO" />
<jsp:setProperty name="sVO" property="*" />
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>리뷰관리 페이지</title>

<!-- Bootstrap CDN -->
<link rel="stylesheet"
	href="http://localhost/proejct1/common/css/main_Sidbar.css">

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
/* 메인 콘텐츠 */
#main-content {
	margin-left: 250px;
	padding: 85px 20px;
	background-color: #e9ecef;
	min-height: 100vh;
}

.search-form {
	background-color: white;
	padding: 20px;
	border-radius: 5px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}

.form {
	background-color: white;
	padding: 20px;
	border-radius: 5px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	margin-bottom: 20px;
}

.form-group {
	display: flex;
	align-items: center;
	margin-bottom: 15px;
	margin-top: 20px;
}

.form-group label {
	margin-right: 10px;
	width: 100px;
	font-weight: bold;
}

.form-group input, .form-group select, .form-group button {
	width: auto;
	margin-right: 15px;
}

.search-form {
	padding: 10px 20px;
	border-radius: 5px;
	cursor: pointer;
	margin-right: 10px;
}

/* 스타일링 간소화 */
.form-control, .form-select {
	width: 150px;
	display: inline-block;
}

.date-range {
	width: 250px;
	display: inline-block;
}

.btn {
	margin-right: 10px;
}

table {
	border: 3px solid #000;
}

h4 {
	color: #000;
}
</style>

</head>
<script type="text/javascript">
    $(document).ready(function () {
        defaultDate();
        dateRadio();
        setSearchBtn();
        setupDateInputs();
        setupResetButton();
    });

    // 페이지 로드시 날짜 기본 설정
function defaultDate() {
    const today = new Date();
    const formattedToday = formatDate(today);

    const selectedDateOption = $('input[name="date"]:checked').val();

    if (selectedDateOption === 'all') {
        $('#startDate').val('');
        $('#endDate').val('');
    } else {
        // startDate와 endDate 값이 있을 경우 해당 값으로 설정
        <% if (sVO.getStartDate() != null && !"".equals(sVO.getStartDate())) { %>
            $('#startDate').val('<%= sVO.getStartDate() %>');
        <% } else { %>
            $('#startDate').val(formattedToday);
        <% } %>
        <% if (sVO.getEndDate() != null && !"".equals(sVO.getEndDate())) { %>
            $('#endDate').val('<%= sVO.getEndDate() %>');
        <% } else { %>
            $('#endDate').val(formattedToday);
        <% } %>
    }//end else
}//defaultDate
    // 날짜 포맷팅 함수 (yyyy-mm-dd 형식으로 변환)
    function formatDate(date) {
        return date.toISOString().split('T')[0];
    }//format date

 // 라디오 버튼 설정 함수
    function dateRadio() {
        $('input[name="date"]').change(function () {
            const selected = $(this).val();
            switch (selected) {
                case 'all':
                    $('#startDate').val('');
                    $('#endDate').val('');
                    break;
                case 'today':
                    setDateRange(0);
                    break;
                case 'last3days':
                    setDateRange(2); // 오늘 포함 3일 전
                    break;
                case 'lastweek':
                    setDateRange(6); // 오늘 포함 7일 전
                    break;
                case 'lastmonth':
                    setDateRange(29); // 오늘 포함 30일 전
                    break;
            }//switch
        });
    }
    // 날짜 범위 설정 함수
    function setDateRange(daysAgo) {
        const endDate = new Date();
        const startDate = new Date();
        startDate.setDate(startDate.getDate() - daysAgo);

        $('#startDate').val(formatDate(startDate));
        $('#endDate').val(formatDate(endDate));
    }

    // date input 필드 설정 함수
    function setupDateInputs() {
        $('#startDate, #endDate').on('change', function() {
            // date input이 수동으로 변경되면 라디오 버튼 선택 해제
            $('input[name="date"]').prop('checked', false);
        });
    }

    // 검색 버튼 클릭 시 폼 제출
    function setSearchBtn() {
        $('#searchBtn').click(function () {
            const startDate = $('#startDate').val();
            const endDate = $('#endDate').val();

            if (startDate && endDate && startDate > endDate) {
                alert("시작일은 종료일보다 늦을 수 없습니다.");
                return;
            }

            // currentPage를 1로 설정
            $('#currentPage').val(1);

            $('#searchFrm').submit();
        });
    }

    // Reset 버튼 설정 함수
function setupResetButton() {
    $('input[type="reset"]').click(function(e) {
        e.preventDefault(); // 기본 reset 동작 방지

        // 폼 초기화
        $('#filter').val('all');
        $('#keyword').val('');
        $('#field').val('0');

        // 날짜 초기화 (startDate와 endDate를 빈 문자열로 설정)
        $('#startDate').val('');
        $('#endDate').val('');

        // 라디오 버튼 '전체' 선택
        $('#btnradio0').prop('checked', true);
        $('input[name="date"]').not('#btnradio0').prop('checked', false);

        // currentPage 초기화
        $('#currentPage').val(1);

        // 폼 제출하여 전체 목록 조회
        $('#searchFrm').submit();
    });
}
    // 상세보기 팝업창 함수
    function openPopup(reviewId) {
        var left = window.screenX + 300;
        var top = window.screenY + 200;
        var width = 700;
        var height = 700;
        window.open("admin_review_popup.jsp?reviewId=" + reviewId, "admin_review_popup.jsp", 
            "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top
        );
    }//openPopup

    </script>
</head>


<body>

<!-- 서버 측 코드 시작 -->
<%
    // 게시판 리스트 구현
        
    // 1. 총 레코드 수 구하기
    int totalCount = 0; // 총 레코드 수  
    
    AdminReviewDAO arDAO = AdminReviewDAO.getInstance();
    try {
        totalCount = arDAO.selectTotalCount(sVO);
    } catch (SQLException se) {
        se.printStackTrace();
    }
    // 2. 한 화면에 보여줄 레코드의 수
    int pageScale = 10;
    
    // 3. 총 페이지 수
    int totalPage = (int)Math.ceil((double)totalCount / pageScale);
    
    // 4. 검색의 시작번호를 구하기 (pagination의 번호) [1][2][3]
    String paramPage = request.getParameter("currentPage");

    int currentPage = 1;    
    if (paramPage != null) {
        try {
            currentPage = Integer.parseInt(paramPage);
        } catch (NumberFormatException nfe) {
        }
    }
    
    int startNum = currentPage * pageScale - pageScale + 1; // 시작번호
    // 5. 끝번호 
    int endNum = startNum + pageScale - 1; // 끝 번호
    
    sVO.setCurrentPage(currentPage);
    sVO.setStartNum(startNum);
    sVO.setEndNum(endNum);
    sVO.setTotalPage(totalPage);
    sVO.setTotalCount(totalCount);
    
    List<ReviewVO> listBoard = null;
    try {
        listBoard = arDAO.selectAllReview(sVO); // 시작번호, 끝 번호를 사용한 게시글 조회
        
        String tempTitle = "";
        for (ReviewVO tempVO : listBoard) {
            tempTitle = tempVO.getContent();
            if (tempTitle.length() > 30) {
                tempVO.setContent(tempTitle.substring(0, 29) + "...");
            }
        }
        
    } catch (SQLException se) {
        se.printStackTrace();
    }
    
    pageContext.setAttribute("totalCount", totalCount);
    pageContext.setAttribute("pageScale", pageScale);
    pageContext.setAttribute("totalPage", totalPage);
    pageContext.setAttribute("currentPage", currentPage);
    pageContext.setAttribute("listBoard", listBoard);
 %>



 <!-- 헤더와 사이드바 임포트-->
        <c:import url="../../common/jsp/sidebar2.jsp"/>
   <!-- 메인 콘텐츠 영역 -->
   <div id="main-content">
      <!-- 헤더 섹션 -->
      <div class="form" >
         <h4>리뷰 관리 </h4>
      </div>

      <!-- 새로운 검색 필터 폼 -->
     <!-- 검색 필터 폼 -->
        <div class="form">
            <form method="GET" action="admin_review.jsp" name="searchFrm" id="searchFrm" >
                <!-- 현재 페이지를 관리하기 위한 숨겨진 필드 -->
                <input type="hidden" id="currentPage" name="currentPage" value="1">
                
                <div class="form-group">
                    <label for="filedr">유형</label>
                    <select id="filed" name="field" class="form-select">
                        <option value="0" <c:if test="${sVO.field eq '0'}">selected</c:if>>전체</option>
                        <option value="1" <c:if test="${sVO.field eq '1'}">selected</c:if>>상품명</option>
                        <option value="2" <c:if test="${sVO.field eq '2'}">selected</c:if>>작성자</option>
                        <option value="3" <c:if test="${sVO.field eq '3'}">selected</c:if>>내용</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="date-range">리뷰작성일</label>
                    <div class="btn-group" role="group">
                        <!-- 오늘 -->
                          <!-- 전체 -->
                  <input type="radio" class="btn-check" name="date" id="btnradio0" value="all" autocomplete="off"
                     <c:if test="${param.date eq 'all' || empty param.date}">checked</c:if>>
                    <label class="btn btn-outline-secondary btn-sm" for="btnradio0" style="margin-right: 0px;width: 70px">전체</label>
                             
                        <input type="radio" class="btn-check" name="date" id="btnradio1" value="today" autocomplete="off"
                        <c:if test="${param.date eq 'today'}">checked</c:if>>
                    <label class="btn btn-outline-secondary btn-sm" for="btnradio1" style="margin-right: 0px;width: 70px">1일</label>
                        <!-- 지난 3일 -->
                        <input type="radio" class="btn-check" name="date" id="btnradio2" value="last3days" autocomplete="off"
                            <c:if test="${param.date eq 'last3days'}">checked</c:if>>
                        <label class="btn btn-outline-secondary btn-sm" for="btnradio2" style="margin-right: 0px;width: 70px">3일</label>

                        <!-- 지난 1주일 -->
                        <input type="radio" class="btn-check" name="date" id="btnradio3" value="lastweek" autocomplete="off"
                            <c:if test="${param.date eq 'lastweek'}">checked</c:if>>
                        <label class="btn btn-outline-secondary btn-sm" for="btnradio3" style="margin-right: 0px;width: 70px">1주일</label>

                        <!-- 지난 1달 -->
                        <input type="radio" class="btn-check" name="date" id="btnradio4" value="lastmonth" autocomplete="off"
                            <c:if test="${param.date eq 'lastmonth'}">checked</c:if>>
                        <label class="btn btn-outline-secondary btn-sm" for="btnradio4" style="margin-right: 0px;width: 70px">1달</label>
                    </div>
                        <input type="date" id="startDate" name="startDate" class="form-control date" value="${sVO.startDate}" style="margin-left: 10px"> ~
                   <input type="date" id="endDate" name="endDate" class="form-control date" value="${sVO.endDate}" style="margin-left: 10px">
                </div>

                <div class="form-group">
                    <label for="keyword">검색</label>
                    <input type="text" name="keyword" id="keyword" style="width: 250px" value="${sVO.keyword}" class="form-control"  placeholder="검색할 키워드를 입력하세요" />
                </div>

                <div class="form-group" style="justify-content: center; margin-top: 50px;">
                    <input type="button" id="searchBtn" class="btn btn-success" value="검색">
                    <input type="reset" class="btn btn-light" value="옵션 초기화">
                </div>
            </form>
        </div>

      
      <!-- 리뷰검색 결과 출력 div -->
     <div class="form">
                <h5  class="form-group" style="border-bottom: 1px solid  #EEF0F4"> 검색결과: <c:out value="${sVO.totalCount }"/> 건</h5>

   <table  class="table table-striped table-hover">
   <c:if test="${empty listBoard }">
   <tr> <td colspan="6" style="text-align: center;"> <strong>해당 조건에 맞는 검색 결과가 없습니다</strong>  </td></tr>
   </c:if>
      <thead> 
      <tr>
         <td>번호</td>
         <td>상품명</td>
         <td>내용</td>
         <td>작성자ID</td>
         <td>등록일</td>
         <td>평점  <img src="http://localhost/proejct1/common/img/img7.png"></td>
      </tr>
      </thead>
      <tbody>
    <c:forEach var="rVO" items="${listBoard}" varStatus="i">
    <tr>
          <td><c:out value="${(totalCount - ((currentPage-1) * pageScale)) - i.index}"/>
</td>
          
          
           <td><a href="#" onclick="openPopup('${rVO.reviewId}')"> <c:out value="${rVO.productName}"/></a></td>
         <td>  <c:out value="${rVO.content }"></c:out>  </td>
         <td>  <c:out value="${rVO.userId }"/>  </td>
         <td><fmt:formatDate value="${rVO.createAt}" pattern="yyyy-MM-dd"/></td>
         <td>  <c:out value="${rVO.rating }"/>점</td>
    </tr>
    </c:forEach>      
      
      </tbody>
   </table>
           
   <p style="color: E9ECEF;font-size: 12px">상품명 클릭시 리뷰 상세보기 페이지가 나타납니다.</p>
   
       <!-- 페이지네이션 -->
            <div id="pagination" style="text-align: center">
                <% sVO.setUrl("admin_review.jsp"); %>
                <%= new ReviewUtil().pagination(sVO) %>
            </div>
   
   
   
   
</div>

      
   </div>
</body>

</html>
