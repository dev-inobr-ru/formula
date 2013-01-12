part of formula;


class TextLeaf extends BaseFormulaItem {
    String text = '';

    TextLeaf(BaseExpression parent) : super(parent);

    InputElement _elem;

    Element render() {
        if (_elem == null) {
            initElem();
        }

        if (this.text.length == 0) _elem.classes.add('empty');

        return _elem;
    }

    void initElem() {
        _elem = new InputElement(type: 'text');
        _elem.classes.add('textLeaf');

        _elem.on.input.add((e) {
            if (_elem.value.length > 0) {
                _elem.classes.remove('empty');
                _elem.classes.add('active');

                _elem.computedStyle.then((style) {
                    var testElem = new SpanElement();
                    testElem.style.position = "fixed";
                    testElem.style.top = "-9999px";
                    testElem.style.left = "-9999px";
                    testElem.style.width = 'auto';
                    testElem.style.fontSize = style.fontSize;
                    testElem.style.fontFamily = style.fontFamily;
                    testElem.style.fontFamily = style.fontFamily;
                    testElem.style.fontWeight = style.fontWeight;
                    testElem.style.letterSpacing = style.letterSpacing;
                    testElem.style.whiteSpace = 'nowrap';
                    _elem.document.$dom_body.children.add(testElem);
                    // multiple regular spaces are combined into one when element is rendered
                    testElem.innerHtml = _elem.value.replaceAll(' ', '&nbsp;');
                    var rect = testElem.getBoundingClientRect();
                    _elem.style.width = "${rect.width}px";
                    testElem.remove();
                });
            } else {
                _elem.style.removeProperty('width');
                _elem.classes.add('empty');
                _elem.classes.remove('active');
            }
        });

        _elem.on.blur.add((e) {
            _elem.$dom_dispatchEvent(new CustomEvent('text_leaf_blur', true, true));
        });

        _elem.xtag = this;
    }

    double getBaselineY() {
        return  _elem.clientHeight / 2;
    }

    void focus() {
        _elem.focus();
    }
}
