/**
 * Extend the jsToolBar function to add the plantUML buttons to editor toolbar.
 * Needs to run after the jsToolbar function is defined and before toolbars are drawn
 *
 * The position cannot be set (see http://www.redmine.org/issues/14936 )
 */
if (typeof(jsToolBar) != 'undefined') {
    jsToolBar.prototype.elements.graphviz = {
        type: 'button',
        title: 'Add Graphviz diagramm',
        fn: {
            wiki: function () {
                // this.singleTag('{{graphviz(png)\n', '\n}}');
                this.encloseLineSelection('{{graphviz(png)\n', '\n}}')
            }
        }
    }
} else {
    throw 'could not add plantUML button to Toolbar. jsToolbar is undefined';
}
