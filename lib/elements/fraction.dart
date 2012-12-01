part of formula;


class Fraction extends BaseExpression {
    BaseExpression _numerator;
    BaseExpression _denominator;

    Fraction(BaseExpression parent) : super(parent);

    void init() {
        _numerator = new BaseExpression(this);
        _denominator = new BaseExpression(this);
    }

    Element render([klass = 'expression']) {
        var divFractionElem = new DivElement();

        divFractionElem.classes.add('fraction');
        divFractionElem.elements.add(_numerator.render('numerator'));
        divFractionElem.elements.add(_denominator.render('denominator'));

        return divFractionElem;
    }
}


fractionFactory(BaseExpression parent) {
    return new Fraction(parent);
}
