#!/usr/bin/env python3
import os, json, urllib.request

webhook_url = os.getenv('DISCORD_WEBHOOK_STABLE')
if not webhook_url:
    print("Error: DISCORD_WEBHOOK_STABLE not set")
    exit(1)

# Minimal test payload with ONE button
payload = {
    "username": "Test Bot",
    "content": "测试按钮：",
    "components": [{
        "type": 1,
        "components": [{
            "type": 2,
            "style": 5,
            "label": "测试下载",
            "url": "https://github.com/mow2333/WorldBridge/releases/download/0.1.0/test.jar"
        }]
    }]
}

data = json.dumps(payload).encode('utf-8')
req = urllib.request.Request(
    os.getenv('DISCORD_WEBHOOK_STABLE'),
    data=json.dumps({"components": [{"type": 1, "components": [{"type": 2, "style": 5, "label": "测试下载", "url": "https://github.com/mow2333/WorldBridge/releases/download/0.1.0/test.jar"}]}]}).encode('utf-8'),
    headers={'Content-Type': 'application/json', 'User-Agent': 'Test-Bot/1.0'}
)

try:
    with urllib.request.urlopen(req) as resp:
        print(f"Discord response: {resp.status}")
except urllib.error.HTTPError as e:
    print(f"Error: {e.code} - {e.read().decode()}")