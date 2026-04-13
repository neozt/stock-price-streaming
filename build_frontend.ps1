param (
    [string]$stack_name
)

# Get user input for stack name if not provided
if (-not $stack_name) {
    $stack_name = Read-Host "Enter the name of the CloudFormation stack"
}

# Get all stack outputs from CloudFormation
Write-Host "Fetching outputs for stack: $stack_name..."
$outputs_json = aws cloudformation describe-stacks --stack-name $stack_name --query "Stacks[0].Outputs" --output json
if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to fetch stack outputs. Please check the stack name and your AWS credentials."
    exit $LASTEXITCODE
}

$outputs = $outputs_json | ConvertFrom-Json
$outputMap = @{}
foreach ($out in $outputs) {
    $outputMap[$out.OutputKey] = $out.OutputValue
}

# Load .env template
$env_path = "frontend/.env"
if (-not (Test-Path $env_path)) {
    Write-Error ".env file not found at $env_path"
    exit 1
}
$env_content = Get-Content -Path $env_path -Raw

# Replace placeholders %%xxx%% with stack outputs
Write-Host "Replacing placeholders in .env..."
foreach ($key in $outputMap.Keys) {
    $placeholder = "%%$key%%"
    $value = $outputMap[$key]
    if ($env_content.Contains($placeholder)) {
        Write-Host "  Replacing $placeholder"
        $env_content = $env_content.Replace($placeholder, $value)
    }
}

# Write .env.production
Write-Host "Generating .env.production..."
$env_content | Out-File -FilePath "frontend/.env.production" -Encoding utf8

# Run npm install and build
Write-Host "Running npm install in frontend..."
Set-Location frontend
npm ci
if ($LASTEXITCODE -ne 0) {
    Write-Error "npm install failed."
    Set-Location ..
    exit $LASTEXITCODE
}

Write-Host "Running vite build..."
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Error "Vite build failed."
    Set-Location ..
    exit $LASTEXITCODE
}

Set-Location ..

Write-Host "Build complete! Files are in the 'dist' directory."
return $outputMap
