package haxe.ui.layouts;

import haxe.ui.geom.Size;

#if haxeui_expose_all
@:expose
#end
class VerticalLayout extends DefaultLayout {
    public function new() {
        super();
        _calcFullHeights = true;
    }

    private override function repositionChildren() {
        var ypos = paddingTop;
        var usableSize = this.usableSize;

        for (child in component.childComponents) {
            if (child.includeInLayout == false) {
                continue;
            }

            var xpos:Float = 0;

            switch (horizontalAlign(child)) {
                case "center":
                    xpos = ((usableSize.width - child.componentWidth) / 2) + paddingLeft + marginLeft(child) - marginRight(child);
                case "right":
                    if (child.componentWidth < component.componentWidth) {
                        xpos = component.componentWidth - (child.componentWidth + paddingRight + marginLeft(child));
                    }
                default:
                    xpos = paddingLeft + marginLeft(child);
            }

            child.moveComponent(xpos, ypos + marginTop(child));
            ypos += child.componentHeight + verticalSpacing;
        }
    }

    private override function get_usableSize():Size {
        var size:Size = super.get_usableSize();

        var visibleChildren = component.childComponents.length;
        for (child in component.childComponents) {
            if (child.includeInLayout == false) {
                visibleChildren--;
                continue;
            }

            if (child.componentHeight > 0 && (child.percentHeight == null || fixedMinHeight(child) == true)) { // means its a fixed height, ie, not a % sized control
                size.height -= child.componentHeight + marginTop(child) + marginBottom(child);
            }
        }

        if (visibleChildren > 1) {
            size.height -= verticalSpacing * (visibleChildren - 1);
        }

        if (size.height < 0) {
            size.height = 0;
        }
        return size;
    }
}