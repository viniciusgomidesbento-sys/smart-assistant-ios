#
#  webhook_server.py
#  App Store Server Notifications V2 Listener
#
#  Servidor Backend em Python (FastAPI) para processamento de Webhooks da Apple
#

import base64
import json
from fastapi import FastAPI, Request, HTTPException, status
import uvicorn

app = FastAPI(title="Apple App Store Server Notifications V2 Listener")

def decode_jws_payload_unverified(signed_payload: str) -> dict:
    """
    Decodifica o payload de um token JWS (JSON Web Signature) da Apple.
    Em produção, a assinatura x5c / Apple Root Certificate deve ser validada.
    """
    parts = signed_payload.split(".")
    if len(parts) != 3:
        raise ValueError("Formato JWS inválido")
    
    # Decodifica a parte do meio (payload)
    payload_b64 = parts[1]
    # Corrige padding se necessário
    padding = '=' * (4 - len(payload_b64) % 4)
    decoded_bytes = base64.urlsafe_b64decode(payload_b64 + padding)
    return json.loads(decoded_bytes.decode('utf-8'))

@app.post("/api/v1/apple/webhook", status_code=status.HTTP_200_OK)
async def handle_apple_server_notification(request: Request):
    """
    Endpoint que recebe webhooks oficiais da Apple (App Store Server Notifications V2).
    Notificações como: SUBSCRIBED, DID_RENEW, EXPIRED, REVOKE, REFUND.
    """
    try:
        body = await request.json()
        signed_payload = body.get("signedPayload")
        
        if not signed_payload:
            raise HTTPException(status_code=400, detail="Missing signedPayload")
        
        # 1. Decodificar notificação principal
        notification_data = decode_jws_payload_unverified(signed_payload)
        
        notification_type = notification_data.get("notificationType")
        subtype = notification_data.get("subtype")
        notification_uuid = notification_data.get("notificationUUID")
        
        print(f"\n[APPLE WEBHOOK] Evento: {notification_type} (Subtipo: {subtype}) | UUID: {notification_uuid}")
        
        # 2. Decodificar dados da transação assinada se presentes
        data = notification_data.get("data", {})
        signed_transaction_info = data.get("signedTransactionInfo")
        if signed_transaction_info:
            tx_data = decode_jws_payload_unverified(signed_transaction_info)
            print(f" -> Produto: {tx_data.get('productId')} | ID Transação: {tx_data.get('transactionId')}")
            print(f" -> Expiração: {tx_data.get('expiresDate')} | Status: {tx_data.get('inAppOwnershipType')}")
            
        # 3. Lógica de negócio (atualizar banco de dados do usuário)
        if notification_type == "SUBSCRIBED":
            print(" -> Ação: Ativar plano Pro/Premium do usuário")
        elif notification_type == "DID_RENEW":
            print(" -> Ação: Estender período de assinatura")
        elif notification_type == "EXPIRED":
            print(" -> Ação: Revogar acesso Pro")
            
        # Apple exige retorno HTTP 200 para confirmar recebimento
        return {"status": "success", "processedUUID": notification_uuid}
        
    except Exception as e:
        print(f"[ERRO] Falha ao processar webhook: {e}")
        # Retorna 500 para a Apple tentar reenviar se for falha transitória
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    print("Iniciando servidor de Webhooks da Apple na porta 8080...")
    uvicorn.run(app, host="0.0.0.0", port=8080)
