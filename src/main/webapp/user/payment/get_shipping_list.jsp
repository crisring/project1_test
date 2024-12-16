<%@page import="user.vo.ShippingVO"%>
<%@page import="user.dao.ShippingDAO"%>
<%@ page contentType="application/json;charset=UTF-8" language="java"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.util.List"%>
<%@ include file="/common/session_chk.jsp"%>

<%
JSONObject jsonResponse = new JSONObject();

try {
	// 임시 userId (실제로는 세션에서 가져와야 함)
	String userId = sessionId;

	if (userId == null || userId.trim().isEmpty()) {
		throw new Exception("사용자 ID가 없습니다.");
	}

	ShippingDAO dao = new ShippingDAO();
	List<ShippingVO> shippingList = dao.selectAllShipping(userId);

	JSONArray jsonArray = new JSONArray();
	for (ShippingVO sVO : shippingList) {
		JSONObject shipping = new JSONObject();
		shipping.put("shippingId", sVO.getShippingId());
		shipping.put("recipient", sVO.getRecipient());
		shipping.put("phone", sVO.getPhone());
		shipping.put("address", sVO.getAddress());
		shipping.put("address2", sVO.getAddress2());
		shipping.put("memo", sVO.getMemo());
		jsonArray.add(shipping);
	}

	jsonResponse.put("success", true);
	jsonResponse.put("shippingList", jsonArray);

} catch (Exception e) {
	e.printStackTrace();
	jsonResponse.put("success", false);
	jsonResponse.put("message", "배송지 목록 조회 중 오류가 발생했습니다: " + e.getMessage());
}

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
out.print(jsonResponse.toJSONString());
out.flush();
%>