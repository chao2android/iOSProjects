//
//  DataType.h
//  TestPinBang
//
//  Created by Hepburn Alex on 13-2-21.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#ifndef TestPinBang_DataType_h
#define TestPinBang_DataType_h

typedef enum {
    TRegionLevel_Province = 1,
    TRegionLevel_City,
    TRegionLevel_District
}TRegionLevel;

typedef enum {
    TDemandState_None = -1,         //未加入
    TDemandState_Owner = 0,         //创建者
    TDemandState_Apply = 1,         //申请中
    TDemandState_Run = 2,           //进行中
    TDemandState_Evaluate = 3,      //评价中
    TDemandState_End = 4,           //已评价
}TDemandState;

typedef enum {
    TDemandType_Free,
    TDemandType_Travel,
    TDemandType_Taxi,
    TDemandType_All,
    TDemandType_Search,
    TDemandType_Track,
    TDemandType_TaxiAll
}TDemandType;

typedef enum {
    TMessageType_System_UserUpdate = 0,
    TMessageType_System_VerUpdate,
    TMessageType_System_Notice,
    TMessageType_System_Friend,
    TMessageType_Dialogue,
    TMessageType_Response,
    TMessageType_Record
} TMessageType;

typedef enum {
    TCellBackType_Top,
    TCellBackType_Center,
    TCellBackType_Bottom,
    TCellBackType_Full
} TCellBackType;

typedef enum {
    TPinbaState_None,
    TPinbaState_Apply,
    TPinbaState_Member,
    TPinbaState_Creater
} TPinbaState;

typedef enum {
    TMemberListType_DemandApply,
    TMemberListType_DemandMember,
    TMemberListType_PinbaApply,
    TMemberListType_PinbaMember,
} TMemberListType;

#endif
