part of formula;


class FormulaArea {
    BaseExpression _expression;
    BaseExpression get expression => _expression;

    FormulaArea() {
        _expression = new BaseExpression(null);
    }

    Element render() {
        var divElem = new DivElement();
        divElem.classes.add('result');
        divElem.elements.add(new Element.html('<h2>Result</h2>'));

        divElem.elements.add(this._expression.render());

        return divElem;
    }

    void realignVertical() {
        _expression.realignVertical();
    }
}
