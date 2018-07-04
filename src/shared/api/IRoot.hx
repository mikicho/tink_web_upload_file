package api;

import tink.web.forms.FormFile;

interface IRoot {
	@:post('/files')
	public function uploadFile(body: {file: FormFile}):String;

	@:get("/files/list")
	public function getFilesList():Array<String>;
}