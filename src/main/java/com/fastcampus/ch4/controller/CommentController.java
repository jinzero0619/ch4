package com.fastcampus.ch4.controller;

import com.fastcampus.ch4.domain.CommentDto;
import com.fastcampus.ch4.service.CommentService;
import com.mysql.cj.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class CommentController {
    @Autowired
    CommentService service;

    // 수정
    @ResponseBody
    @PatchMapping("/comments/{cno}")
    public ResponseEntity<String> modify(@PathVariable Integer cno,@RequestBody CommentDto dto, HttpSession session){
//        String commenter = (String)session.getAttribute("id");
        // 비로그인으로 테스트만 진행하고 있기 때문에 session에서 아이디 가져오는 부분은 주석처리하고
        // commenter 하드코딩
        String commenter ="jinzero";
        dto.setCommenter(commenter);
        dto.setCno(cno);

        System.out.println("dto = " + dto);

        try {
            if(service.modify(dto)!=1)
                throw new Exception("Modify Fail");

            return new ResponseEntity<>("Modify_Ok",HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Modify_Err",HttpStatus.BAD_REQUEST);
        }
    }

    // 작성
    @ResponseBody
    @PostMapping("/comments")
    // @RequestBody = jsp에서 컨트로러로 보낸 JSON을 자바 객체로 바꿔주는 역할을 함
    public ResponseEntity<String> write(@RequestBody CommentDto dto, int bno, HttpSession session){
//        String commenter = (String)session.getAttribute("id");
        String commenter = "jinzero";
        dto.setCommenter(commenter);
        dto.setBno(bno);
        System.out.println("dto = " + dto);
        try {
            if(service.write(dto)!=1)
                throw new Exception("Write Fail");

            return new ResponseEntity<>("Write_ok",HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Write_err",HttpStatus.BAD_REQUEST);
        }
    }

    // 삭제
    // 쿼리스트링이 아닌 URI 일부로 맵핑을 할 경우 하고자 하는 것을 감싸고
    // PathVariable 에너테이션 사용
    @DeleteMapping("/comments/{cno}")
    @ResponseBody
    public ResponseEntity<String> remove(@PathVariable Integer cno, int bno, HttpSession session) {
//        String commenter = (String)session.getAttribute("id");
        String commenter = "jinzero";
        try {
            int rowCnt = service.remove(cno,bno,commenter);

            if(rowCnt!=1)
                throw new Exception("Delete Failed");

            return new ResponseEntity<>("Del_Ok",HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Del_Err",HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/comments")
    @ResponseBody public ResponseEntity<List<CommentDto>> list(int bno) {
        List<CommentDto> list = null;
        try {
            list = service.getList(bno);
            return new ResponseEntity<List<CommentDto>>(list, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ResponseEntity<List<CommentDto>>(list, HttpStatus.BAD_REQUEST);
    }
}
