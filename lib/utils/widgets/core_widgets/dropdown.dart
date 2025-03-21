import 'dart:developer';

import 'package:fairway/export.dart';
import 'package:fairway/utils/widgets/core_widgets/dropdown_row.dart';
import 'package:fairway/utils/widgets/core_widgets/loading_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class FairwayDropDown extends StatefulWidget {
  const FairwayDropDown({
    required this.labelText,
    required this.dataLoader,
    required this.displayKey,
    required this.controller,
    this.initialValue,
    this.prefixPath,
    this.onSelected,
    this.onFieldTap,
    super.key,
  });

  final String? initialValue;
  final String labelText;
  final Future<List<Map<String, String>>> Function() dataLoader;
  final String displayKey;
  final void Function(Map<String, String>)? onSelected;
  final TextEditingController controller;
  final String? prefixPath;
  final void Function()? onFieldTap;

  @override
  State<FairwayDropDown> createState() => _FairwayDropDownState();
}

class _FairwayDropDownState extends State<FairwayDropDown> {
  bool _isOpen = false;
  List<Map<String, String>> _filteredData = [];
  List<Map<String, String>>? _cachedData;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _valueChanged = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
      _searchController.text = widget.initialValue!;
      _valueChanged = false;
    }

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _filterData() {
    if (_cachedData == null) return;
    setState(() {
      _filteredData = _cachedData!
          .where(
            (item) => item[widget.displayKey]!.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  Future<void> _loadData() async {
    if (_cachedData != null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await widget.dataLoader();
      _cachedData = data;
      _filteredData = List.from(data);
    } catch (e) {
      log('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectItem(Map<String, String> item) {
    setState(() {
      widget.controller.text = item[widget.displayKey]!;
      _searchController.text = item[widget.displayKey]!;
      _isOpen = false;
      _valueChanged = true;
    });
    if (widget.onSelected != null) {
      widget.onSelected!(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.isNotEmpty;
    final isFocused = _focusNode.hasFocus;
    final setEnabledColor = isFocused || hasText;

    final borderColor =
        _valueChanged ? AppColors.greenPrimary : AppColors.disabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: GoogleFonts.urbanist(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            setState(() {
              _isOpen = !_isOpen;
            });
            if (_isOpen) {
              _focusNode.requestFocus();
              await _loadData();
            } else {
              _focusNode.unfocus();
              _searchController.clear();
            }
          },
          child: Container(
            height: _isOpen ? 250 : 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_isOpen ? 24 : 100),
              border: Border.all(
                color: setEnabledColor ? borderColor : AppColors.disabled,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (widget.prefixPath != null) ...[
                        SvgPicture.asset(
                          widget.prefixPath ?? '',
                          colorFilter: setEnabledColor
                              ? const ColorFilter.mode(
                                  AppColors.greenPrimary,
                                  BlendMode.srcIn,
                                )
                              : null,
                        ),
                      ],
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          cursorWidth: 1,
                          decoration: InputDecoration(
                            hintText: widget.labelText.toLowerCase(),
                            hintStyle: GoogleFonts.urbanist(
                              color: AppColors.disabled,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            _filterData();
                          },
                          style: GoogleFonts.urbanist(
                            color: AppColors.black,
                          ),
                          onTap: () async {
                            setState(() {
                              _isOpen = !_isOpen;
                            });
                            if (_isOpen) {
                              _focusNode.requestFocus();
                              await _loadData();
                            } else {
                              _focusNode.unfocus();
                            }
                            widget.onFieldTap?.call();
                          },
                        ),
                      ),
                      SvgPicture.asset(
                        _isOpen
                            ? AssetPaths.arrowUpIcon
                            : AssetPaths.arrowDownIcon,
                        colorFilter: setEnabledColor
                            ? const ColorFilter.mode(
                                AppColors.greenPrimary,
                                BlendMode.srcIn,
                              )
                            : null,
                      ),
                    ],
                  ),
                  if (_isOpen && _filteredData.isNotEmpty) ...[
                    const Divider(
                      color: AppColors.textFieldBorder,
                      thickness: 1,
                      height: 1,
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 80),
                        child: LoadingWidget(),
                      )
                    else
                      Expanded(
                        child: RawScrollbar(
                          thumbColor: AppColors.textFieldBorder,
                          radius: const Radius.circular(50),
                          thumbVisibility: true,
                          mainAxisMargin: 8,
                          controller: _scrollController,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: _filteredData.length,
                            itemBuilder: (context, index) {
                              final item = _filteredData[index];
                              return DropdownRow(
                                dropdownText: item[widget.displayKey]!,
                                isSelected: widget.controller.text ==
                                    item[widget.displayKey]!,
                                onTap: () {
                                  _selectItem(item);
                                  _focusNode.unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
