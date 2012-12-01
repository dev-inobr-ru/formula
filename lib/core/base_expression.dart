part of formula;


class BaseExpression extends BaseFormulaItem {
    List<BaseFormulaItem> _innerItems = new List<BaseFormulaItem>();
    List<BaseFormulaItem> get innerItems => _innerItems;

    BaseExpression(BaseExpression parent) : super(parent) {
        init();
    }

    void init() {
        _innerItems.add(new TextLeaf(this));
    }

    /*
     *
     * elementFactory - fabric function to create element (needed function until will not be implemented dartbug.com/6282)
     *
     * */
    void insertFormulaElement(elementFactory, TextLeaf dividedItem) {
        var pos = _innerItems.indexOf(dividedItem);
        _innerItems.insertRange(pos + 1, 2);
        _innerItems[pos + 1] = elementFactory(this);
        _innerItems[pos + 2] = new TextLeaf(this);
    }

    Element render([klass = 'expression']) {
        var divElem = new DivElement();

        divElem.classes.add(klass);
        divElem.elements.addAll(_innerItems.map((e) => e.render()));

        return divElem;
    }
}


baseExpressionFactory(BaseExpression parent) {
    return new BaseExpression(parent);
}