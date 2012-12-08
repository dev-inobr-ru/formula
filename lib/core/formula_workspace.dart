part of formula;


class FormulaWorkspace {
    Element _rootElement;
    Toolbar _toolbar;
    FormulaArea _formulaArea;

    TextLeaf _lastTextLeaf;

    FormulaWorkspace(String elementId) {
        _rootElement = query("#$elementId");
        _toolbar = new Toolbar();
        _formulaArea = new FormulaArea();

        initFocusManager();
    }

    void initFocusManager() {
        _rootElement.on['text_leaf_blur'].add((e) {
            e.stopImmediatePropagation();

            _lastTextLeaf = ((e as CustomEvent).target as Element).xtag;
        });

        _rootElement.on['insert_element'].add((e) {
            e.stopImmediatePropagation();

            _lastTextLeaf.parent.insertFormulaElement((e.target as Element).xtag, _lastTextLeaf);

            _rootElement.nodes.removeLast();
            _rootElement.nodes.add(_formulaArea.render());

            _formulaArea.realignVertical();
        });
    }

    void render() {
        _rootElement.nodes.add(_toolbar.render());
        _rootElement.nodes.add(_formulaArea.render());
    }
}
