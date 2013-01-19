part of formula;


class BaseExpression extends BaseFormulaItem {
    List<BaseFormulaItem> _innerItems = new List<BaseFormulaItem>();
    List<BaseFormulaItem> get innerItems => _innerItems;

    Element _elem;

    BaseExpression(BaseExpression parent) : super(parent) {
        _innerItems.add(new TextLeaf(this));
    }

    /*
     *
     * elementFactory - fabric function to create element (needed function until will not be implemented dartbug.com/6282)
     *
     * */
    BaseExpression insertFormulaItem(elementFactory, TextLeaf dividedItem, int cursorPosition) {
        var rightTextPart = dividedItem.text.substring(cursorPosition);
        dividedItem.text = dividedItem.text.substring(0, cursorPosition);

        var pos = _innerItems.indexOf(dividedItem);
        _innerItems.insertRange(pos + 1, 2);
        var insertingItem = elementFactory(this);
        _innerItems[pos + 1] = insertingItem;
        _innerItems[pos + 2] = new TextLeaf(this, rightTextPart);

        render();

        return insertingItem;
    }

    Element render([klass = 'expression']) {
        if (_elem == null) {
            _elem = new DivElement();

            _elem.classes.add(klass);

            _elem.xtag = this;
        }

        _elem.children.clear();
        _elem.children.addAll(_innerItems.map((e) => e.render()));

        return _elem;
    }

    double getBaselineY() {
        return  (_getMaxHeightChild().xtag as BaseFormulaItem).getBaselineY();
    }

    int getElementHeight() {
        return _elem.clientHeight;
    }

    Element _getMaxHeightChild() {
        var maxHeightElem = _elem.children[0];
        for (var elem in _elem.children) {
            if (elem.xtag != null && elem.clientHeight > maxHeightElem.clientHeight) {
                maxHeightElem = elem;
            }
        }
        return maxHeightElem;
    }

    void realignVertical() {
        // reallign all child expressions
        for (var item in _innerItems) {
          if (item is BaseExpression) item.realignVertical();
        }

        // align by baseline
        var maxHeightElem = _getMaxHeightChild();
        var baselineY = (maxHeightElem.xtag as BaseFormulaItem).getBaselineY();
        var delta = baselineY - maxHeightElem.clientHeight / 2;
        var maxNegativeOffsetTop = 0;
        for (var elem in _elem.children) {
            if (elem == maxHeightElem){
                elem.style.top = '0';
            } else {
                var curDelta;
                if (elem.xtag is BaseFormulaItem) {
                    curDelta = (elem.xtag as BaseFormulaItem).getBaselineY() - elem.clientHeight / 2;
                } else {
                    curDelta = 0;
                }
                elem.style.top = '${delta - curDelta}px';
            }
        }

        // move down all elements if there is elements with negative top offset with respect to maxHeightElem's top
        for (var elem in _elem.children) {
            if (elem.xtag == null) continue;

            maxNegativeOffsetTop = min(elem.offsetTop - maxHeightElem.offsetTop, maxNegativeOffsetTop);
        }
        for (var elem in _elem.children) {
            var top = double.parse(elem.style.top.replaceAll('px', ''));
            elem.style.top = '${top - maxNegativeOffsetTop}px';
        }

        // fix containers height to cover all children's content
        var maxTotalHeight = 0;
        for (var elem in _elem.children) {
            if (elem.xtag == null) continue;

            var top = double.parse(elem.style.top.replaceAll('px', ''));
            if (top + elem.offsetHeight > maxTotalHeight) {
                maxTotalHeight = top + elem.offsetHeight;
            }
        }
        _elem.style.minHeight = "${maxTotalHeight}px";
    }

    void focus() {
        (_innerItems[0] as TextLeaf).focus();
    }
}
