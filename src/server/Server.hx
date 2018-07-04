package ;

import tink.http.containers.*;
import tink.http.Response;
import tink.web.routing.*;
import tink.http.Handler;
import tink.http.middleware.Static;
import api.Root;

class Server {
	public function new() {
		var container = new NodeContainer(3000);
		var router = new Router<Root>(new Root());
		var handler:Handler = function(req) return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError);
		handler = handler.applyMiddleware(new Static('./public', '/'));

		container.run(handler);

		trace("Listening on port 3000");
	}
}