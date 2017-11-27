Param(
    [string]$pwd    
)

$domain         = $env:USERDOMAIN
$user           = $env:USERNAME
$uriPwd         = [uri]::EscapeUriString($pwd)
$proxy          = ([System.Net.WebProxy]::GetDefaultProxy() | Select-Object -First 1 Address).Address.ToString()

$proxArr        = [System.Text.RegularExpressions.Regex]::Split($proxy, '://')

$uriEncodeProxy = [string]::Format('{0}://{1}:{2}@{3}', $proxArr[0], $user, $uriPwd, $proxArr[1])

Write-Host 'Domain:              ' $domain
Write-Host 'User:                ' $user
Write-Host 'Proxy:               ' $proxy
#Write-Host 'Authenticated Proxy: ' $uriEncodeProxy

# git
git config --global http.proxy $uriEncodeProxy

# npm/nodejs
npm config set proxy $uriEncodeProxy
npm config set https-proxy $uriEncodeProxy

# nuget
# nuget config -set http_proxy=$proxy
# nuget config -set http_proxy.user=($domain + '\' + $user)
# nuget config -set http_proxy.password=$pwd

#sublime

#docker
# [Environment]::SetEnvironmentVariable("HTTP_PROXY",  $uriEncodeProxy, [EnvironmentVariableTarget]::Machine)
# [Environment]::SetEnvironmentVariable("HTTPS_PROXY", $uriEncodeProxy, [EnvironmentVariableTarget]::Machine)
# Restart-Service docker