<%@page import="user.dao.ShippingDAO"%>
<%@ page contentType="application/json;charset=UTF-8" language="java"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ include file="/common/session_chk.jsp"%>

<%
JSONObject jsonResponse = new JSONObject();

try {
	// 파라미터 받기
	int shippingId = Integer.parseInt(request.getParameter("shippingId"));

	// 배송지 삭제
	ShippingDAO dao = new ShippingDAO();
	int result = dao.deleteShipping(shippingId);

	if (result > 0) {

		jsonResponse.put("success", true);
		jsonResponse.put("message", "배송지가 삭제되었습니다.");
	} else {
		jsonResponse.put("success", false);
		jsonResponse.put("message", "배송지 삭제에 실패했습니다.");
	}

} catch (Exception e) {
	jsonResponse.put("success", false);
	jsonResponse.put("message", "배송지 삭제 중 오류가 발생했습니다: " + e.getMessage());
}

response.setContentType("application/json");
out.print(jsonResponse.toJSONString());
%>