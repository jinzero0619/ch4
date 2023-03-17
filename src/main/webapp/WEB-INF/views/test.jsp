<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
</head>
<body>
<h2>commentTest</h2>
comment : <input type="text" name="comment"><br>
<button id="sendBtn" type="button">전송</button>
<button id="modifyBtn" type="button">수정</button>
<div id="commentList"></div>
<div id="replyForm" style="display:none">
    <input type="text" name="replyComment">
    <button id="wrtReplyBtn" type="button">등록</button>
    <button id="cancleBtn" type="button">취소</button>
</div>
<script>
    let bno = 800;

    let showList = function(bno){
        $.ajax({
            type:'GET',       // 요청 메서드
            url: '/ch4/comments?bno='+bno,  // 요청 URI
            success : function(result){
                $("#commentList").html(toHtml(result));
            },
            error   : function(){ alert("error") } // 에러가 발생했을 때, 호출될 함수
        }); // $.ajax()
    }
    let toHtml = function(comments) {
        let tmp = "<ul>";
        let space = "&nbsp";
        comments.forEach(function (comment) {
            tmp += '<li data-cno=' + comment.cno
            tmp += '    data-pcno=' + comment.pcno
            tmp += '    data-bno=' + comment.bno + '>'
            if (comment.pcno != comment.cno)
                tmp += "ㄴ"
            tmp += 'commenter=' + comment.commenter
            tmp += 'comment=' + comment.comment
            tmp += 'up_date = ' + comment.up_date
            tmp += '<button class="delBtn">삭제</button>'
            tmp += '<button class="modBtn">수정</button>'
            tmp += '<button class="replyBtn">답글</button>'
            tmp += '</li>'
        })
        return tmp + "</ul>";
    }

    // 전송버튼
    $(document).ready(function(){
        $("#sendBtn").click(function(){
            let comment = $("input[name=comment]").val();

            if(comment.trim()==''){
                alert("댓글을 입력해주세요");
                $("input[name=comment]").focus()
                return;
            }

            $.ajax({
                type:'POST',       // 요청 메서드
                url: '/ch4/comments?bno='+ bno,  // 요청 URI
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({bno : bno, comment : comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                                                                        // 이 데이터가 JacksonDataBind를 통해 Controller의
                                                                        // Dto 로 전달된다.
                success : function(result){
                    alert(result);       // result는 서버가 전송한 데이터
                    showList(bno);
                },
                error   : function(){ alert("error") } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()

        });
    });


    // 수정버튼
    $(document).ready(function() {
        $("#modifyBtn").click(function () {
            let comment = $("input[name=comment]").val();
            let cno = $(this).attr("data-cno");
            if (comment.trim() == '') {
                alert("댓글을 입력해주세요");
                $("input[name=comment]").focus()
                return;
            }

            $.ajax({
                type: 'Patch',       // 요청 메서드
                url: '/ch4/comments/' + cno,  // 요청 URI
                headers: {"content-type": "application/json"}, // 요청 헤더
                data: JSON.stringify({cno: cno, comment: comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                // 이 데이터가 JacksonDataBind를 통해 Controller의
                // Dto 로 전달된다.
                success: function (result) {
                    alert(result);       // result는 서버가 전송한 데이터
                    showList(bno);
                },
                error: function () {
                    alert("error")
                } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()

        });
    });


    // 대댓글
    $(document).ready(function(){
        $("#wrtReplyBtn").click(function(){
            let comment = $("input[name=replyComment]").val();
            let pcno = $("#replyForm").parent().attr("data-pcno");

            if(comment.trim()==''){
                alert("댓글을 입력해주세요");
                $("input[name=replyComment]").focus()
                return;
            }

            $.ajax({
                type:'POST',       // 요청 메서드
                url: '/ch4/comments?bno='+ bno,  // 요청 URI
                headers : { "content-type": "application/json"}, // 요청 헤더
                data : JSON.stringify({pcno : pcno,bno : bno, comment : comment}),  // 서버로 전송할 데이터. stringify()로 직렬화 필요.
                                                                        // 이 데이터가 JacksonDataBind를 통해 Controller의
                                                                        // Dto 로 전달된다.
                success : function(result){
                    alert(result);       // result는 서버가 전송한 데이터
                    showList(bno);
                },
                error   : function(){ alert("error") } // 에러가 발생했을 때, 호출될 함수
            }); // $.ajax()

            $("#replyForm").css("display","none")
            $("input[name=replyComment]").val('')
            $("#replyForm").appendTo("body");

        });
    });


    // 대댓글버튼
    $("#commentList").on("click",".replyBtn",function(){
        // 답글 입력 폼 위치 옮기기
        $('#replyForm').appendTo($(this).parent());

        // 답글 입력 폼 보여주고
        $('#replyForm').css("display","block");

        // $('#cancleBtn').click
    });

    // 댓글수정
    $("#commentList").on("click",".modBtn",function(){
        let cno = $(this).parent().attr("data-cno");
        let comment = $('span.comment',$(this).parent()).text()

        // 수정 버튼이 눌린 댓글 불러오기
        $("input[name=comment]").val(comment)

        // 수정 버튼이 눌린 댓글 번호 불러오기
        $('#modifyBtn').attr("data-cno", cno);
    });


    // 댓글삭제
    // $(".delBtn").click(function(){
    // })
    $("#commentList").on("click",".delBtn",function(){
        let cno = $(this).parent().attr("data-cno");
        let bno = $(this).parent().attr("data-bno");
       $.ajax({
           type : 'DELETE',
           url : '/ch4/comments/' + cno + '?bno='+ bno,
           success : function(result){
               alert(result)
               showList(bno)
           }
       })
    })
</script>
</body>
</html>