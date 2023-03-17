package com.fastcampus.ch4.dao;

import com.fastcampus.ch4.domain.CommentDto;

import java.util.List;

public interface CommentDao {
    int deleteAll(Integer bno) throws Exception;

    int count(Integer bno) throws Exception;

    int delete(Integer cno, String commenter);

    int insert(CommentDto dto);

    List<CommentDto> selectAll(int bno);

    CommentDto select(int cno);

    int update(CommentDto dto);
}
