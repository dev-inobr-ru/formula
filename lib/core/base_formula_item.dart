part of formula;


abstract class BaseFormulaItem {
    BaseExpression _parent;
    BaseExpression get parent => _parent;

    BaseFormulaItem(BaseExpression parent) {
        _parent = parent;
    }

    Element render();

    Element renderText(text, [klass = 'text']) {
        return new DivElement()
                    ..classes.add(klass)
                    ..text = text;
    }

    double getBaselineY();
}
