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

        _elem.children.clear();
        _elem.children.addAll(_innerItems.map((e) => e.render()));

        return _elem;
    }

    double getBaselineY() {
        return  _elem.clientHeight / 2;
    }

    int getElementHeight() {
        return _elem.clientHeight;
    }

    void realignVertical() {
        var maxHeightElem = _elem.children[0];
        for (var elem in _elem.children) {
            if (elem.clientHeight > maxHeightElem.clientHeight) {
                maxHeightElem = elem;
            }
        }

        // align by baseline
        var baselineY = (maxHeightElem.xtag as BaseFormulaItem).getBaselineY();
        var delta = baselineY - maxHeightElem.clientHeight / 2;
        var maxNegativeOffsetTop = 0;
        for (var elem in _elem.children) {
            if (elem == maxHeightElem){
                elem.style.top = '0';
            } else {
                var curDelta = (elem.xtag as BaseFormulaItem).getBaselineY() - elem.clientHeight / 2;
                elem.style.top = '${delta - curDelta}px';
            }
        }

        // move down all elements if there is elements with negative top offset with respect to maxHeightElem's top
        for (var elem in _elem.children) {
            maxNegativeOffsetTop = min(elem.offsetTop - maxHeightElem.offsetTop, maxNegativeOffsetTop);
        }
        for (var elem in _elem.children) {
            var top = double.parse(elem.style.top.replaceAll('px', ''));
            elem.style.top = '${top - maxNegativeOffsetTop}px';
        }

        // reallign all child expressions
        for (var item in _innerItems) {
            if (item is BaseExpression) item.realignVertical();
        }

        // fix height to cover all children's content
        var maxTotalHeight = 0;
        for (var elem in _elem.children) {
            var top = double.parse(elem.style.top.replaceAll('px', ''));
            if (top + elem.offsetHeight > maxTotalHeight) {
                maxTotalHeight = top + elem.offsetHeight;
            }
        }
        _elem.style.minHeight = "${maxTotalHeight}px";
    }
}
