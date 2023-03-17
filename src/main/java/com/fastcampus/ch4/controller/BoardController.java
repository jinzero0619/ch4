package com.fastcampus.ch4.controller;

import com.fastcampus.ch4.domain.BoardDto;
import com.fastcampus.ch4.domain.PageHandler;
import com.fastcampus.ch4.domain.SearchCondition;
import com.fastcampus.ch4.service.BoardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/board")
public class BoardController {
    @Autowired
    BoardService boardService;

    @PostMapping("/modify")
    public String modify(BoardDto boardDto,Model m,HttpSession session, RedirectAttributes rdattr) {
        String writer = (String) session.getAttribute("id");
        boardDto.setWriter(writer);
        try {
            int rowCnt = boardService.modify(boardDto);

            if(rowCnt!= 1)
                throw new Exception("modify failed");

            rdattr.addFlashAttribute("msg","Update_ok");
            return "redirect:/board/list";
        } catch (Exception e) {
            e.printStackTrace();
            m.addAttribute("boardDto",boardDto);
            rdattr.addFlashAttribute("msg","Update_Err");
            return "board";
        }
    }

    @PostMapping("/write")
    public String write(BoardDto boardDto,Model m,HttpSession session, RedirectAttributes rdattr) {
        String writer = (String) session.getAttribute("id");
        boardDto.setWriter(writer);

        try {
            int rowCnt = boardService.write(boardDto);

            if(rowCnt!= 1)
                throw new Exception("Write failed");

            rdattr.addFlashAttribute("msg","Write_ok");
            return "redirect:/board/list";
        } catch (Exception e) {
            e.printStackTrace();
            m.addAttribute("boardDto",boardDto);
            rdattr.addFlashAttribute("msg","Write_Err");
            return "board";
        }
    }

    @GetMapping("/write")
    public String write(Model m) {
        m.addAttribute("mode","new");
        return "board";
    }

    @PostMapping("/remove")
    public String remove(Integer bno, Integer page, Integer pageSize, Model m, HttpSession session, RedirectAttributes rattr){
        String writer = (String)session.getAttribute("id");
        try {

            m.addAttribute("page",page);
            m.addAttribute("pageSize",pageSize);  // 이렇게 모델에 담으면 redierect시 뒤에 붙음

            int rowCnt = boardService.remove(bno,writer);

            if(rowCnt!=1) throw new Exception("board remove Error!");

            rattr.addFlashAttribute("msg","Delete_OK");

        } catch (Exception e) {
            e.printStackTrace();
            rattr.addFlashAttribute("msg","Delete_Error");
        }

        return "redirect:/board/list";
        
    }

    @GetMapping("/read")
    public String read(Integer bno,Integer page, Integer pageSize, Model m, HttpSession session) {
        try {
            String userId = (String)session.getAttribute("id");
            BoardDto boardDto = boardService.read(bno);
            m.addAttribute("boardDto",boardDto);
            m.addAttribute("page",page);
            m.addAttribute("pageSize",pageSize);
            m.addAttribute("userId",userId);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "board";
    }


    @GetMapping("/list")
    public String list(@ModelAttribute SearchCondition sc, Model m, HttpServletRequest request) {
        if(!loginCheck(request))
            return "redirect:/login/login?toURL="+request.getRequestURL();  // 로그인을 안했으면 로그인 화면으로 이동

        try {
            int totalCnt = boardService.getsearchResultCnt(sc);
            m.addAttribute("totalCnt",totalCnt);
            PageHandler pageHandler = new PageHandler(totalCnt, sc);

            List<BoardDto> list =  boardService.getSearchSelectPage(sc);
            m.addAttribute("list",list);
            m.addAttribute("ph",pageHandler);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "boardList"; // 로그인을 한 상태이면, 게시판 화면으로 이동
    }

    private boolean loginCheck(HttpServletRequest request) {
        // 1. 세션을 얻어서
        HttpSession session = request.getSession();
        // 2. 세션에 id가 있는지 확인, 있으면 true를 반환
        return session.getAttribute("id")!=null;
    }
}