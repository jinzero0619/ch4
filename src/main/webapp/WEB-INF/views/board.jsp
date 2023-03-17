<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ page session="true"%>
<c:set var="loginId" value="${sessionScope.id}"/>
<c:set var="loginOutLink" value="${loginId=='' ? '/login/login' : '/login/logout'}"/>
<c:set var="loginOut" value="${loginId=='' ? 'Login' : 'ID='+=loginId}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>fastcampus</title>
    <link rel="stylesheet" href="<c:url value='/css/menu.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: "Noto Sans KR", sans-serif;
        }
        .container {
            width : 50%;
            height : 50%;
            margin : auto;
        }
        .writing-header {
            position: relative;
            margin: 20px 0 0 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #323232;
        }
        input {
            width: 100%;
            height: 35px;
            margin: 5px 0px 10px 0px;
            border: 1px solid #e9e8e8;
            padding: 8px;
            background: #f8f8f8;
            outline-color: #e6e6e6;
        }
        textarea {
            width: 100%;
            background: #f8f8f8;
            margin: 5px 0px 10px 0px;
            border: 1px solid #e9e8e8;
            resize: none;
            padding: 8px;
            outline-color: #e6e6e6;
        }
        .frm {
            width:100%;
        }
        .btn {
            background-color: rgb(236, 236, 236); /* Blue background */
            border: none; /* Remove borders */
            color: black; /* White text */
            padding: 6px 12px; /* Some padding */
            font-size: 16px; /* Set a font size */
            cursor: pointer; /* Mouse pointer on hover */
            border-radius: 5px;
        }
        .btn:hover {
            text-decoration: underline;
        }
        #commentList {
            display:flex;
            flex-direction: column;
        }
        .commentoption {
            width : 100%;
            display: flex;
            flex-direction: row;
            vertical-align: middle;
            background: #1b2133;
        }

        .sort {
            display:flex;
            flex-direction: column;
            background: #1b2133;
        }

        #delBtn {
            display:block;
        }
    </style>
</head>
<body>
<div id="menu">
    <ul>
        <li id="logo">fastcampus</li>
        <li><a href="<c:url value='/'/>">Home</a></li>
        <li><a href="<c:url value='/board/list'/>">Board</a></li>
        <li><a href="<c:url value='${loginOutLink}'/>">${loginOut}</a></li>
        <li><a href="<c:url value='/register/add'/>">Sign in</a></li>
        <li><a href=""><i class="fa fa-search"></i></a></li>
    </ul>
</div>
<script>
    let msg = "${msg}";
    if(msg=="WRT_ERR") alert("게시물 등록에 실패하였습니다. 다시 시도해 주세요.");
    if(msg=="MOD_ERR") alert("게시물 수정에 실패하였습니다. 다시 시도해 주세요.");
</script>
<div class="container">
    <h2 class="writing-header">게시판 ${mode=="new" ? "글쓰기" : "읽기"}</h2>
    <form id="form" class="frm" action="" method="post">
        <input type="hidden" name="bno" value="${boardDto.bno}">

        <input name="title" type="text" value="<c:out value='${boardDto.title}'/>" placeholder="  제목을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}><br>
        <textarea name="content" rows="20" placeholder=" 내용을 입력해 주세요." ${mode=="new" ? "" : "readonly='readonly'"}><c:out value="${boardDto.content}"/></textarea><br>

        <c:if test="${mode eq 'new'}">
            <button type="button" id="writeBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 등록</button>
        </c:if>
        <c:if test="${mode ne 'new'}">
            <button type="button" id="writeNewBtn" class="btn btn-write"><i class="fa fa-pencil"></i> 글쓰기</button>
        </c:if>
        <c:if test="${boardDto.writer eq loginId}">
            <button type="button" id="modifyBtn" class="btn btn-modify"><i class="fa fa-edit"></i> 수정</button>
            <button type="button" id="removeBtn" class="btn btn-remove"><i class="fa fa-trash"></i> 삭제</button>
        </c:if>
        <button type="button" id="listBtn" class="btn btn-list"><i class="fa fa-bars"></i> 목록</button>
        <button type="button" id="commentBtn" class="btn btn-list"><i class="fa fa-bars"></i> 댓글 보기</button>
    </form>
</div>
<br>
<div id="commentList"></div>

<%--댓글 불러오기 기능--%>
<script>

    let id;

    let setUserId = function(userId) {
        id =userId;
    }

    let showList = function(bno){
        setUserId(${userId});
        $.ajax({
            type:'GET',       // 요청 메서드
            url: '/ch4/comments?bno='+bno,  // 요청 URI
            success : function(result){
                if(result.length == 0){
                    alert("댓글이 없습니다");
                }
                let comments = result;
                $("#commentList").html(toHtml(comments));
            },
            error   : function(){ alert("error") } // 에러가 발생했을 때, 호출될 함수
        }); // $.ajax()
    }
    let toHtml = function(comments,userId) {
        let tmp = "<ul class='sort'>";
        let space = "&nbsp";
        comments.forEach(function (comment) {
            tmp += '<li class="commentoption" data-cno=' + comment.cno
            tmp += '    data-pcno=' + comment.pcno
            tmp += '    data-bno=' + comment.bno + '>'
            if (comment.pcno != comment.cno)
                tmp += "ㄴ"
            tmp += "[" + comment.commenter +"]" + '<br>'
            tmp +=  comment.comment + '<br>'
            // if (comment.commenter == id ) {
                tmp += '<button id="delBtn" type="button">삭제</button>'
                tmp += '<button id="modBtn" type="button">수정</button>'
            // }
            tmp += '<button id="replyBtn" type="button">답글</button>'
            tmp += '</li>'
        })
        return tmp + "</ul>";
    }
</script>

<script>
    $(document).ready(function(){
        let formCheck = function() {
            let form = document.getElementById("form");
            if(form.title.value=="") {
                alert("제목을 입력해 주세요.");
                form.title.focus();
                return false;
            }
            if(form.content.value=="") {
                alert("내용을 입력해 주세요.");
                form.content.focus();
                return false;
            }
            return true;
        }
        $("#writeNewBtn").on("click", function(){
            location.href="<c:url value='/board/write'/>";
        });
        $("#writeBtn").on("click", function(){
            let form = $("#form");
            form.attr("action", "<c:url value='/board/write'/>");
            form.attr("method", "post");
            if(formCheck())
                form.submit();
        });
        $("#modifyBtn").on("click", function(){
            let form = $("#form");
            let isReadonly = $("input[name=title]").attr('readonly');
            // 1. 읽기 상태이면, 수정 상태로 변경
            if(isReadonly=='readonly') {
                $(".writing-header").html("게시판 수정");
                $("input[name=title]").attr('readonly', false);
                $("textarea").attr('readonly', false);
                $("#modifyBtn").html("<i class='fa fa-pencil'></i> 등록");
                return;
            }
            // 2. 수정 상태이면, 수정된 내용을 서버로 전송
            form.attr("action", "<c:url value='/board/modify${searchCondition.queryString}'/>");
            form.attr("method", "post");
            if(formCheck())
                form.submit();
        });
        $("#removeBtn").on("click", function(){
            if(!confirm("정말로 삭제하시겠습니까?")) return;
            let form = $("#form");
            form.attr("action", "<c:url value='/board/remove${searchCondition.queryString}'/>");
            form.attr("method", "post");
            form.submit();
        });
        $("#listBtn").on("click", function(){
            location.href="<c:url value='/board/list${searchCondition.queryString}'/>";
        });
        $("#commentBtn").on("click", function(){
            showList(${boardDto.bno});
        })
    });
        $("#commentList").on("click",".delBtn",function(){
            if(!confirm("정말로 삭제하시겠습니까?")) return;
            let bno = $(this).parent().attr("data-bno");
            let cno = $(this).parent().attr("data-cno");
            $.ajax({
                type : 'DELETE',
                url : '/ch4/comments/' + cno + '?bno=' + bno,
                success : function(result){
                    alert(result);
                    showList(bno);
                },
                error : function (){ alert("error!")}
            })
        });
</script>
</body>
</html>