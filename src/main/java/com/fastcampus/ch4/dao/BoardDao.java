package com.fastcampus.ch4.dao;

import com.fastcampus.ch4.domain.BoardDto;
import com.fastcampus.ch4.domain.SearchCondition;

import java.util.List;
import java.util.Map;

public interface BoardDao {
    //region select
    BoardDto select(int bno) throws Exception;

    List<BoardDto> selectAll() throws Exception;

    List<BoardDto> selectPage(Map map) throws Exception;

    List<BoardDto> selectFromBoard() throws Exception;

    public int searchResultCnt(SearchCondition sc) throws Exception;


    public List<BoardDto> searchselectPage(SearchCondition sc) throws Exception;

    int count() throws Exception;

    // region update
    int update(BoardDto dto) throws Exception;

    int increaseViewCnt(int bno) throws Exception;

    // region delete
    int deleteAll();

    int delete(Integer bno, String writer);

    // region insert
    int insert(BoardDto dto);

    int updateCommentCnt(Integer bno, int cnt);
}
