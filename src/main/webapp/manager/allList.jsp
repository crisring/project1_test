<%@page import="java.sql.SQLException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="manager.productlist.ProductVO"%>
<%@page import="java.util.List"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="test.TestAdminProductManagementDAO"%>
<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info=""%>


<%
JSONObject jsonObj = new JSONObject();
boolean resultFlag = false;

TestAdminProductManagementDAO apmDAO = TestAdminProductManagementDAO.getInstance();
JSONArray jsonArr = new JSONArray();
try {
	List<ProductVO> list = apmDAO.selectAllProduct();
	resultFlag = true;
	JSONObject jsonTemp = null;

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	for (ProductVO pVO : list) {
		jsonTemp = new JSONObject();
		jsonTemp.put("product_id", pVO.getProductId());
		jsonTemp.put("name", pVO.getProductName());
		jsonTemp.put("model_name", pVO.getModelName());
		jsonTemp.put("brand", pVO.getBrand());
		jsonTemp.put("sales_status", pVO.getSaleStatus());
		jsonTemp.put("stock_quantity", pVO.getStockQuantity());
		jsonTemp.put("price", pVO.getPrice());
		jsonTemp.put("discount_price", pVO.getDiscount_price());
		jsonTemp.put("created_at", sdf.format(pVO.getCreateAt()));
		jsonTemp.put("finish_at", sdf.format(pVO.getFinishAt()));

		jsonArr.add(jsonTemp);
	} //end for
} catch (SQLException se) {
	se.printStackTrace();
} //end catch

jsonObj.put("resultFlag", resultFlag);
jsonObj.put("data", jsonArr);
jsonObj.put("dataLength", jsonArr.size());

out.print(jsonObj.toJSONString());
%>
