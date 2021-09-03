package com.project.gymcarry.dao;

import java.util.List;

import com.project.gymcarry.place.PlaceDto;

public interface PlaceDao {

    // 헬스 플레이스 전체 정보
    List<PlaceDto> selectHealthPlaceList(int placenum) ;

    // 필라테스 플레이스 전체 정보
    List<PlaceDto> selectPilatesPlaceList(int placenum) ;


}