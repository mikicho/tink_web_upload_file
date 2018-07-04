package api;

import tink.http.Response;
import sys.io.File;
import tink.web.forms.FormFile;
import api.IRoot;
import sys.FileSystem;

class Root implements IRoot {
	public function new() {}

	@:get('/')
	public function index() {
		return OutgoingResponse.blob(StatusCode.OK, File.getContent("bin/public/index.html"), "text/html");
	}
	
	@:post("/files")
	public function uploadFile(body:{file:FormFile}) {
		return body.file.mimeType;
	}

	@:get("/files/list")
	public function getFilesList() {
		return ["File A", "File B"];
	}
}