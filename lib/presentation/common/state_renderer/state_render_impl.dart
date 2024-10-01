import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:location_purge_maid_finder/presentation/common/state_renderer/state_renderer.dart';

import '../../resources/string_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();

  String getMessage();
  bool showingPopUp = false;
}

// Loading State (POPUP, FULL SCREEN)

class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
      : message = message ?? AppStrings.loading;

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

class SuccessState extends FlowState {
  StateRendererType stateRendererType;
  String? message;

  SuccessState(this.stateRendererType, this.message);

  @override
  String getMessage() => message ?? AppStrings.successful;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

// CONTENT STATE

class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => "";

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.CONTENT_SCREEN_STATE;
}

// EMPTY STATE

class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.EMPTY_SCREEN_STATE;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
            showingPopUp = true;
            // showing popup dialog
            showPopUp(context, getStateRendererType(), getMessage());
            // return the content ui of the screen
            return contentScreenWidget;
          } else // StateRendererType.FULL_SCREEN_LOADING_STATE
          {
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
            // showing popup dialog

            showPopUp(context, getStateRendererType(), getMessage());
            // return the content ui of the screen
            return contentScreenWidget;
          } else // StateRendererType.FULL_SCREEN_ERROR_STATE
          {
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }
      case SuccessState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.POPUP_SUCCESS_STATE) {
            // showing popup dialog

            showPopUp(context, getStateRendererType(), getMessage());
            // return the content ui of the screen
            return contentScreenWidget;
          } else // StateRendererType.FULL_SCREEN_ERROR_STATE
          {
            return StateRenderer(
                stateRendererType: getStateRendererType(),
                message: getMessage(),
                retryActionFunction: retryActionFunction);
          }
        }

      case ContentState:
        {
          if (showingPopUp) {
            dismissDialog(context);
          }
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
              stateRendererType: getStateRendererType(),
              message: getMessage(),
              retryActionFunction: retryActionFunction);
        }
      default:
        {
          return contentScreenWidget;
        }
    }
  }

  dismissDialog(BuildContext context) {
    if (showingPopUp) {
      showingPopUp = false;

      if (_isThereCurrentDialogShowing(context)) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context, rootNavigator: true).pop(true);
        });
      }
    }
  }

  _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  showPopUp(BuildContext context, StateRendererType stateRendererType,
      String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
              stateRendererType: stateRendererType,
              message: message,
              retryActionFunction: () {},
            )));
  }
}
