import 'package:chat_server/controllers/chats_controller/chats_controller.dart';
import 'package:chat_server/middleware/middleware_extension.dart';
import 'package:chat_server/middleware/validator_middleware.dart';
import 'package:chat_server/routes/server_route.dart';
import 'package:chat_server/utils/request_validator.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

/// A route handler for chat-related endpoints.
class ChatsRoute extends ServerRoute {
  /// Creates an instance of [ChatsRoute] with the necessary controller and middlewares.
  ChatsRoute({
    required this.controller,
    super.middlewares,
  });

  /// The controller that handles chat logic.
  final ChatsController controller;

  @override
  String get name => 'chats';

  @override
  Router configureRouter(Router router) {
    // Validator parameters for the create endpoint.
    const createParams = <ValidatorParameter<String>>[
      ValidatorParameter(name: 'title'),
      ValidatorParameter(name: 'description', nullable: true),
      ValidatorParameter(name: 'chatType', nullable: true),
    ];

    // Middleware to validate create request body.
    final Middleware createValidator = validatorMiddleware(
      bodyParams: createParams,
    );

    // Validator parameters for the delete endpoint.
    const deleteParams = <String>['chatId'];

    // Middleware to validate delete request parameters.
    final Middleware deleteValidator = validatorMiddleware(
      requestParams: deleteParams,
    );

    // Validator parameters for the update endpoint.
    const updateParams = <ValidatorParameter<Object>>[
      ValidatorParameter<int>(name: 'chatId'),
      ValidatorParameter<String>(name: 'title', nullable: true),
      ValidatorParameter<String>(name: 'description', nullable: true),
      ValidatorParameter<String>(name: 'chatType', nullable: true),
    ];

    // Middleware to validate update request body.
    final Middleware updateValidator = validatorMiddleware(
      bodyParams: updateParams,
    );

    // Validator parameters for the search endpoint.
    const searchParams = <String>['title'];

    // Middleware to validate search request parameters.
    final Middleware searchValidator = validatorMiddleware(
      requestParams: searchParams,
    );

    // Validator parameters for join and leave endpoints.
    const params = <ValidatorParameter<int>>[
      ValidatorParameter(name: 'chatId'),
    ];

    // Middleware to validate join and leave request body.
    final Middleware validator = validatorMiddleware(
      bodyParams: params,
    );

    const updateParticipantParams = <ValidatorParameter<Object>>[
      ValidatorParameter<int>(name: 'chatId'),
      ValidatorParameter<int>(name: 'targetId'),
      ValidatorParameter<String>(name: 'role'),
    ];

    final Middleware updateParticipantValidator = validatorMiddleware(
      bodyParams: updateParticipantParams,
    );

    const pinAndArchiveParams = <String>['chatId'];

    final Middleware pinAndArchiveValidator = validatorMiddleware(
      requestParams: pinAndArchiveParams,
    );

    return router
      // Route to get all chats.
      ..get('/', controller.getAll)
      // Route to create a chat, protected by create validation middleware.
      ..postMw('/create', controller.create, [createValidator])
      // Route to delete a chat, protected by delete validation middleware.
      ..deleteMw('/delete', controller.delete, [deleteValidator])
      // Route to update a chat, protected by update validation middleware.
      ..putMw('/update', controller.update, [updateValidator])
      // Route to join a chat, protected by validation middleware.
      ..postMw('/join', controller.join, [validator])
      // Route to leave a chat, protected by validation middleware.
      ..postMw('/leave', controller.leave, [validator])
      // Route to search for chats, protected by search validation middleware.
      ..getMw('/search', controller.search, [searchValidator])
      // Route to pin chat, protected by pinAndArchive validation middleware.
      ..postMw('/pin', controller.pinChat, [pinAndArchiveValidator])
      // Route to unpin chat, protected by pinAndArchive validation middleware.
      ..deleteMw('/unpin', controller.unpinChat, [pinAndArchiveValidator])
      // Route to archive chat, protected by pinAndArchive validation middleware.
      ..postMw('/archive', controller.archiveChat, [pinAndArchiveValidator])
      // Route to unarchive chat, protected by pinAndArchive validation middleware.
      ..deleteMw('/unarchive', controller.unarchiveChat, [
        pinAndArchiveValidator,
      ])
      // Route to update a chat participant, protected by update validation middleware.
      ..putMw(
        '/update-participant',
        controller.updateParticipant,
        [updateParticipantValidator],
      );
  }
}
