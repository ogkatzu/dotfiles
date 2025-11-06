# Excluded VS Code Settings

These settings were excluded from the public `settings.json` for security reasons. You'll need to configure them manually on each machine:

## Jenkins Configuration

**IMPORTANT: These contain sensitive credentials and should NOT be committed to git!**

```json
"jenkins.pipeline.linter.connector.crumbUrl": "http://YOUR_JENKINS_URL:8080/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)",
"jenkins.pipeline.linter.connector.user": "YOUR_USERNAME",
"jenkins.pipeline.linter.connector.url": "http://YOUR_JENKINS_URL:8080/pipeline-model-converter/validate",
"jenkins.pipeline.linter.connector.pass": "YOUR_PASSWORD",
```

## Remote SSH Hosts

```json
"remote.SSH.remotePlatform": {
    "127.0.0.1": "linux",
    "YOUR_SERVER_IP": "linux"
},
```

## How to Add These Settings

1. Open VS Code
2. Press `Ctrl+,` (or `Cmd+,` on macOS) to open Settings
3. Click the "Open Settings (JSON)" icon in the top right
4. Add the above settings with your actual values
5. Save the file

## Security Note

Never commit credentials, API keys, or sensitive URLs to git repositories. Consider using:
- Environment variables
- VS Code Secret Storage
- A separate `settings.local.json` file (add to `.gitignore`)
