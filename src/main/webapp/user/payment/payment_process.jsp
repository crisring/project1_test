<%@page import="user.dao.PaymentDAO"%>
<%@page import="user.vo.PaymentVO"%>
<%@page import="user.dao.OrderDAO"%>
<%@page import="user.vo.OrderProductVO"%>
<%@page import="manage.saleslist.OrderVO"%>
<%@page import="user.vo.ShippingVO"%>
<%@page import="user.dao.ShippingDAO"%>
<%@page import="user.dao.UserCashDAO"%>
<%@page import="manage.productlist.ProductVO"%>
<%@page import="user.dao.UserProductDAO"%>
<%@ page contentType="application/json;charset=UTF-8" language="java"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="java.sql.Date"%>
<%@ include file="/common/session_chk.jsp"%>

<%
JSONObject jsonResponse = new JSONObject();

try {
	// 1. 파라미터 검증
	String productIdStr = request.getParameter("productId");
	String amountStr = request.getParameter("amount");
	String shippingIdStr = request.getParameter("shippingId");
	String paymentMethod = request.getParameter("paymentMethod");
	String useCashStr = request.getParameter("useCash");
	String useCashChecked = request.getParameter("useCashChecked"); // 체크박스 상태 추가

	if (productIdStr == null || amountStr == null || shippingIdStr == null || paymentMethod == null) {
		throw new Exception("필수 파라미터가 누락되었습니다.");
	}

	// 2. 파라미터 변환
	int productId = Integer.parseInt(productIdStr);
	int amount = Integer.parseInt(amountStr);
	int shippingId = Integer.parseInt(shippingIdStr);
	int useCash = useCashStr != null ? Integer.parseInt(useCashStr) : 0;
	boolean isUseCashChecked = "true".equals(useCashChecked); // 체크박스 상태 확인

	String userId = sessionId;

	// 3. 주문 가능 여부 검증
	UserProductDAO productDAO = new UserProductDAO();
	ProductVO product = productDAO.selectByProductId(productId);
	if (product == null) {
		throw new Exception("상품 정보가 없습니다.");
	}
	// 4. 네이버페이 포인트 사용 검증
	// 체크박스가 체크되어 있는데 포인트를 사용하지 않는 경우 체크
	if (isUseCashChecked && useCash <= 0) {
		throw new Exception("네이버페이 포인트 사용을 선택하셨지만, 사용할 포인트가 설정되지 않았습니다.");
	}
	// 체크박스가 체크되어 있지 않은데 포인트를 사용하려는 경우 체크
	if (!isUseCashChecked && useCash > 0) {
		throw new Exception("네이버페이 포인트 사용이 선택되지 않았습니다.");
	}
	if (isUseCashChecked && useCash > 0) {
		UserCashDAO cashDAO = new UserCashDAO();
		int currentCash = cashDAO.selectUserCash(userId);
		if (currentCash < useCash) {
	throw new Exception("사용 가능한 네이버페이 포인트가 부족합니다.");
		}
		if (useCash > amount) {
	throw new Exception("네이버페이 포인트 사용 금액이 결제 금액보다 클 수 없습니다.");
		}
		// 포인트 차감
		int remainingCash = currentCash - useCash;
		int cashUpdateResult = cashDAO.updateCash(userId, remainingCash);
		if (cashUpdateResult <= 0) {
	throw new Exception("네이버페이 포인트 차감 실패");
		}
	}
	// 5. 배송지 정보 조회
	ShippingDAO shippingDAO = new ShippingDAO();
	ShippingVO shippingVO = shippingDAO.selectOneShipping(shippingId);

	if (shippingVO == null) {
		throw new Exception("배송지 정보가 없습니다.");
	}
	// 6. 주문 정보 생성
	OrderVO orderVO = new OrderVO();
	orderVO.setUserId(userId);
	orderVO.setOrderName("상품 주문");
	orderVO.setOrderDate(new Date(System.currentTimeMillis()));
	orderVO.setOrderStatus("결제완료");
	orderVO.setTotalAmount(amount); // 원래 상품 가격
	orderVO.setOrderFlag("배송준비");

	// 8. 주문 정보 저장
	OrderProductVO orderProductVO = new OrderProductVO();
	orderProductVO.setProductId(productId);
	orderProductVO.setQuantity(1);
	orderProductVO.setPrice(amount);

	// 7. 주문 정보 DB 처리 (배송지 정보도 함께 처리)
	OrderDAO orderDAO = new OrderDAO();

	int orderResult = orderDAO.insertOrder(orderVO, orderProductVO, shippingId);

	if (orderResult <= 0) {
		throw new Exception("주문 정보 저장 실패");
	}
	// 9. 결제 정보 저장
	PaymentVO paymentVO = new PaymentVO();
	paymentVO.setOrderId(orderResult);
	paymentVO.setAmount(amount - useCash); // 실제 결제 금액
	paymentVO.setMethod(paymentMethod);
	paymentVO.setPaymentDate(new Date(System.currentTimeMillis()));
	paymentVO.setUserCash(useCash);
	PaymentDAO paymentDAO = new PaymentDAO();
	int paymentResult = paymentDAO.insertPayment(paymentVO);
	if (paymentResult <= 0) {
		throw new Exception("결제 정보 저장 실패");
	}
	jsonResponse.put("success", true);
	jsonResponse.put("orderId", orderResult);

} catch (Exception e) {
	System.out.println("Error occurred: " + e.getMessage());
	e.printStackTrace();
	jsonResponse.put("success", false);
	jsonResponse.put("message", e.getMessage());
}

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
out.print(jsonResponse.toJSONString());
out.flush();
%>