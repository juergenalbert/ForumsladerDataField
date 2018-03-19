using Toybox.WatchUi as Ui;

class ForumsladerDataFieldView extends Ui.SimpleDataField {
	var data = null;
	var count = 0;
	var index = 0;
	var waiting = [" .    ", " ..   ", " ...  ", " .... ", "  ... ", "   .. ", "    . ", "      "];

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "Forumslader";
    }

	function setData(val) {
		data = val;
	}

    // The given info object contains all the current workout
    // information. Calculate a value and return it in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
    		//System.println("compute");
        // See Activity.Info in the documentation for available information.
        if (data != null) {
        		if (data instanceof Dictionary) {
    			    var keys = data.keys();
				var key = keys[index];
				var seconds = data[key];

				count++;
				if (count >= seconds.toNumber()) {
					index = (index + 1) % data.size();
					count = 0;
				} 

        			return key;
    			} 
        }
		System.println("unknown data: " + data);
		count++;
		return waiting[count % waiting.size()];
    }
}