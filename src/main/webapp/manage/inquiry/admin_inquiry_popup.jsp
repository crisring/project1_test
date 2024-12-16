<%@page import="manage.inquiry.InquiryVO"%>
<%@page import="manage.inquiry.AdminInquiryDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% request.setCharacterEncoding("UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>문의 관리 팝업</title>

    <!-- Bootstrap CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <!-- jQuery CDN -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

    <script type="text/javascript">
    $(function () {

        // 삭제 버튼 이벤트 (class 기반)
        $(document).on('click', '.delete-button', function (event) {
            if (confirm("해당 문의를 삭제하시겠습니까?")) {
                // 삭제 액션 설정
                $("#submitAction").val("delete");
                $("#mainForm").submit();
            } else {
                // 폼 제출 방지
                event.preventDefault();
            }
        });

        // 닫기 버튼 이벤트
        $("#close").click(function () {
            self.close();
        });

        // 수정 버튼 이벤트
        $("#editButton").click(function () {
            $("#answerDisplay").hide();    // 기존 답변 숨기기
            $("#editForm").show();         // 수정 폼 표시
        });

        // 취소 버튼 이벤트
        $("#cancelButton").click(function () {
            $("#editForm").hide();         // 수정 폼 숨기기
            $("#answerDisplay").show();    // 기존 답변 표시
        });

        // 등록 버튼 이벤트
        $("#register").click(function(){
            chkNull("register");
        }); // register

        // 저장 버튼 이벤트 (수정 폼)
        $("#saveButton").click(function(){
            chkNull("save");
        }); // saveButton

    }); // ready

    // 유효성 검증 함수
    function chkNull(actionType){
        var content;
        if(actionType === "register"){
            content = $("#content").val();
        } else if(actionType === "save"){
            content = $("#editContent").val();
        }

        if(content == null || content.trim() === ""){
            alert("내용을 입력해주세요");
            return;
        } else {
            // 액션 타입 설정 후 폼 제출
            $("#submitAction").val(actionType === "register" ? "register" : "update");
            $("#mainForm").submit();
        }
    }
    </script>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: Arial, sans-serif;
        }
        .header {
            background-color: #28a745;
            color: white;
            padding: 15px;
            font-weight: bold;
            text-align: center;
        }
        .content {
            padding: 20px;
        }
        .titleTable {
            width: 100%;
            table-layout: fixed;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            white-space: nowrap;
        }
        .form-container {
            padding: 20px;
            border: 1px solid #ddd;
            margin-top: 20px;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>

<body>
    <div class="header">문의 상세보기</div>
    <div class="content">
        <%
            AdminInquiryDAO aiDAO = AdminInquiryDAO.getInstance();
            InquiryVO iVO = null;

            String inquiryIdStr = request.getParameter("inquiryId");
            if (inquiryIdStr != null && !inquiryIdStr.isEmpty()) {
                try {
                    int inquiryId = Integer.parseInt(inquiryIdStr);
                    iVO = aiDAO.selectOneInquiry(inquiryId);
                    request.setAttribute("iVO", iVO);
                    request.setAttribute("inquiryId", inquiryId);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                    out.println("<p>잘못된 형식의 ID입니다. 숫자로 입력해 주세요.</p>");
                }
            } else {
                out.println("<p>유효한 ID가 전달되지 않았습니다.</p>");
            }

            if (iVO == null) {
                out.println("<p>해당 ID로 데이터를 찾을 수 없습니다.</p>");
            }//end if
        %>

        <c:if test="${not empty iVO}">
            <!-- 문의 정보 테이블 -->
            <table class="titleTable">
                <tr>
                    <th>문의 유형</th>
                    <td><c:out value="${iVO.category}"/></td>
                 
                    <th>등록일</th>
                    <td> <fmt:formatDate value="${iVO.createAt}" pattern="yyyy-MM-dd"/></td>
                    <th>아이디</th>
                    <td><c:out value="${iVO.userId}"/></td>
                </tr>
                <tr>
                   <th>문의제목</th>
                    <td colspan="5"><c:out value="${iVO.title}"/></td>
                
                </tr>
            </table>
            
            <!-- 문의 내용 -->
            <div class="form-container">
                <p><c:out value="${iVO.content}"/></p>
            </div>

            <!-- 통합 폼 시작 -->
            <form id="mainForm" method="post" action="admin_inquiry_process.jsp">
                <input type="hidden" name="inquiryId" value="${inquiryId}">
                <input type="hidden" name="submitAction" id="submitAction" value="">

                <!-- 답변 등록/수정 섹션 -->
                <div class="form-container">
                    <h5>답변</h5>
                    <div class="form-group">
                        <c:choose>
                            <c:when test="${not empty iVO.adminAd}">
                                <!-- 답변이 이미 있는 경우 -->
                                <!-- 기존 답변 표시 -->
                                <div id="answerDisplay"><c:out value="${iVO.adminAd}"/></div>

                                <!-- 수정 및 삭제 버튼 -->
                                <div class="footer">
                                    <button type="button" class="btn btn-info btn-sm" id="editButton">수정</button>
                                    <button type="button" class="btn btn-danger btn-sm delete-button" name="submitAction" value="delete">삭제</button>
                                    <button type="button" class="btn btn-light btn-sm" id="close">닫기</button>
                                </div>

                                <!-- 수정 폼 (초기에 숨김 처리) -->
                                <div id="editForm" style="display: none; margin-top: 20px;">
                                    <textarea id="editContent" class="form-control" rows="7" name="answer"><c:out value="${iVO.adminAd}"/></textarea>
                                    <div class="footer">
                                        <button type="button" class="btn btn-success btn-sm" id="saveButton">저장</button>
                                        <button type="button" class="btn btn-secondary btn-sm" id="cancelButton">취소</button>
                                    </div>
                                </div>

                            </c:when>
                            <c:otherwise>
                                <!-- 답변이 없는 경우 폼 표시 -->
                                <textarea id="content" class="form-control" rows="7" placeholder="내용을 입력하세요" name="answer"></textarea>
                                <div class="footer">
                                    <button type="button" class="btn btn-success btn-sm" id="register" name="submitAction" value="register">등록</button>
                                    <button type="button" class="btn btn-danger btn-sm delete-button" name="submitAction" value="delete">삭제</button>
                                    <button type="button" class="btn btn-light btn-sm" id="close">닫기</button>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </form>
            <!-- 통합 폼 종료 -->
        </c:if>
    </div>
</body>
</html>
