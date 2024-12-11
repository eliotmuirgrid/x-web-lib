require "WEB.WEBconstants"

function WEBsetConnectionHeaders(RequestHeaders, Headers)
	if RequestHeaders["ifw_conn_id"] ~= nil then
      Headers["ifw_conn_id"] = RequestHeaders["ifw_conn_id"]
   end
   if RequestHeaders["ifw_stream_id"] ~= nil then
      Headers["ifw_stream_id"] = RequestHeaders["ifw_stream_id"]
   end
   return Headers
end

function WEBsetResponseHeaders(RequestHeaders)
   local Headers = {}
   -- Set content type as HTML
   Headers["content-type"] = "text/html"
   -- Prevent XSS attacks - https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html
   Headers["Content-Security-Policy"] = "default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self'; frame-ancestors 'self'; form-action 'self';"
   -- Set the connection headers so the server knows which connection to respond to
   Headers = WEBsetConnectionHeaders(RequestHeaders, Headers)
   trace(Headers)
   return Headers
end

-- Modify this function to set a custom response
function WEBsetResponseBody(R)
   -- Generate HTML response into H variable
   local H = WEB_HEADER
   H = H.."Path: "..R.location..WEB_VARIABLE_HEADER
   for K,V in pairs(R.params) do
      H = H.."<li>"..K.." = "..V.."</li>\n"
   end
   H = H..WEB_FOOTER
   trace(H)
   return H
end

function WEBrespond(JsonData)
   iguana.logMessage("Respond task received")
   local Data    = json.parse{data=JsonData}
   local Body    = Data.body
   local Headers = Data.headers
   iguana.logMessage("Responding to connection ".. Data.headers["ifw_conn_id"])
   net.http.respond{body=Body, headers=Headers}
end