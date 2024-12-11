require 'WEB.WEBstatus'

function WEBsetHttpsConfig(Certificate, PrivateKey, Config)
   local Cert = Certificate
   local Key  = PrivateKey
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

function WEBstartServer(Port, UseHTTPS, Certificate, PrivateKey)
   local Config = { port = Port }
   if UseHTTPS then
      WEBsetHttpsConfig(Certificate, PrivateKey, Config)
   end
   trace(Config)
   
   net.http.listen(Config)
   WEBstatus(Config)
end