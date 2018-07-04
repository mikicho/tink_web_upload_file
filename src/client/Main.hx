import js.Browser.document;
import js.html.Event;
import tink.web.proxy.Remote;
import tink.url.Host;
import tink.http.clients.JsClient;
import tink.web.forms.FormFile;
import api.IRoot;
import js.html.InputElement;
import js.html.FileReader;

class Main {
	static function main() {
		var r = new Remote<IRoot>(new JsClient(), new RemoteEndpoint(new Host('localhost', 3000)));

		var uploadform = document.forms.namedItem("upload_form");
		uploadform.addEventListener("submit", function(e:Event) {
			var fileInput:InputElement = untyped document.getElementById("file-input");
			var file = fileInput.files[0];
			var reader = new FileReader();

			reader.onload = function() {

				var arrayBuffer = reader.result;
				trace(arrayBuffer);
				r.uploadFile({file: FormFile.ofBlob(file.name, file.type, arrayBuffer)});
			}
			reader.readAsArrayBuffer(file);

			e.preventDefault();
		});

		r.getFilesList().handle(function(o) switch o {
			case Success(result): trace(result);
			case Failure(e): trace(e);
		});
	}
}

typedef CalcParams = {
	?peakNum:String, 
	?highAvg:String,
	?lowAvg:String,
	?fileName:String,
}