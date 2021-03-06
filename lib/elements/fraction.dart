part of formula;


class Fraction extends BaseExpression {
    BaseExpression _numerator;
    BaseExpression _denominator;

    Element _elem;

    Fraction(BaseExpression parent) : super(parent){
        _numerator = new BaseExpression(this);
        _denominator = new BaseExpression(this);
    }

    Element render([klass = 'expression']) {
        if (_elem == null) {
            _elem = new DivElement();

            _elem.classes.add('fraction');
            _elem.children.add(_numerator.render('numerator'));
            _elem.children.add(_denominator.render('denominator'));

            _elem.xtag = this;
        }

        return _elem;
    }

    double getBaselineY() {
        return _numerator.getElementHeight().toDouble();
    }

    void realignVertical() {
        _numerator.realignVertical();
        _denominator.realignVertical();
    }

    void focus() {
        _numerator.focus();
    }
}


fractionFactory(BaseExpression parent) {
    return new Fraction(parent);
}
