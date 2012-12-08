part of formula;


class BaseExpression extends BaseFormulaItem {
    List<BaseFormulaItem> _innerItems = new List<BaseFormulaItem>();
    List<BaseFormulaItem> get innerItems => _innerItems;

    Element _elem;

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

        render();
    }

    Element render([klass = 'expression']) {
        if (_elem == null) {
            _elem = new DivElement();

            _elem.classes.add(klass);
        }

        _elem.elements.clear();
        _elem.elements.addAll(_innerItems.map((e) => e.render()));

        return _elem;
    }

    double getBaselineY() {
        return  _elem.clientHeight / 2;
    }

    int getElementHeight() {
        return _elem.clientHeight;
    }

    void realignVertical() {
        var maxHeightElem = _elem.elements[0];
        for (var elem in _elem.elements) {
            if (elem.clientHeight > maxHeightElem.clientHeight) {
                maxHeightElem = elem;
            }
        }

        var baselineY = (maxHeightElem.xtag as BaseFormulaItem).getBaselineY();
        var delta = baselineY - maxHeightElem.clientHeight / 2;
        var baseOffsetTop = maxHeightElem.offsetTop;

        var maxNegativeOffsetTop = 0;
        for (var elem in _elem.elements) {
            if (elem == maxHeightElem || elem.clientHeight == maxHeightElem.clientHeight){
                elem.style.top = '0';
            } else {
                var curDelta = (elem.xtag as BaseFormulaItem).getBaselineY() - elem.clientHeight / 2;
                elem.style.top = '${delta - curDelta}px';

                maxNegativeOffsetTop = min(elem.offsetTop - baseOffsetTop, maxNegativeOffsetTop);
            }
        }
        for (var elem in _elem.elements) {
            var top = double.parse(elem.style.top.replaceAll('px', ''));
            elem.style.top = '${top - maxNegativeOffsetTop}px';
        }

        for (var item in _innerItems) {
            if (item is BaseExpression) item.realignVertical();
        }
    }
}
