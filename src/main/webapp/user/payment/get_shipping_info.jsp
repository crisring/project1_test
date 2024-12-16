<%@page import="user.vo.ShippingVO"%>
<%@page import="user.dao.ShippingDAO"%>
<%@ page contentType="application/json;charset=UTF-8" language="java"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ include file="/common/session_chk.jsp"%>

<%
JSONObject jsonResponse = new JSONObject();

try {
	// 파라미터 받기
	String shippingIdStr = request.getParameter("shippingId");

	if (shippingIdStr == null || shippingIdStr.trim().isEmpty()) {
		throw new Exception("배송지 ID가 없습니다.");
	}

	int shippingId = Integer.parseInt(shippingIdStr);

	// 배송지 정보 조회
	ShippingDAO dao = new ShippingDAO();
	ShippingVO sVO = dao.selectOneShipping(shippingId);

	if (sVO != null) {
		jsonResponse.put("success", true);
		jsonResponse.put("shippingId", sVO.getShippingId());
		jsonResponse.put("recipient", sVO.getRecipient());
		jsonResponse.put("phone", sVO.getPhone());
		jsonResponse.put("address", sVO.getAddress());
		jsonResponse.put("address2", sVO.getAddress2());
		jsonResponse.put("memo", sVO.getMemo());
	} else {
		jsonResponse.put("success", false);
		jsonResponse.put("message", "배송지 정보를 찾을 수 없습니다.");
	}

} catch (Exception e) {
	e.printStackTrace();
	jsonResponse.put("success", false);
	jsonResponse.put("message", "배송지 정보 조회 중 오류가 발생했습니다: " + e.getMessage());
}

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
out.print(jsonResponse.toJSONString());
out.flush();
%>