<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    info=""
    %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
request.setCharacterEncoding("UTF-8");
String productName = request.getParameter("productName");
String imgName = request.getParameter("imgName");

// 세션에 저장
session.setAttribute("reviewProductName", productName);
session.setAttribute("reviewImgName", imgName);
%>