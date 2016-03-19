var paper;
var graph;

function printProps(obj) {
	console.log("Properties:");
	for (var id in obj) {
		if (typeof(obj[id]) == "function") {
			console.log(id + ": function"); //obj[id].toString()
		} else {
			console.log(id + ": property");
		}
	}
}

function editLink(cell) {
	if (!cell.isLink) return;
	if (typeof cell.get('source').id == 'undefined' || typeof cell.get('target').id == 'undefined') return;

	var source = graph.getCell(cell.get('source').id);
	var target = graph.getCell(cell.get('target').id);

	cell.get('source').idt = source.get('idt');
	cell.get('target').idt = target.get('idt');
	
	cell.set('idt', graph.get('idt') + '_' + source.get('idt') + '_' + target.get('idt'));	

	cell.set('vertices', []);
	graph.set('changed', true);
	callAdjust(source);
	callAdjust(target);
}

function addRemove(action, cell) {
	graph.set('changed', true);
	adjustVertices(cell);
	showGrants(cell, action);
}

function callAdjust(cell) {
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
		
		adjustVertices(links[link]);
	}
}

function adjustVertices(cell) {
	// If the cell is a view, find its model.
	cell = cell.model || cell;

	if (cell instanceof joint.dia.Element) {
		callAdjust(cell);
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
		break;

	default:
		// There is more than one siblings. We need to create vertices.
		var memSign = srcId < trgId ? 1 : -1;
		// First of all we'll find the middle point of the link.
		
		var srcBox = graph.getCell(srcId).getBBox();
		var trgBox = graph.getCell(trgId).getBBox();
	
		var srcCenter = srcBox.center();
		var trgCenter = trgBox.center();
//		var midPoint = g.line(srcCenter, trgCenter).midpoint();

		var srcMul = srcBox.width + srcBox.height;
		var trgMul = trgBox.width + trgBox.height;
		var midPoint = g.point((trgMul * srcCenter.x + srcMul * trgCenter.x) / (srcMul + trgMul), (trgMul * srcCenter.y + srcMul * trgCenter.y) /  (srcMul + trgMul));
		
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
		size: {
			width: 100,
			height: 60
		},
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
		'<div class="editSwitch">',
		'<input class="editSwitchInput" type="checkbox">New status</input>',
		'</div>',
		'<select class="selectCaption"></select>',
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

		this.$box.find('.editSwitch').hide();
		this.$box.find('.editCaption').hide();
		this.$box.find('.selectCaption').hide();
		this.$box.find('.editDone').hide();

		this.$box.find('.selectCaption').html(this.model.graph.get('statusList'));
		
		// store inputed value in model
		this.$box.find('.editDone').on('click', _.bind(function(evt) {
			var newText;
			var newIdt;
			
			if (this.$box.find('.editSwitchInput').prop("checked")) {	
				newText = this.$box.find('.editCaption').val();
				if (newText == "") {
					alert("Please srecify status");
					return;
				}
				newIdt = newText.toUpperCase().replace(/\ /g, "_");
			} else {
				newIdt = this.$box.find('.selectCaption').val();
				if (newIdt == null) {
					alert("Please srecify status");
					return;					
				}
				newText = this.$box.find('.VAL_' + newIdt).text();
			}

			this.model.graph.set('changed', true);
			this.model.set('text', newText);
			this.model.set('idt', newIdt);
			
			var links = this.model.graph.getConnectedLinks(this.model);
			for (var i in links) {
				if (links[i].get('source').id === this.model.id) {
					links[i].get('source').idt = newIdt;
				}
				if (links[i].get('target').id === this.model.id) {
					links[i].get('target').idt = newIdt;
				}
				links[i].set('idt', this.model.graph.get('idt') + '_' + links[i].get('source').idt + "_" + links[i].get('target').idt);
			}
			
			this.$box.find('.editEnable').show();
			this.$box.find('.editSwitch').hide();
			this.$box.find('.editCaption').hide();
			this.$box.find('.selectCaption').hide();
			this.$box.find('.editDone').hide();
		}, this));
		
		this.$box.find('.editEnable').on('click', _.bind(function(evt) {
			this.$box.find('.editEnable').hide();

			var ed = this.$box.find('.editCaption');
			ed.val(this.model.get('text'));
			
			var sel = this.$box.find('.selectCaption');
			sel.val(this.model.get('idt'));
			
			if (this.$box.find('.editSwitchInput').prop("checked")) {			
				ed.show();
			} else {
				sel.show();
			}
			
			this.$box.find('.editSwitch').show();
			this.$box.find('.editDone').show();
		}, this));
		
		this.$box.find('.editSwitchInput').on('change', _.bind(function(evt) {
			if (this.$box.find('.editSwitchInput').prop("checked")) {			
				this.$box.find('.editCaption').show();
				this.$box.find('.selectCaption').hide();
			} else {
				this.$box.find('.editCaption').hide();
				this.$box.find('.selectCaption').show();
			}	
		}, this));
		
		this.$box.find('.delete').on('click', _.bind(this.model.remove, this.model));
		
		// Update the box position whenever the underlying model changes.
		this.model.on('change', this.updateBox, this);
		// Remove the box when the model gets removed from the graph.
		this.model.on('remove', this.removeBox, this);
		
		if (typeof this.model.get('idt') == 'undefined') {
			// no idt provided, so it's the new one
			this.$box.find('.editEnable').click();
		}

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

joint.shapes.pathfinder.EditableOtherProject = joint.shapes.basic.Rect.extend({
	defaults: joint.util.deepSupplement({
		type: 'pathfinder.EditableOtherProject',
		size: {
			width: 150,
			height: 80
		},
		attrs: {
			rect: { stroke: 'none', 'fill-opacity': 0 }
		}
	}, joint.shapes.basic.Rect.prototype.defaults)
});

joint.shapes.pathfinder.EditableOtherProjectView = joint.dia.ElementView.extend({
	template: [
		'<div class="editableProjectDiv">',
		'<button class="delete">x</button>',
		'<div class="elementLabel"><label class="labelCaption"/></div>',
		'<div class="editLabel">',
		'<button class="editEnable" type="button">Edit</button>',
		'<select class="selectProject"></select>',
		'<select class="selectStatus"></select>',
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

		this.$box.find('.selectProject').hide();
		this.$box.find('.selectStatus').hide();
		this.$box.find('.editDone').hide();

		this.$box.find('.selectProject').html(this.model.graph.get('projectList'));
		this.$box.find('.selectStatus').html(this.model.graph.get('statusList'));
		
		// store inputed value in model
		this.$box.find('.editDone').on('click', _.bind(function(evt) {
			var newPrjIdt = this.$box.find('.selectProject').val();
			if (newPrjIdt == "") {
				alert("Please specify project");
			}
			var newPrjText = this.$box.find('.PRJ_' + newPrjIdt).text();

			var newStIdt = this.$box.find('.selectStatus').val();
			if (newStIdt == "") {
				alert("Please specify status");
			}
			var newStText = this.$box.find('.VAL_' + newStIdt).text();
			
			var newIdt = newPrjIdt + "." + newStIdt;
			
			this.model.graph.set('changed', true);
			this.model.set('text', '<b>' + newPrjText + '</b><br/>' + newStText);
			this.model.set('idt', newIdt);
			
			var links = this.model.graph.getConnectedLinks(this.model);
			for (var i in links) {
				if (links[i].get('source').id === this.model.id) {
					links[i].get('source').idt = newIdt;
				}
				if (links[i].get('target').id === this.model.id) {
					links[i].get('target').idt = newIdt;
				}
				links[i].set('idt', this.model.graph.get('idt') + '_' + links[i].get('source').idt + "_" + links[i].get('target').idt);
			}
			
			this.$box.find('.editEnable').show();
			this.$box.find('.selectProject').hide();
			this.$box.find('.selectStatus').hide();
			this.$box.find('.editDone').hide();
		}, this));
		
		this.$box.find('.editEnable').on('click', _.bind(function(evt) {
			this.$box.find('.editEnable').hide();

			this.$box.find('.selectProject').show();
			this.$box.find('.selectStatus').show();
			this.$box.find('.editDone').show();
		}, this));
			
		this.$box.find('.delete').on('click', _.bind(this.model.remove, this.model));
		
		// Update the box position whenever the underlying model changes.
		this.model.on('change', this.updateBox, this);
		// Remove the box when the model gets removed from the graph.
		this.model.on('remove', this.removeBox, this);
		
		if (typeof this.model.get('idt') == 'undefined') {
			// no idt provided, so it's the new one
			this.$box.find('.editEnable').click();
		}

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
		this.$box.find('.labelCaption').html(this.model.get('text'));
		this.$box.css({ width: bbox.width, height: bbox.height, left: bbox.x, top: bbox.y, transform: 'rotate(' + (this.model.get('angle') || 0) + 'deg)' });
	},
	removeBox: function(evt) {
		this.$box.remove();
	}
});

joint.shapes.pathfinder.SelfLinkObj = joint.shapes.basic.Circle.extend({
	defaults: joint.util.deepSupplement({
		type: 'pathfinder.SelfLinkObj',
		size: {
			width: 40,
			height: 40
		},
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

joint.shapes.pathfinder.StartObj = joint.shapes.basic.Circle.extend({
	defaults: joint.util.deepSupplement({
		type: 'pathfinder.StartObj', // make it first in the list
		size: {
			width: 50,
			height: 50
		},
		attrs: {
			rect: { stroke: 'none', 'fill-opacity': 0 }
		}
	}, joint.shapes.basic.Circle.prototype.defaults)
});

joint.shapes.pathfinder.StartObjView = joint.dia.ElementView.extend({
	template: [
	    '<div class="startObjDiv">',
		'</div>'
	].join(''),
	
	initialize: function() {
		_.bindAll(this, 'updateBox');
		joint.dia.ElementView.prototype.initialize.apply(this, arguments);
		this.$box = $(_.template(this.template)());
		// Prevent paper from handling pointerdown: in find we specify the list of tags for input
		
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

joint.shapes.pathfinder.SelfLink =  joint.dia.Link.extend({
    defaults: {
        type: 'pathfinder.SelfLink',
        attrs: { '.marker-target' : { 'd' :  'M 10 0 L 0 5 L 10 10 z' }},
		smooth: true
    }
});

function saveXY(cellView, evt, x, y) {
	if (!cellView.isLink) {
		cellView.model.prevX = x;
		cellView.model.prevY = y;
	}
}

function showGrants(cellView, action) {
	var cell = cellView.model || cellView;
	if ((cell instanceof joint.shapes.pathfinder.Link)
			|| (cell instanceof joint.shapes.pathfinder.SelfLinkObj)) {
		if (action === "remove") {
			graph.get('showGrants')(null);
		} else {
			graph.get('showGrants')(cell.get('id'));
		}
	}
}

function connectByDrop(cellView, evt, x, y) {
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
    if (elementBelow 
    		&& (elementBelow instanceof joint.shapes.pathfinder.EditableStatus
    				|| elementBelow instanceof joint.shapes.pathfinder.EditableOtherProject)
    		&& (cellView.model instanceof joint.shapes.pathfinder.EditableStatus
    				|| cellView.model instanceof joint.shapes.pathfinder.StartObj)
			&& !(cellView.model instanceof joint.shapes.pathfinder.StartObj
					&& elementBelow instanceof joint.shapes.pathfinder.EditableOtherProject)
    		&& !graph.isNeighbor(elementBelow, cellView.model, opt)) {
    	var connName = null;
    	var connId = null;
    	
    	if (cellView.model instanceof joint.shapes.pathfinder.StartObj) {
    		connName = "Create";
    	}
    	if (elementBelow instanceof joint.shapes.pathfinder.EditableOtherProject) {
    		connName = "Move";
    	}
    	
    	while (connName == null || connName === '') {
    		connName = window.prompt("Enter connection name", "");
    	}
    	
    	var newCell = new joint.shapes.pathfinder.Link({
        	idt: graph.get('idt') + '_' + cellView.model.get('idt') + "_" + elementBelow.get('idt'),
            source: { 
            	id: cellView.model.id,
            	idt: cellView.model.get('idt')
            }, 
            target: { 
            	id: elementBelow.id, 
            	idt: elementBelow.get('idt')
            },
            labels: [{
            	position: 0.5,
            	attrs: {
            		text: { text: connName }
            	}
            }]
        });
        graph.addCell(newCell);
//        showGrants(newCell);

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

function selfConnect(cellView, evt, x, y) {
	if (!(cellView.model instanceof joint.shapes.pathfinder.EditableStatus)) return;
	
	var selfId = '__SELF_' + cellView.model.id;
    var selfConn = graph.get('cells').find(function(cell) {
        if (cell instanceof joint.dia.Link) return false; // Not interested in links.
        if (cell.id === selfId) return true; 
        return false;
    });
    
    if (!selfConn) {
    	var connName = "Edit";
    	
    	var box = cellView.model.getBBox();
		var selfIdt = graph.get('idt') + '_' + cellView.model.get('idt') + '_' + cellView.model.get('idt');
    	var selfCell = new joint.shapes.pathfinder.SelfLinkObj({
        	id: selfId,
        	idt: selfIdt,
        	text: connName,
        	position: {
        		x: box.x + box.width + 50,
        		y: box.y + box.height / 2 - 20
        	}
        });
        graph.addCell(selfCell);
//        showGrants(selfCell);
        
        graph.addCell(new joint.shapes.pathfinder.SelfLink({
            source: { 
            	id: cellView.model.id,
            	idt: cellView.model.get('idt')
            }, 
            target: { 
            	id: selfId,
            	idt: selfIdt
            }
        }));
        
        graph.addCell(new joint.shapes.pathfinder.SelfLink({
            source: { 
            	id: selfId,
            	idt: selfIdt
            }, 
            target: { 
            	id: cellView.model.id,
            	idt: cellView.model.get('idt')
            }
        }));
    }
}

function addListeners(grantsFunc) {
	// adjust vertices when a cell is removed 
	graph.on('add', _.partial(addRemove, "add"));
	graph.on('remove', _.partial(addRemove, "remove"));

	graph.on('change:source change:target', editLink);
	
	graph.set('showGrants', grantsFunc);
	// also when an user stops interacting with an element.
	paper.on('cell:pointerdown', function(cellView, evt, x, y) {
		saveXY(cellView, evt, x, y);
		showGrants(cellView, "select");
	});
	
	var myPointerUp = function(cellView, evt, x, y) {
		connectByDrop(cellView, evt, x, y);
		adjustVertices(cellView);
	};
	paper.on('cell:pointerup', myPointerUp);	
	paper.on('cell:pointerdblclick', selfConnect);
}

function createGraph(json, projects, statuses, grantsFunc) {
	graph = new joint.dia.Graph({
		projectList: projects,
		statusList: statuses
	});
	
    paper = new joint.dia.Paper({
        el: $('#wfdiv'),
        width: 0,
        height: 600,
        model: graph,
        gridSize: 1
    });
	
	function resizeDiv() {
		paper.setDimensions($('#divProjectModel').width(), paper.options.height);
	}	

	$(document).ready(function(){
		resizeDiv();
	});

	window.onresize = function(event) {
		resizeDiv();
	}	
    
    addListeners(grantsFunc);
    
	if (json != null) {
		graph.fromJSON(JSON.parse(json));
		
		var cells = graph.getElements();
		for (var cell in cells) {
			callAdjust(cells[cell]);
		}
		
		graph.set('changed', false);
	} else {
		graph.set('changed', true);
	}
	
	grantsFunc(null);
}