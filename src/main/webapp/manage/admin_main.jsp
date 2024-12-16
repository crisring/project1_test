<%@page import="manage.dashboard.SaleDataVO"%>
<%@page import="manage.dashboard.DeliveryStatusVO"%>
<%@page import="manage.dashboard.AdminDashBoardDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="관리자 페이지 메인 대시보드 화면"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/common/jsp/admin_session_chk.jsp"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 대시보드 페이지</title>


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
<!-- chart.js CDN  -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
/* 메인 콘텐츠 */
.main-content {
	margin-left: 250px;
	padding: 85px 20px;
	background-color: #e9ecef;
	min-height: 100vh;
	display: flex;
	gap: 20px;
	flex-wrap: wrap;
	height: 45%;
}

.contentTop {
	background-color: white;
	width: calc(50% - 10px);
	padding: 20px;
}

.contentBottom {
	background-color: white;
	width: calc(50% - 10px);
	padding: 20px;
	height: 55%
}

.innerBox {
	height: 150px;
	width: 50%;
	float: left;
	text-align: right;
	border-top: 0px solid #EEF0F4;
	border-right: 1px solid #EEF0F4;
	border-bottom: 1px solid #EEF0F4;
	border-left: 1px solid #EEF0F4;
}

h4 {
	color: #000;
}
</style>

<%
// DAO 인스턴스 생성
AdminDashBoardDAO adbDAO = AdminDashBoardDAO.getInstance();

// 데이터 조회
int inquiryCnt = 0;
int newOrderCnt = 0;
int confirmedCnt = 0;
int totalMemberCnt = 0;
int newMemberCnt = 0;
int cancelCnt = 0;
List<DeliveryStatusVO> list = new ArrayList<>();

try {
	// 미답변 문의 가져오기
	inquiryCnt = adbDAO.selectinquiryCnt();

	// 신규주문 가져오기
	newOrderCnt = adbDAO.selectCountNewOrders();

	// 구매확정 가져오기
	confirmedCnt = adbDAO.selectCountConfirmed();

	// 기존회원 가져오기
	totalMemberCnt = adbDAO.selectTotalMemberCnt();

	// 신규회원 가져오기
	newMemberCnt = adbDAO.selectNewMemberCnt();

	// 주문취소 수 가져오기
	cancelCnt = adbDAO.selectOrderCancel();

	// 배송상태 가져오기
	list = adbDAO.selectDeliveryStatus();

	// 일일 매출 데이터 조회 및 JSON 변환
	List<SaleDataVO> dailySaleList = adbDAO.selectSumDailySales();

	JSONArray datesJsonArray = new JSONArray();
	JSONArray salesJsonArray = new JSONArray();

	if (dailySaleList != null) {
		for (SaleDataVO sd : dailySaleList) {
	datesJsonArray.add(sd.getDate());
	salesJsonArray.add(sd.getAmount());
		}
	}

	String datesJson = datesJsonArray.toJSONString();
	String salesJson = salesJsonArray.toJSONString();

	// pageContext에 속성 설정
	pageContext.setAttribute("datesJson", datesJson);
	pageContext.setAttribute("salesJson", salesJson);

} catch (SQLException se) {
	se.printStackTrace();
}
%>

<script>
    // 페이지가 로드되면 실행될 작업
    $(function () {
        dayChart(); // 차트를 생성하는 함수를 호출
    });

    function dayChart() {
        // #dayChart라는 id를 가진 <canvas> 요소를 선택하고, 2D 그래픽 컨텍스트를 가져옴
        let ctx = document.querySelector('#dayChart').getContext('2d');

        // EL을 사용하여 페이지 컨텍스트 속성에서 JSON 데이터를 가져옴
        let labels = ${datesJson};
        let data = ${salesJson};

        console.log("Labels:", labels);
        console.log("Data:", data);

        // 데이터가 유효한지 확인
        if (!labels || !data) {
            console.error("차트 데이터를 불러오는 데 실패했습니다.");
            return;
        }

        // Chart 객체 생성: 이 객체가 실제로 차트를 그리며, 다양한 차트 유형과 데이터를 지원함
        new Chart(ctx, {
            type: 'bar', // 차트의 타입을 설정 ('bar': 막대 차트, 'line': 선 차트, 'pie': 파이 차트 등)

            // 차트에 사용할 데이터 설정
            data: {
                labels: labels, // 서버에서 전달된 날짜 데이터 (JSON 배열)
                datasets: [{
                    label: '일일 매출', // 데이터셋에 대한 설명 (차트의 범례에 표시됨)
                    data: data, // 서버에서 전달된 매출 데이터 (JSON 배열)
                    backgroundColor: 'rgba(75, 192, 192, 0.2)', // 배경색
                    borderColor: 'rgba(75, 192, 192, 1)', // 선 색상
                    borderWidth: 1
                }]
            },

            // 차트의 옵션을 설정하는 부분 (여기서는 축, 스타일 등을 설정)
            options: {
                scales: {
                    // Y축의 설정을 정의
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: '매출액 (원)'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '날짜'
                        }
                    }
                },
                plugins: {
                    title: {
                        display: true,
                        text: '최근 1주일간 일일 매출액'
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false,
                    },
                    hover: {
                        mode: 'nearest',
                        intersect: true
                    }
                }
            }
        }); // chart
    } // dayChart
</script>


</head>

<body>

	<!-- 헤더와 사이드바 임포트-->
	<c:import url="/common/jsp/sidebar2.jsp" />




	<!-- 메인 콘텐츠 영역 -->
	<div class="main-content">
		<!-- 주문/배송영역 -->
		<div class="contentTop">
			<h4 style="border-bottom: 1px solid #EEF0F4">주문/배송</h4>
			<div class="innerBox">
				<img src="http://localhost/proejct1/common/img/img1.png"
					style="float: left;">
				<p>
					신규주문
					<%=newOrderCnt%>
					건
				</p>
			</div>
			<div class="innerBox">
				<img src="http://localhost/proejct1/common/img/img2.png"
					style="float: left;">
				<p>배송 상태</p>

				<%
				for (DeliveryStatusVO statusVO : list) {
				%>
				<p>
					<%=statusVO.getStatus()%>:
					<%=statusVO.getCount()%>건
				</p>
				<%
				}
				%>
			</div>
		</div>

		<!-- 문의/정산영역 -->
		<div class="contentTop">
			<h4 style="border-bottom: 1px solid #EEF0F4">고객요청/구매확정</h4>
			<div class="innerBox">
				<img src="http://localhost/proejct1/common/img/img3.png"
					style="float: left;">
				<p>
					취소요청
					<%=cancelCnt%>
					건
				</p>
			</div>
			<div class="innerBox">
				<img src="http://localhost/proejct1/common/img/img4.png"
					style="float: left;">
				<p>
					구매확정
					<%=confirmedCnt%>
					건
				</p>
			</div>
		</div>

		<!-- 일일 매출 차트 영역 -->
		<div class="contentBottom">
			<canvas id="dayChart"></canvas>
			<p style="font-size: 10px; text-align: right">단위:(원)</p>
		</div>

		<!-- 회원현황/신규문의 영역 -->
		<div class="contentBottom">
			<h4 style="border-bottom: 1px solid #EEF0F4">회원현황/신규문의</h4>
			<div class="innerBox">
				<img src="http://localhost/proejct1/common/img/img5.png"
					style="float: left;">
				<p>
					총회원
					<%=totalMemberCnt%>
					명
				</p>
				<p>
					신규회원
					<%=newMemberCnt%>
					명
				</p>
			</div>
			<div class="innerBox">
				<img src="http://localhost/proejct1/common/img/img6.png"
					style="float: left;">
				<p>
					미답변문의
					<%=inquiryCnt%>
					건
				</p>
			</div>
		</div>
	</div>

</body>

</html>
