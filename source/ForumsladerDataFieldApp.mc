using Toybox.Application as App;
using Toybox.Communications as Comm;
using Toybox.Background;
using Toybox.System;
//using Toybox.Ui;

(:background)
class ForumsladerDataFieldApp extends App.AppBase {

	protected var view;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
		Background.registerForTemporalEvent(new Time.Duration(5 * 60));
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        Background.exit(true);
    }

    // Return the initial view of your application here
    function getInitialView() {
        view = new ForumsladerDataFieldView();
        return [ view ];
    }

    // This method runs each time the background process starts.
    function getServiceDelegate() {
        System.println("getServiceDelegate");
        return [new BgbgServiceDelegate()];
    }
    
    function onBackgroundData(data) {
    		System.println("onBackgroundData");
    		
    		if (data instanceof Dictionary) {
    			//System.println(type_name(data));
    			view.setData(data);
    			/*
    			var value = data["tracks"][0]["title"];
    			if (value != null) {
				view.setTest(value);
			} else {
				System.println("no value found");
			}
			*/
		} else if (data instanceof Number && data == 2903) {
			view.setData(null);
		}    
	}    
}

(:background)
class BgbgServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        System.println("initialize");
    		ServiceDelegate.initialize();
    }

    function onTemporalEvent() {
        System.println("communicate");
        try {
            Comm.makeWebRequest("http://localhost:22223/dir.json", { "type" => "GPX", "short" => "1", "longname" => "1" },
                                {
                                    :method => Comm.HTTP_REQUEST_METHOD_GET,
                                    :headers => {
                                        "Content-Type" => Comm.REQUEST_CONTENT_TYPE_JSON
                                    		},
                                    :responseType => Comm.HTTP_RESPONSE_CONTENT_TYPE_JSON
                                    }, 
                                    method(:onReceive)
                );
        } catch (ex) {
			System.print(ex.getErrorMessage());
        }
	}

	function onReceive(responseCode, data) {
        System.println("onReceive: responseCode is " + responseCode + " and data is " + data);
        if (responseCode == 200) { 
			Background.exit(data);
		} else {
			Background.exit(2903);
		}
	}
}

function type_name(obj) {
    System.println("type_name");

    if (obj == null) {
        return "object is null";
    }
    if (obj instanceof Toybox.Lang.Number) {
        return "Number";
    }
    else if (obj instanceof Toybox.Lang.Long) {
        return "Long";
    }
    else if (obj instanceof Toybox.Lang.Float) {
        return "Float";
    }
    else if (obj instanceof Toybox.Lang.Double) {
        return "Double";
    }
    else if (obj instanceof Toybox.Lang.Boolean) {
        return "Boolean";
    }
    else if (obj instanceof Toybox.Lang.String) {
        return "String";
    }
    else if (obj instanceof Toybox.Lang.Method) {
        return "Method";
    }
    else if (obj instanceof Toybox.Lang.Array) {
        var s = "Array [";
        for (var i = 0; i < obj.size(); ++i) {
            s += type_name(obj[i]);
            s += ", ";
        }
        s += "]";
        return s;
    }
    else if (obj instanceof Toybox.Lang.Dictionary) {
        var s = "Dictionary{";
        var keys = obj.keys();
        var vals = obj.values();
        for (var i = 0; i < keys.size(); ++i) {
            s += keys[i];
            s += ": ";
            s += vals[i];
            s += ", ";
        }
        s += "}";
        return s;
    }
    else if (obj instanceof Toybox.Time.Gregorian.Info){
        return "Gregorian.Info";
    }
    else {
        return "???";
    }
}


