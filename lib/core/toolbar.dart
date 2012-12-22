part of formula;


BaseExpression baseExpression(BaseExpression parent) {
    return new BaseExpression(parent);
}


class Toolbar {
    Element render() {
        var divElem = new DivElement();
        divElem.classes.add('toolbar');
        divElem.children.add(new Element.html('<h2>Toolbar</h2>'));

        var fractionBtn = new ButtonElement();
        fractionBtn.text = 'Fraction';
        fractionBtn.classes.add('btn btn-primary');

        fractionBtn.on.click.add((e) {
            fractionBtn.$dom_dispatchEvent(new CustomEvent('insert_element', true, true));
        });

        fractionBtn.xtag = fractionFactory;

        divElem.children.add(fractionBtn);

        return divElem;
    }
}
