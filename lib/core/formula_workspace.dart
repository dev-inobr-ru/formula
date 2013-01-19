part of formula;


class FormulaWorkspace {
    Element _rootElement;
    Toolbar _toolbar;
    FormulaArea _formulaArea;

    TextLeaf _lastTextLeaf;
    int _lastCursorPosition;

    FormulaWorkspace(String elementId) {
        _rootElement = query("#$elementId");
        _toolbar = new Toolbar();
        _formulaArea = new FormulaArea();

        initFocusManager();
    }

    void initFocusManager() {
        _rootElement.on['text_leaf_blur'].add((e) {
            e.stopImmediatePropagation();

            var elem = (e as CustomEvent).target as Element;
            _lastTextLeaf = elem.xtag;
            _lastCursorPosition = elem.selectionStart;
        });

        _rootElement.on['insert_element'].add((e) {
            e.stopImmediatePropagation();

            var insertedItem = _lastTextLeaf.parent.insertFormulaItem((e.target as Element).xtag, _lastTextLeaf, _lastCursorPosition);

            _rootElement.nodes.removeLast();
            _rootElement.nodes.add(_formulaArea.render());

            _formulaArea.realignVertical();

            insertedItem.focus();
        });
    }

    void render() {
        _rootElement.nodes.add(_toolbar.render());
        _rootElement.nodes.add(_formulaArea.render());
    }
}
