part of 'cubit.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
class NFCState extends Equatable {
  final TagEntity? lastestReadTags;
  final String errorMessage;
  final bool isNFCEnabled;
  final bool isProcessing;
  final bool isWriteOperation;
  final bool isSnackBarDisplayed;
  final bool isOperationSuccessful;

  const NFCState({
    this.lastestReadTags,
    this.errorMessage = '',
    required this.isNFCEnabled,
    this.isProcessing = false,
    this.isWriteOperation = false,
    this.isSnackBarDisplayed = false,
    this.isOperationSuccessful = false,
  });

  NFCState copyWith({
    TagEntity? lastestReadTags,
    String? errorMessage,
    bool? isNFCEnabled,
    bool? isProcessing,
    bool? isWriteOperation,
    bool? isSnackBarDisplayed,
    bool? isOperationSuccessful,
  }) {
    return NFCState(
      lastestReadTags: lastestReadTags ?? this.lastestReadTags,
      errorMessage: errorMessage ?? this.errorMessage,
      isNFCEnabled: isNFCEnabled ?? this.isNFCEnabled,
      isProcessing: isProcessing ?? this.isProcessing,
      isWriteOperation: isWriteOperation ?? this.isWriteOperation,
      isSnackBarDisplayed: isSnackBarDisplayed ?? this.isSnackBarDisplayed,
      isOperationSuccessful: isOperationSuccessful ?? this.isOperationSuccessful,
    );
  }

  @override
  List<Object?> get props => [
        lastestReadTags,
        errorMessage,
        isNFCEnabled,
        isProcessing,
        isWriteOperation,
        isSnackBarDisplayed,
        isOperationSuccessful,
      ];
}
