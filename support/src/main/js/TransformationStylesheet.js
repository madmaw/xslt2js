function TransformationStylesheet() {
    this.defaultTemplates = [];
    this.modalTemplates = {};
    this.namedTemplates = {};
}

TransformationStylesheet.prototype.addNamedTemplate = function(name, transformationFunction) {
    this.namedTemplates[name] = transformationFunction;
}

TransformationStylesheet.prototype.addTemplate = function(matchFunction, transformationFunction, mode, priority) {
    var templates;
    if( mode == null ) {
        templates = this.defaultTemplates;
    } else {
        templates = this.modalTemplates[mode];
        if( templates == null ) {
            templates = [];
            this.modalTemplates[mode] = templates;
        }
    }
    if( priority == null ) {
        priority = 0;
    }
    // TODO sort based on priority
    templates.push(
        {
            priority: priority,
            match: matchFunction,
            transformation: transformationFunction
        }
    );
}

