require 'WEB.WEBstatus'

local function processHTTPSconfigurations(Config)
   local Cert = component.fields().Certificate
   local Key  = component.fields().PrivateKey
   if "Use Iguana's SSL certificate" == Cert and "Use Iguana's private key" == Key then
      -- Get Iguana web server's certificate and private key
      local Result = iguana.call{api="/web/server", live=true}
      if not Result.success then
         error("Failed to obtain Iguana's web server SSL certificate and private key.")
      end
      Cert = Result.data.cert_key
      Key  = Result.data.private_key
   end
   Config.cert = Cert
   Config.key  = Key
end

function StartServer()
   local CustomFields = component.fields()
   local Config = { port = CustomFields.Port }
   if CustomFields.UseHTTPS then
      processHTTPSconfigurations(Config)
   end
   trace(Config)
   net.http.listen(Config)
   WEBstatus(Config)
end