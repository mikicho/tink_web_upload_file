This repo demonstrate the problem when I'm trying to upload file with `tink_web`.  
To make it run on your machines:
1. Clone the repo
2. Change `tink.web.forms.FormFile.hx` file to (minor changes applied on `ofJson` and `ofBlob` functions):
```haxe
package tink.web.forms;

import haxe.io.Bytes;
import tink.chunk.ByteChunk;
import tink.json.Representation;
import tink.http.StructuredBody;

using tink.io.Source;
using tink.CoreApi;

typedef JsonFileRep = Representation<{
  mimeType:String,
  fileName:String,
  content:Bytes,
}>;

@:forward
abstract FormFile(UploadedFile) {
  
  inline function new(v) this = v;

  @:to function toJson():JsonFileRep {
    return new Representation({
      fileName: this.fileName,
      mimeType: this.mimeType,
      content: {
        var src = this.read();
        var chunk = null;
        var write = src.all().handle(function(c) chunk = c.sure());
        if(chunk != null) 
          chunk.toBytes();
        else {
          write.dissolve();
          throw new Error(NotImplemented, 'Can only upload files through JSON backed by with sync sources but got a $src');
        }
      }
    });
  }
  
  @:from static function ofJson(rep:JsonFileRep):FormFile {
    var data = rep.get();
    return ofBlob(data.fileName, data.mimeType, data.content);
  }
  
  static inline public function ofBlob(name:String, type:String, data:Bytes):FormFile 
    return new FormFile(UploadedFile.ofBlob(name, type, data));
}
```