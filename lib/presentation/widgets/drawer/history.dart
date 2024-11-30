import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/mappers/tag.dart';
import '../../blocs/NFC.dart';
import '../label/card.dart';

class HistoryDrawerWidget extends StatelessWidget {
  const HistoryDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NFCCubit, NFCState>(
      builder: (context, state) {
        final tags = state.savedTags ?? [];
        final reversedTags = tags.reversed.toList();
        return Container(
          width: 200,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: reversedTags.length,
            itemBuilder: (context, index) {
              final tag = reversedTags[index];
              final card = TagMapper.toCardEntity(tag);
              return CardLabelWidget(
                card: card,
                lightTheme: true,
              );
            },
          ),
        );
      },
    );
  }
}
