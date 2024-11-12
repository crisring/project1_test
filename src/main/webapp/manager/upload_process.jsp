<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" info="multipart/form-data인 경우 웹 파라미터가 전달되지 않는다."%>

<%
boolean uploadFlag = (session.getAttribute("uploadFlag") != null)
		? (boolean) session.getAttribute("uploadFlag")
		: false;
String msg = "";

if (!uploadFlag) {
	try {
		File saveDir = new File("C:/dev/workspace/project1/src/main/webapp/manager/images");
		int maxSize = 1024 * 1024 * 12; // 12MB 제한
		MultipartRequest mr = new MultipartRequest(request, saveDir.getAbsolutePath(), maxSize, "UTF-8",
		new DefaultFileRenamePolicy());

		String originName = mr.getOriginalFileName("upfile");
		String fileSysname = mr.getFilesystemName("upfile");

		if (originName != null) {
	File uploadFile = new File(saveDir.getAbsolutePath() + "/" + fileSysname);

	if (uploadFile.length() > maxSize) {
		uploadFile.delete();
		msg = originName + "은(는) " + (maxSize / 1024 / 1024) + "MB를 초과합니다. 제한 용량 이하의 파일을 업로드해주세요.";
	} else {
		msg = "파일 업로드 성공";
	}
		}
	} catch (Exception e) {
		e.printStackTrace();
		msg = "파일 업로드 실패: " + e.getMessage();
	}
	session.setAttribute("uploadFlag", true); // 업로드 완료 시 uploadFlag 설정
} else {
	msg = "파일 업로드가 이미 완료되었습니다.";
}

session.removeAttribute("uploadFlag"); // 페이지 새로고침 시 초기화
%>

<%
if (!msg.isEmpty()) {
%>
<script>
    console.log('<%=msg.replaceAll("'", "\\\\'")%>
	'); // 콘솔에 출력
</script>
<%
}
%>


