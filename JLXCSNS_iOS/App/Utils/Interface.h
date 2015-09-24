//
//  Interface.h
//  JLXCSNS_iOS
//
//  Created by 李晓航 on 15/5/8.
//  Copyright (c) 2015年 JLXC. All rights reserved.
//

#ifndef JLXCSNS_iOS_Interface_h
#define JLXCSNS_iOS_Interface_h

//192.168.1.108
//附件
#define kAttachmentAddr @"http://192.168.1.106/jlxc_php/Uploads/"
//IP
#define kRootAddr @"http://192.168.1.106/jlxc_php/"
//home
#define kHomeAddr @"http://192.168.1.106/jlxc_php/index.php/Home/MobileApi"//115.28.4.154 Zwkxd0515
//http://localhost/www/DemoThink/
#define kTestPath [kHomeAddr stringByAppendingString:@"DemoThink/"]
#define kUserProtocolPath @"http://www.90newtec.com/license.html"

//http://localhost/www/test/index.php/Home/Index/testImage
#define kDownLoadPath [kHomeAddr stringByAppendingString:@"test/index.php/Home/Index/testImage"]

////////////////////////////////////////////////登录注册////////////////////////////////////////////////
//是否有该用户
//http://localhost/jlxc_php/index.php/Home/MobileApi/isUser?username=15810710447
#define kIsUserPath [kHomeAddr stringByAppendingString:@"/isUser"]

//获取验证码
//http://localhost/jlxc_php/index.php/Home/MobileApi/getMobileVerify?phone_num=15810710447
#define kGetMobileVerifyPath [kHomeAddr stringByAppendingString:@"/getMobileVerify"]

//注册
//http://localhost/jlxc_php/index.php/Home/MobileApi/registerUser?username=15810710441&password=123456&verify_code=123456
#define kRegisterUserPath [kHomeAddr stringByAppendingString:@"/registerUser"]

//找回密码
//http://localhost/jlxc_php/index.php/Home/MobileApi/findPwd
#define kFindPwdPath [kHomeAddr stringByAppendingString:@"/findPwd"]

//登录
//http://localhost/jlxc_php/index.php/Home/MobileApi/loginUser username password
#define kLoginUserPath [kHomeAddr stringByAppendingString:@"/loginUser"]

//注册时填写个人信息
//http://localhost/jlxc_php/index.php/Home/MobileApi/savePersonalInfo 用户id
#define kSavePersonalInfoPath [kHomeAddr stringByAppendingString:@"/savePersonalInfo"]

////////////////////////////////////////////////首页'说说'部分////////////////////////////////////////////////
//发布状态
//http://localhost/jlxc_php/index.php/Home/MobileApi/publishNews
#define kPublishNewsPath [kHomeAddr stringByAppendingString:@"/publishNews"]

//状态新闻列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/newsList
#define kNewsListPath [kHomeAddr stringByAppendingString:@"/newsList"]

//校园广场新闻列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/schoolNewsList
#define kSchoolNewsListPath [kHomeAddr stringByAppendingString:@"/schoolNewsList"]

//状态点赞列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getNewsLikeList
#define kGetNewsLikeListPath [kHomeAddr stringByAppendingString:@"/getNewsLikeList"]

//发送评论
//http://localhost/jlxc_php/index.php/Home/MobileApi/sendComment
#define kSendCommentPath [kHomeAddr stringByAppendingString:@"/sendComment"]

//删除评论
//http://localhost/jlxc_php/index.php/Home/MobileApi/deleteComment
#define kDeleteCommentPath [kHomeAddr stringByAppendingString:@"/deleteComment"]

//删除二级评论
//http://localhost/jlxc_php/index.php/Home/MobileApi/deleteSecondComment
#define kDeleteSecondCommentPath [kHomeAddr stringByAppendingString:@"/deleteSecondComment"]

//发送二级评论
//http://localhost/jlxc_php/index.php/Home/MobileApi/sendSecondComment
#define kSendSecondCommentPath [kHomeAddr stringByAppendingString:@"/sendSecondComment"]

//点赞或者取消赞
//http://192.168.1.105/jlxc_php/index.php/Home/MobileApi/likeOrCancel?news_id=23&user_id=1&is_second=0&isLike=1
#define kLikeOrCancelPath [kHomeAddr stringByAppendingString:@"/likeOrCancel"]

//新闻详情
//http://localhost/jlxc_php/index.php/Home/MobileApi/newsDetail?news_id=24&user_id=1
#define kNewsDetailPath [kHomeAddr stringByAppendingString:@"/newsDetail"]

//浏览过该新闻的用户列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getNewsVisitList
#define kGetNewsVisitListPath [kHomeAddr stringByAppendingString:@"/getNewsVisitList"]

//获取学校数据
//http://localhost/jlxc_php/index.php/Home/MobileApi/schoolHomeData
#define kSchoolHomeDataPath [kHomeAddr stringByAppendingString:@"/schoolHomeData"]

////////////////////////////////////////////////个人信息////////////////////////////////////////////////
//修改个人信息
//http://localhost/jlxc_php/index.php/Home/MobileApi/changePersonalInformation?field=name&value=gaga
#define kChangePersonalInformationPath [kHomeAddr stringByAppendingString:@"/changePersonalInformation"]

//获取学校列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getSchoolList
#define kGetSchoolListPath [kHomeAddr stringByAppendingString:@"/getSchoolList"]

//获取学校学生列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getSchoolStudentList
#define kGetSchoolStudentListPath [kHomeAddr stringByAppendingString:@"/getSchoolStudentList"]

//选择学校
//http://localhost/jlxc_php/index.php/Home/MobileApi/changeSchool 用户id 学校名 学校码
#define kChangeSchoolPath [kHomeAddr stringByAppendingString:@"/changeSchool"]

//设置HelloHaID
//http://localhost/jlxc_php/index.php/Home/MobileApi/setHelloHaId
#define kSetHelloHaIdPath [kHomeAddr stringByAppendingString:@"/setHelloHaId"]

//获取用户二维码
//http://localhost/jlxc_php/index.php/Home/MobileApi/getUserQRCode
#define kGetUserQRCodePath [kHomeAddr stringByAppendingString:@"/getUserQRCode"]

//修改个人信息中的图片 如背景图 头像
//http://localhost/jlxc_php/index.php/Home/MobileApi/changeInformationImage
#define kChangeInformationImagePath [kHomeAddr stringByAppendingString:@"/changeInformationImage"]

//个人信息中 获取最新动态的三张图片 弃用
//http://localhost/jlxc_php/index.php/Home/MobileApi/getNewsImages
#define kGetNewsImagesPath [kHomeAddr stringByAppendingString:@"/getNewsImages"]

//个人信息中 获取最新动态的十张图片
//http://localhost/jlxc_php/index.php/Home/MobileApi/getNewsCoverList
#define kGetNewsCoverListPath [kHomeAddr stringByAppendingString:@"/getNewsCoverList"]

//个人信息中 获取来访三张头像 弃用
//http://localhost/jlxc_php/index.php/Home/MobileApi/getVisitImages
#define kGetVisitImagesPath [kHomeAddr stringByAppendingString:@"/getVisitImages"]

//个人信息中 获取好友人数和图片
//http://localhost/jlxc_php/index.php/Home/MobileApi/getFriendsImage
#define kGetFriendsImagePath [kHomeAddr stringByAppendingString:@"/getFriendsImage"]

//个人信息中 获取粉丝人数
//http://localhost/jlxc_php/index.php/Home/MobileApi/getFansCount
#define kGetFansCountPath [kHomeAddr stringByAppendingString:@"/getFansCount"]

//个人信息中 用户发布过的状态列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/userNewsList
#define kUserNewsListPath [kHomeAddr stringByAppendingString:@"/userNewsList"]

//个人信息 删除状态
//http://localhost/jlxc_php/index.php/Home/MobileApi/userNewsList
#define kDeleteNewsListPath [kHomeAddr stringByAppendingString:@"/deleteNews"]

//个人信息 查看别人的信息
//http://localhost/jlxc_php/index.php/Home/MobileApi/userNewsList
#define kPersnalInformationPath [kHomeAddr stringByAppendingString:@"/personalInfo"]

//最近来访列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getVisitList
#define kGetVisitListPath [kHomeAddr stringByAppendingString:@"/getVisitList"]

//删除来访
//http://localhost/jlxc_php/index.php/Home/MobileApi/deleteVisit
#define kDeleteVisitPath [kHomeAddr stringByAppendingString:@"/deleteVisit"]

//别人的好友列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getOtherFriendsList
#define kGetOtherFriendsListPath [kHomeAddr stringByAppendingString:@"/getOtherFriendsList"]

//共同的好友列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getCommonFriendsList
#define kGetCommonFriendsListPath [kHomeAddr stringByAppendingString:@"/getCommonFriendsList"]

//举报用户
//http://localhost/jlxc_php/index.php/Home/MobileApi/reportOffence
#define kReportOffencePath [kHomeAddr stringByAppendingString:@"/reportOffence"]

//////////////////////////////////////////IM模块//////////////////////////////////////////
//添加好友
//http://localhost/jlxc_php/index.php/Home/MobileApi/addFriend
#define kAddFriendPath [kHomeAddr stringByAppendingString:@"/addFriend"]

//删除好友
//http://localhost/jlxc_php/index.php/Home/MobileApi/deleteFriend
#define kDeleteFriendPath [kHomeAddr stringByAppendingString:@"/deleteFriend"]

//添加好友备注
//http://localhost/jlxc_php/index.php/Home/MobileApi/addRemark
#define kAddRemarkPath [kHomeAddr stringByAppendingString:@"/addRemark"]

//获取图片和名字
//http://localhost/jlxc_php/index.php/Home/MobileApi/getImageAndName
#define kGetImageAndNamePath [kHomeAddr stringByAppendingString:@"/getImageAndName"]

//是否同步好友
//http://localhost/jlxc_php/index.php/Home/MobileApi/NeedSyncFriends
#define kNeedSyncFriendsPath [kHomeAddr stringByAppendingString:@"/needSyncFriends"]

//获取好友列表 弃用
//http://localhost/jlxc_php/index.php/Home/MobileApi/getFriendsList
#define kGetFriendsListPath [kHomeAddr stringByAppendingString:@"/getFriendsList"]

// 获取关注列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getAttentList
#define kGetAttentListPath [kHomeAddr stringByAppendingString:@"/getAttentList"]

// 获取粉丝列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getFansList
#define kGetFansListPath [kHomeAddr stringByAppendingString:@"/getFansList"]

// 获取其他人的关注列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getAttentList
#define kGetOtherAttentListPath [kHomeAddr stringByAppendingString:@"/getOtherAttentList"]

// 获取其他人的关注列表
//http://localhost/jlxc_php/index.php/Home/MobileApi/getAttentList
#define kGetOtherFansListPath [kHomeAddr stringByAppendingString:@"/getOtherFansList"]

//获取全部好友
//http://localhost/jlxc_php/index.php/Home/MobileApi/getAllFriendsList
#define kGetAllFriendsListPath [kHomeAddr stringByAppendingString:@"/getAllFriendsList"]

//////////////////////////////////////////聊天室模块//////////////////////////////////////////
//http://localhost/jlxc_php/index.php/Home/MobileApi/createChatRoom
//创建聊天室
#define kCreateChatRoomPath [kHomeAddr stringByAppendingString:@"/createChatRoom"]
//http://localhost/jlxc_php/index.php/Home/MobileApi/getChatRoomList
//获取聊天室列表
#define kGetChatRoomListPath [kHomeAddr stringByAppendingString:@"/getChatRoomList"]
//获取我的聊天室列表
#define kGetMyChatRoomListPath [kHomeAddr stringByAppendingString:@"/getMyChatRoomList"]
//加入聊天室
//http://localhost/jlxc_php/index.php/Home/MobileApi/joinChatRoom
#define kJoinChatRoomPath [kHomeAddr stringByAppendingString:@"/joinChatRoom"]
//退出聊天室
//http://localhost/jlxc_php/index.php/Home/MobileApi/leaveChatRoom
#define kLeaveChatRoomPath [kHomeAddr stringByAppendingString:@"/leaveChatRoom"]
//聊天室详情
//http://localhost/jlxc_php/index.php/Home/MobileApi/chatRoomDetail
#define kChatRoomDetailPath [kHomeAddr stringByAppendingString:@"/chatRoomDetail"]
//获取聊天室头像和背景图
//http://localhost/jlxc_php/index.php/Home/MobileApi/getChatRoomTitleAndBack
#define kGetChatRoomTitleAndBackPath [kHomeAddr stringByAppendingString:@"/getChatRoomTitleAndBack"]
//获取聊天室剩余时间
//http://localhost/jlxc_php/index.php/Home/MobileApi/getChatRoomLeftTime
#define kGetChatRoomLeftTimePath [kHomeAddr stringByAppendingString:@"/getChatRoomLeftTime"]

//////////////////////////////////////////发现模块//////////////////////////////////////////
//http://localhost/jlxc_php/index.php/Home/MobileApi/getContactUser
//获取联系人用户
#define kGetContactUserPath [kHomeAddr stringByAppendingString:@"/getContactUser"]

//http://localhost/jlxc_php/index.php/Home/MobileApi/getSameSchoolList
//获取同校的人列表
#define kGetSameSchoolListPath [kHomeAddr stringByAppendingString:@"/getSameSchoolList"]

//http://localhost/jlxc_php/index.php/Home/MobileApi/findUserList
//搜索用户列表
#define kFindUserListPath [kHomeAddr stringByAppendingString:@"/findUserList"]

//http://localhost/jlxc_php/index.php/Home/MobileApi/helloHaIdExists
//判断该哈哈号是否存在
#define kHelloHaIdExistsPath [kHomeAddr stringByAppendingString:@"/helloHaIdExists"]

//http://localhost/jlxc_php/index.php/Home/MobileApi/recommendFriendsList
//推荐的人列表
#define kRecommendFriendsListPath [kHomeAddr stringByAppendingString:@"/recommendFriendsList"]

//////////////////////////////////////////圈子模块//////////////////////////////////////////
//获取联系人用户
#define kGetTopicCategoryPath [kHomeAddr stringByAppendingString:@"/getTopicCategory"]
//创建新圈子
#define kPostNewTopicPath [kHomeAddr stringByAppendingString:@"/postNewTopic"]
//获取圈子主页列表
#define kGetTopicHomeListPath [kHomeAddr stringByAppendingString:@"/getTopicHomeList"]
//获取圈子分类列表
#define kGetCategoryTopicListPath [kHomeAddr stringByAppendingString:@"/getCategoryTopicList"]
//获取圈子新闻列表
#define kGetTopicNewsListPath [kHomeAddr stringByAppendingString:@"/getTopicNewsList"]


#endif
