import base64
import json
import asyncio
import httpx
from webhook_server import app

def create_mock_jws_payload(payload_dict: dict) -> str:
    header = {"alg": "ES256", "x5c": ["mock_cert"]}
    header_b64 = base64.urlsafe_b64encode(json.dumps(header).encode()).decode().rstrip("=")
    payload_b64 = base64.urlsafe_b64encode(json.dumps(payload_dict).encode()).decode().rstrip("=")
    signature_b64 = base64.urlsafe_b64encode(b"mock_signature").decode().rstrip("=")
    return f"{header_b64}.{payload_b64}.{signature_b64}"

async def test_apple_webhook():
    print("\n--- INICIANDO TESTE DO WEBHOOK APPLE SERVER NOTIFICATIONS V2 ---")
    
    # 1. Simular payload de transação
    tx_payload = {
        "transactionId": "1000000987654321",
        "originalTransactionId": "1000000123456789",
        "productId": "com.smartassistant.pro.monthly",
        "purchaseDate": 1724800000000,
        "expiresDate": 1727400000000,
        "inAppOwnershipType": "PURCHASED"
    }
    signed_tx = create_mock_jws_payload(tx_payload)
    
    # 2. Simular notificação V2
    notification_payload = {
        "notificationType": "SUBSCRIBED",
        "subtype": "INITIAL_BUY",
        "notificationUUID": "5f9b3c4a-1234-5678-9abc-def012345678",
        "version": "2.0",
        "data": {
            "appAppleId": 1234567890,
            "bundleId": "com.example.SmartAssistant",
            "signedTransactionInfo": signed_tx
        }
    }
    signed_notification = create_mock_jws_payload(notification_payload)
    
    # 3. Executar chamada usando AsyncClient com o app FastAPI
    transport = httpx.ASGITransport(app=app)
    async with httpx.AsyncClient(transport=transport, base_url="http://test") as client:
        response = await client.post("/api/v1/apple/webhook", json={"signedPayload": signed_notification})
        
        print(f"Status HTTP retornado: {response.status_code}")
        print(f"Corpo da resposta: {response.json()}")
        
        assert response.status_code == 200
        assert response.json()["status"] == "success"
        assert response.json()["processedUUID"] == "5f9b3c4a-1234-5678-9abc-def012345678"
        print("\n[SUCESSO] O servidor processou e validou o Webhook da Apple corretamente!")

if __name__ == "__main__":
    asyncio.run(test_apple_webhook())
