if (!xslt2js) xslt2js = {};

function xslt2js.Context() {
    this.defaultNamespaceMappings = {};
}

xslt2js.Context.prototype.addDefaultNamespaceMapping = function(prefix, namespace) {
    this.defaultNamespaceMappings[prefix] = namespace;
}

xslt2js.Context.prototype.getDefaultNamespaceMappings = function() {
    return this.defaultNamespaceMappings;
}



