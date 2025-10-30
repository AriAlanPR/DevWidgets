import 'package:flutter/material.dart';

/// Un acordeón simple basado en ExpansionPanelList.
///
/// Permite mostrar un encabezado y un cuerpo colapsable con un estilo limpio.
/// Use [initiallyExpanded] para definir el estado inicial.
class Accordion extends StatefulWidget {
  final String title;
  final bool initiallyExpanded;
  final Color backgroundColor;
  final Widget child;
  final Widget? leading;

  const Accordion({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.backgroundColor = Colors.transparent,
    this.leading,
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !isExpanded;
          });
        },
        animationDuration: const Duration(milliseconds: 250),
        elevation: 0,
        children: [
          ExpansionPanel(
            backgroundColor: widget.backgroundColor,
            canTapOnHeader: true,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: widget.leading ?? Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                title: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
              child: widget.child,
            ),
            isExpanded: _isExpanded,
          ),
        ],
      ),
    );
  }
}
