function callAdjust(graph, cell) {
	var links = graph.getConnectedLinks(cell);
	var adjusted = {};
	
	for (var link in links) {
		var other;
		if (links[link].get('source').id === cell.id) {
			other = links[link].get('target').id;
		} else {
			other = links[link].get('source').id;
		}
		
		if (other in adjusted) {
			continue;
		}
		adjusted[other] = 1;
		
		adjustVertices(graph, links[link]);
	}
}

function adjustVertices(graph, cell) {
	// If the cell is a view, find its model.
	cell = cell.model || cell;

	if (cell instanceof joint.dia.Element) {
		callAdjust(graph, cell);
		return;
	}

	// The cell is a link. Let's find its source and target models.
	var srcId = cell.get('source').id || cell.previous('source').id;
	var trgId = cell.get('target').id || cell.previous('target').id;

	// If one of the ends is not a model, the link has no siblings.
	if (!srcId || !trgId) return;

	var siblings = _.filter(graph.getLinks(), function(sibling) {

		var _srcId = sibling.get('source').id;
		var _trgId = sibling.get('target').id;

		return (_srcId === srcId && _trgId === trgId) || (_srcId === trgId && _trgId === srcId);
	});

	switch (siblings.length) {

	case 0:
		// The link was removed and had no siblings.
		break;

	case 1:
		// There is only one link between the source and target. No vertices needed.
		cell.unset('vertices');
		break;

	default:
		// There is more than one siblings. We need to create vertices.
		var memSign = srcId < trgId ? 1 : -1;
		// First of all we'll find the middle point of the link.
		var srcCenter = graph.getCell(srcId).getBBox().center();
		var trgCenter = graph.getCell(trgId).getBBox().center();
		var midPoint = g.line(srcCenter, trgCenter).midpoint();

		// Then find the angle it forms.
		var theta = srcCenter.theta(trgCenter);

		// This is the maximum distance between links
		var gap = 30;

		_.each(siblings, function(sibling, index) {

			// We want the offset values to be calculated as follows 20, 20, 40, 40, 60, 60 ..
			var offset = gap * Math.ceil((index + 1) / 2);

			// Now we need the vertices to be placed at points which are 'offset' pixels distant
			// from the first link and forms a perpendicular angle to it. And as index goes up
			// alternate left and right.
			//
			//  ^  odd indexes 
			//  |
			//  v  even indexes
			var sign = (index % 2 ? 1 : -1) * memSign;
			var angle = g.toRad(theta + sign * 90);

			// We found the vertex.
			var vertex = g.point.fromPolar(offset, angle, midPoint);

			sibling.set('vertices', [{ x: vertex.x, y: vertex.y }]);
		});
	}
};

joint.shapes.pathfinder = {};
joint.shapes.pathfinder.EditableStatus = joint.shapes.basic.Rect.extend({
	defaults: joint.util.deepSupplement({
		type: 'pathfinder.EditableStatus',
		attrs: {
			rect: { stroke: 'none', 'fill-opacity': 0 }
		}
	}, joint.shapes.basic.Rect.prototype.defaults)
});

joint.shapes.pathfinder.EditableStatusView = joint.dia.ElementView.extend({
	template: [
		'<div class="editableElementDiv">',
		'<button class="delete">x</button>',
		'<div class="elementLabel"><label class="labelCaption"/></div>',
		'<div class="editLabel">',
		'<button class="editEnable" type="button">Edit</button>',
		'<input class="editCaption" type="text"/>',
		'<button class="editDone" type="button">OK</button>',
		'</div>',
		'</div>'
	].join(''),
	
	initialize: function() {
		_.bindAll(this, 'updateBox');
		joint.dia.ElementView.prototype.initialize.apply(this, arguments);
		this.$box = $(_.template(this.template)());
		// Prevent paper from handling pointerdown: in find we specify the list of tags for input
		this.$box.find('input').on('mousedown click', function(evt) { evt.stopPropagation(); });
		
		this.$box.find('.editCaption').hide();
		this.$box.find('.editDone').hide();
		
		// store inputed value in model
		this.$box.find('.editDone').on('click', _.bind(function(evt) {
			this.model.set('text', this.$box.find('.editCaption').val());
			
			this.$box.find('.editEnable').show();
			this.$box.find('.editCaption').hide();
			this.$box.find('.editDone').hide();
		}, this));
		
		this.$box.find('.editEnable').on('click', _.bind(function(evt) {
			this.$box.find('.editEnable').hide();
			
			var ed = this.$box.find('.editCaption');
			ed.val(this.model.get('text'));
			ed.show();
			this.$box.find('.editDone').show();
		}, this));
		
		this.$box.find('.delete').on('click', _.bind(this.model.remove, this.model));
		
		// Update the box position whenever the underlying model changes.
		this.model.on('change', this.updateBox, this);
		// Remove the box when the model gets removed from the graph.
		this.model.on('remove', this.removeBox, this);

		this.updateBox();
	},
	
	render: function() {
		joint.dia.ElementView.prototype.render.apply(this, arguments);
		this.paper.$el.prepend(this.$box);
		this.updateBox();
		return this;
	},
	
	updateBox: function() {
		// Set the position and dimension of the box so that it covers the JointJS element.
		var bbox = this.model.getBBox();
		
		// Example of updating the HTML with a data stored in the cell model.
		this.$box.find('.labelCaption').text(this.model.get('text'));
		this.$box.css({ width: bbox.width, height: bbox.height, left: bbox.x, top: bbox.y, transform: 'rotate(' + (this.model.get('angle') || 0) + 'deg)' });
	},
	removeBox: function(evt) {
		this.$box.remove();
	}
});

joint.shapes.pathfinder.SelfLinkObj = joint.shapes.basic.Circle.extend({
	defaults: joint.util.deepSupplement({
		type: 'pathfinder.SelfLinkObj',
		attrs: {
			rect: { stroke: 'none', 'fill-opacity': 0 }
		}
	}, joint.shapes.basic.Circle.prototype.defaults)
});

joint.shapes.pathfinder.SelfLinkObjView = joint.dia.ElementView.extend({
	template: [
	    '<div class="selfLinkDiv">',
		'<button class="delete">x</button>',
		'<div class="selfLinkLabel"><label class="labelCaption"/></div>',
		'</div>'
	].join(''),
	
	initialize: function() {
		_.bindAll(this, 'updateBox');
		joint.dia.ElementView.prototype.initialize.apply(this, arguments);
		this.$box = $(_.template(this.template)());
		// Prevent paper from handling pointerdown: in find we specify the list of tags for input
		this.$box.find('input').on('mousedown click', function(evt) { evt.stopPropagation(); });
		this.$box.find('.delete').on('click', _.bind(this.model.remove, this.model));
		
		// Update the box position whenever the underlying model changes.
		this.model.on('change', this.updateBox, this);
		// Remove the box when the model gets removed from the graph.
		this.model.on('remove', this.removeBox, this);

		this.updateBox();
	},
	
	render: function() {
		joint.dia.ElementView.prototype.render.apply(this, arguments);
		this.paper.$el.prepend(this.$box);
		this.updateBox();
		return this;
	},
	
	updateBox: function() {
		// Set the position and dimension of the box so that it covers the JointJS element.
		var bbox = this.model.getBBox();
		
		// Example of updating the HTML with a data stored in the cell model.
		this.$box.find('.labelCaption').text(this.model.get('text'));
		this.$box.css({ width: bbox.width, height: bbox.height, left: bbox.x, top: bbox.y, transform: 'rotate(' + (this.model.get('angle') || 0) + 'deg)' });
	},
	removeBox: function(evt) {
		this.$box.remove();
	}
});

joint.shapes.pathfinder.Link =  joint.dia.Link.extend({
    defaults: {
        type: 'pathfinder.Link',
        attrs: { '.marker-target' : { 'd' :  'M 10 0 L 0 5 L 10 10 z' }},
		smooth: true
    }
});

function saveXY(cellView, evt, x, y) {
	cellView.model.prevX = x;
	cellView.model.prevY = y;
}

function connectByDrop(graph, cellView, evt, x, y) {
	if (cellView.model instanceof joint.dia.Link) return;
	
    var elementBelow = graph.get('cells').find(function(cell) {
        if (cell instanceof joint.dia.Link) return false; // Not interested in links.
        if (cell.id === cellView.model.id) return false; // The same element as the dropped one.
        if (cell.getBBox().containsPoint(g.point(x, y))) {
            return true;
        }
        return false;
    });
    
    var opt = {};
    opt.inbound = true;
    if (elementBelow && !graph.isNeighbor(elementBelow, cellView.model, opt)) {
    	var connName = null;
    	var connId = null;
    	while (connName == null) {
    		connName = window.prompt("Enter connection name", "");
    		if (connName != null) {
    			connId = cellView.model.id + "_" + elementBelow.id + "_" + name.toUpperCase().replace(/\ /g, "_");
    		}
    	}
    	
        graph.addCell(new joint.shapes.pathfinder.Link({
        	id : connId,
            source: { id: cellView.model.id }, 
            target: { id: elementBelow.id },
            labels: [{
            	position: 0.5,
            	attrs: {
            		text: { text: connName }
            	}
            }]
        }));

        var xBefore = cellView.model.prevX;
        var yBefore = cellView.model.prevY;
        if (typeof xBefore !== 'undefined' && typeof xBefore !== 'undefined') {
        	cellView.model.translate(xBefore - x, yBefore - y);
        }
        return;
    }
    
    if (elementBelow) {    	
        var xBefore = cellView.model.prevX;
        var yBefore = cellView.model.prevY;
        if (typeof xBefore !== 'undefined' && typeof xBefore !== 'undefined') {
        	cellView.model.translate(xBefore - x, yBefore - y);
        }
    }
}

function selfConnect(graph, cellView, evt, x, y) {
	if (cellView.model instanceof joint.dia.Link) return;
	
	var selfId = '__SELF_' + cellView.model.id;
    var selfConn = graph.get('cells').find(function(cell) {
        if (cell instanceof joint.dia.Link) return false; // Not interested in links.
        if (cell.id === selfId) return true; 
        return false;
    });
    
    if (!selfConn) {
    	var connName = null;
    	while (connName == null) {
    		connName = window.prompt("Enter self connection name", "");
    	}
    	
    	var box = cellView.model.getBBox();
        graph.addCell(new joint.shapes.pathfinder.SelfLinkObj({
        	id: selfId,
        	text: connName,
        	size: {
        		width: 40,
        		height: 40
        	},
        	position: {
        		x: box.x + box.width + 50,
        		y: box.y + box.height / 2 - 20
        	}
        }));
        
        graph.addCell(new joint.shapes.pathfinder.Link({
        	id : "SELF_" + cellView.model.id + "_" + selfId,
            source: { id: cellView.model.id }, 
            target: { id: selfId }
        }));
        
        graph.addCell(new joint.shapes.pathfinder.Link({
        	id : "SELF_" + selfId + "_" + cellView.model.id,
            source: { id: selfId }, 
            target: { id: cellView.model.id }
        }));
    }
}