part of formula;


abstract class BaseFormulaItem {
    BaseExpression _parent;
    BaseExpression get parent => _parent;

    BaseFormulaItem(BaseExpression parent) {
        _parent = parent;
    }

    Element render();
}
