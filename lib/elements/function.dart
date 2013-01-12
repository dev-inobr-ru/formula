part of formula;


class Function extends BaseExpression {
    String _name;
    BaseExpression _argument;

    Element _elem;

    Function(BaseExpression parent, String name) : super(parent) {
        _name = name;
        _argument = new BaseExpression(this);
    }

    Element _renderBracket(height, position) {
        var width = (sqrt(height)).round();

        var bracket = new svg.SvgElement.tag('svg')
                              ..attributes = {
                                  'width': width,
                                  'height': height,
                                  'version': '1.1'
                              }
                              ..classes.add('bracket');
        var xstart = position == 'left' ? width : 0;
        var x1 = position == 'left' ? 0 : width;
        var y1 = (height * 0.2).round();
        var x2 = position == 'left' ? 0 : width;
        var y2 = (height * 0.8).round();
        var xend = position == 'left' ? width : 0;
        bracket.children.add(new svg.SvgElement.svg('<path d="M$xstart,0 C$x1,$y1 $x2,$y2 $xend,$height"></path>')..classes.add('bracket-line'));
        return bracket;
    }

    _redrawBrackets(height) {
        _elem.children[1] = _renderBracket(height, 'left');
        _elem.children[3] = _renderBracket(height, 'right');
    }

    Element render([klass = 'expression']) {
        if (_elem == null) {
            _elem = new DivElement();

            _elem.classes.add('function');
            _elem.children.add(renderText(_name));
            _elem.children.add(_renderBracket(20, 'left'));
            _elem.children.add(_argument.render('argument'));
            _elem.children.add(_renderBracket(20, 'right'));

            _elem.xtag = this;
        }

        return _elem;
    }

    double getBaselineY() {
        return _argument.getBaselineY();
    }

    void realignVertical() {
        _argument.realignVertical();
        super.realignVertical();
        _redrawBrackets(_argument.getElementHeight());
    }

    void focus(){
        _argument.focus();
    }
}


sinFactory(BaseExpression parent) {
    return new Function(parent, 'sin');
}
