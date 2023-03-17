package com.fastcampus.ch4.dao;

import com.fastcampus.ch4.domain.BoardDto;
import com.fastcampus.ch4.domain.SearchCondition;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class BoardDaoImpl implements BoardDao {
    @Autowired
    SqlSession session;

    String namespace="com.fastcampus.ch4.dao.BoardMapper.";

    //region select
    @Override
    public BoardDto select(int bno) throws Exception {
        return session.selectOne(namespace + "select",bno);
    }

    @Override
    public List<BoardDto> selectAll() throws Exception {
        return session.selectList(namespace + "selectAll");
    }

    @Override
    public List<BoardDto> selectPage(Map map) throws Exception {
        return session.selectList(namespace + "selectPage",map);
    }

    @Override
    public List<BoardDto> selectFromBoard() throws Exception {
        return session.selectList(namespace + "selectFromBoard");
    }

    @Override
    public int count() throws Exception {
        return session.selectOne(namespace+"count");
    }

    @Override
    public int searchResultCnt(SearchCondition sc) throws Exception {
        return session.selectOne(namespace+"searchResultCnt",sc);
    }

    @Override
    public List<BoardDto> searchselectPage(SearchCondition sc) throws Exception {
        return session.selectList(namespace + "searchSelectPage",sc);
    }

    //endregion

    // region update
    @Override
    public int update(BoardDto dto) throws Exception{
        return session.update(namespace + "update",dto);
    }

    @Override
    public int increaseViewCnt(int bno) throws Exception {
        return session.update(namespace +"increaseViewCnt",bno);
    }

    @Override
    public int updateCommentCnt(Integer bno, int cnt) {
        Map map = new HashMap();
        map.put("bno",bno);
        map.put("cnt",cnt);
        return session.update(namespace+"updateCommentCnt",map);
    }


    // endregion

    // region delete
    @Override
    public int deleteAll(){
        return session.delete(namespace + "deleteAll");
    }

    @Override
    public int delete(Integer bno, String writer) {
        Map map = new HashMap();
        map.put("bno",bno);
        map.put("writer",writer);
        return session.delete(namespace + "delete",map);
    }

    // region insert
    @Override
    public int insert(BoardDto dto){
        return session.insert(namespace + "insert",dto);
    }


    // endregion







}
