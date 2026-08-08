#!/usr/bin/env python3
import os, json, urllib.request

webhook_url = os.getenv('DISCORD_WEBHOOK_STABLE')
if not webhook_url:
    print("Error: DISCORD_WEBHOOK_STABLE not set")
    exit(1)

# Minimal payload: content + button component
payload = {
    "content": "测试",
    "components": [{
        "type": 1,
        "components": [{
            "type": 2,
            "style": 5,
            "label": "测试按钮",
            "url": "https://github.com"
        }]
    }]
}

data = json.dumps(payload).encode('utf-8')
req = urllib.request.Request(
    os.getenv('DISCORD_WEBHOOK_STABLE'),
    data=json.dumps(payload).encode('utf-8'),
    headers={'Content-Type': 'application/json', 'User-Agent': 'Test-Bot/1.0'}
)

try:
    with urllib.request.urlopen(req) as resp:
        print(f"Discord response: {resp.status}")
except urllib.error.HTTPError as e:
    print(f"Error: {e.code} - {e.read().decode()}")