import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/res/config_imports.dart';
import '../../../core/extensions/num.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_request.dart';
import '../../../core/network/network_service.dart';

import '../enums.dart';
import 'chat_actions/imports.dart';
import 'chat_actions/no_action.dart';
import 'models/chat_model.dart';
import 'models/request_model.dart';

class ChatsData{
  static ChatModel? data;
  static Future<ChatModel> getChatMessages({
    required RequestModel requestModel
  })async{
    data = (await injector<NetworkService>().callApi(
          NetworkRequest(
            method: RequestMethod.post,
            path: ApiConstants.startChat,
            body: requestModel.toJson()
          ),
          mapper: (data) => ChatModel.fromJson(data)
      )).data;

    final newList = data?.room?.messages?.data?.reversed.toList();

    return data!.copyWith(
      room: data?.room?.copyWith(
        messages: data?.room?.messages?.copyWith(
          data: newList
        ))
    );
  }

  static ChatActions manageSuccessState(ChatModel data, {
    required BuildContext context,
    required RequestModel requestModel,
  }) {
    final timer = data.matchRequest!.timer;
    final stage = data.matchRequest!.stage!.value!.getCurrentStageAsStagesEnum;
    final userStatus = data.matchRequest!.userRequestStatus!.getUserRequestStatusAsEnum;
    final matchRequestEnum = data.matchRequest!.userRequest!.getMatchRequestAsEnum;
    final currentTips = data.matchRequest!.tipsPage!.currentStageTips;
    final MatchRequest matchRequest = data.matchRequest!;

    // tips
    log('the tips is $currentTips');
    log('the tips is ${currentTips.isNoPage}');
    if(!currentTips.isNoPage){
      log('the tips is $currentTips');
      return TipsAction(
          context: context,
          currentTips: currentTips,
          requestModel: requestModel
      );
    }


    // based stage
    if(stage.isParentsExchangeNumber){
      return StageAction(context: context, stage: stage);
    }

    // acceptance - payment
    if(!userStatus.isUndefined){
      return UserStatusAction(
          context: context,
          status: userStatus,
          request: matchRequestEnum,
          requestName: matchRequest.requestName!,
          stage: stage,
          matchReqId: matchRequest.id!,
          requestModel: requestModel
      );
    }

    if(stage.isParentIndividualConversation){
      return NoAction();
    }

    // timer
    if(timer.isEqualZero){
      return TimerAction(
          context: context,
          requestModel: requestModel,
          stage: stage
      );
    }

    return NoAction();
  }

}