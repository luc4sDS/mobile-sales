import 'package:flutter/material.dart';
import 'package:mobile_sales/core/configs/theme/app_colors.dart';

class ListSearchModal<T> extends StatefulWidget {
  final List<T> data;
  final String Function(T) extractLabel;
  final int selectedIndex;
  final Function(int) onSelect;

  const ListSearchModal({
    super.key,
    required this.data,
    required this.extractLabel,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<ListSearchModal<T>> createState() => _ListSearchModalState();
}

class _ListSearchModalState<T> extends State<ListSearchModal<T>> {
  void handleOpenDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => ListSearchContainer<T>(
        data: widget.data,
        extractLabel: widget.extractLabel,
        selectedIndex: widget.selectedIndex,
        onSelect: widget.onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: () => handleOpenDialog(),
        child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.lightSecondaryBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.data.isEmpty || widget.selectedIndex == -1
                    ? ''
                    : widget.extractLabel(widget.data[widget.selectedIndex]),
                overflow: TextOverflow.ellipsis,
              ),
            )),
      ),
    );
  }
}

class ListSearchContainer<T> extends StatefulWidget {
  final List<T> data;
  final String Function(T) extractLabel;
  final int selectedIndex;
  final Function(int) onSelect;

  const ListSearchContainer({
    super.key,
    required this.data,
    required this.extractLabel,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  State<ListSearchContainer<T>> createState() => _ListSearchContainerState();
}

class _ListSearchContainerState<T> extends State<ListSearchContainer<T>> {
  final _pesquisaCte = TextEditingController();
  late int _currentSelectedRecord;

  @override
  void initState() {
    super.initState();
    _currentSelectedRecord = widget.selectedIndex;
  }

  bool shouldShow(String text) {
    return text.toLowerCase().contains(_pesquisaCte.text.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        decoration: const BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (_) => setState(() {}),
                controller: _pesquisaCte,
                decoration: const InputDecoration(
                  label: Text('Pesquisar'),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: widget.data.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      widget.onSelect(index);
                      setState(() {
                        _currentSelectedRecord = index;
                      });
                    },
                    child: shouldShow(widget.extractLabel(widget.data[index]))
                        ? Container(
                            decoration: BoxDecoration(
                                color: index == _currentSelectedRecord
                                    ? AppColors.primary
                                    : Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.extractLabel(widget.data[index]),
                                style: TextStyle(
                                    color: index == _currentSelectedRecord
                                        ? Colors.white
                                        : AppColors.lightPrimaryText),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
