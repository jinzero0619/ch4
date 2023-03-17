package com.fastcampus.ch4.dao;

import com.fastcampus.ch4.domain.CommentDto;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class CommentDaoImpl implements CommentDao {
    @Autowired
    SqlSession session;
    String namespace="com.fastcampus.ch4.dao.CommentMapper.";

    @Override
    public int deleteAll(Integer bno) throws Exception {
        return session.delete(namespace+"deleteAll",bno);
    }

    @Override
    public int count(Integer bno) throws Exception {
        return session.selectOne(namespace+"count",bno);
    }

    @Override
    public int delete(Integer cno, String commenter){
        Map map = new HashMap();
        map.put("cno",cno);
        map.put("commenter",commenter);
        return session.delete(namespace+"delete",map);
    }

    @Override
    public int insert(CommentDto dto) {
        return session.insert(namespace+"insert",dto);
    }

    @Override
    public List<CommentDto> selectAll(int bno){
        return session.selectList(namespace+"selectAll",bno);
    }

    @Override
    public CommentDto select(int cno){
        return session.selectOne(namespace+"select",cno);
    }

    @Override
    public int update(CommentDto dto) {
        return session.update(namespace+"update",dto);
    }

}
