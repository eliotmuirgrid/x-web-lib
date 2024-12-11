-- Show the status
function WEBstatus(Config)
   local Url = Config.cert and "https://" or "http://"
   Url = Url.."localhost:"..Config.port.."/";
   trace(Url)
   local Status ="URL: <a target='_blank' href='"..Url.."'>"..Url.."</a>";
   -- if cert is the default Iguana SSL cert, then also display a note about self-signed certificates
   if "configurations/web/cert.pem" == Config.cert then
      Status = Status.."<br>Note: Your browser may display a self-signed certificate warning if the default Iguana SSL certificate is being used."
   end
   trace(Status)
   component.setStatus{data=Status}    
end

if net.http.listen == nil then
   error("Please upgrade to 10.1.86 or above. This component needs net.http.listen");
end