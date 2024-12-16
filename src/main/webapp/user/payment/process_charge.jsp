<%@page import="user.dao.UserCashDAO"%>
<%@ page contentType="application/json;charset=UTF-8" language="java"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ include file="/common/session_chk.jsp"%>

<%
JSONObject jsonResponse = new JSONObject();

try {
	// 파라미터 검증
	String amountStr = request.getParameter("amount");
	if (amountStr == null || amountStr.trim().isEmpty()) {
		throw new Exception("충전 금액이 누락되었습니다.");
	}
	// 사용자 ID는 세션에서 가져옴 (session_chk.jsp에서 설정된 값)
	String userId = sessionId;
	// 금액 변환 및 유효성 검사
	int amount;
	try {
		amount = Integer.parseInt(amountStr);
		if (amount < 1000) {
	throw new Exception("최소 충전 금액은 1,000원입니다.");
		}
	} catch (NumberFormatException e) {
		throw new Exception("올바른 금액을 입력해주세요.");
	}
	UserCashDAO cashDAO = new UserCashDAO();

	// 현재 캐시 조회
	int currentCash = cashDAO.selectUserCash(userId);

	// 새로운 캐시 금액
	int newCash = currentCash + amount;

	// 캐시 업데이트 또는 insert
	int result = cashDAO.updateCash(userId, newCash);

	if (result > 0) {
		jsonResponse.put("success", true);
		jsonResponse.put("message", "충전이 완료되었습니다.");
		jsonResponse.put("newBalance", newCash);
	} else {
		// 사용자 캐시 정보가 없는 경우 새로 입력
		result = cashDAO.insertCash(userId, amount);
		if (result > 0) {
	jsonResponse.put("success", true);
	jsonResponse.put("message", "충전이 완료되었습니다.");
	jsonResponse.put("newBalance", amount);
		} else {
	throw new Exception("충전 처리에 실패했습니다.");
		}
	}

} catch (Exception e) {
	e.printStackTrace();
	jsonResponse.put("success", false);
	jsonResponse.put("message", "충전 중 오류가 발생했습니다: " + e.getMessage());
}

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
out.print(jsonResponse.toJSONString());
out.flush();
%>