# 🚀 SmartAssistant iOS 18+ & Apple Intelligence Starter Kit

Projeto de exemplo profissional demonstrando a integração prática dos frameworks oficiais da Apple:
- **`FoundationModels` & `@Generable`:** IA On-Device com respostas em Structs Swift tipadas.
- **`AppIntents`:** Integração com Siri, Botão de Ação e Central de Controle.
- **`WidgetKit` & `ActivityKit`:** Live Activities na Dynamic Island e Tela de Bloqueio.
- **`App Store Server Notifications V2`:** Webhook listener em Python/FastAPI para assinaturas e pagamentos.
- **`GitHub Actions CI/CD`:** Pipeline de compilação automática no macOS Runner da nuvem.

---

## 📂 Estrutura do Projeto

```
Starter_Project_Demo/
├── Package.swift                             <-- Manifesto oficial do Swift Package
├── Sources/
│   └── SmartAssistantCore/
│       ├── AIEngine.swift                    <-- Execução de IA On-Device com @Generable
│       ├── QuickActionsIntent.swift          <-- App Intent para Siri / Botão de Ação
│       └── SmartWidget.swift                 <-- WidgetKit & Live Activity (Dynamic Island)
├── Backend/
│   ├── webhook_server.py                     <-- Servidor FastAPI de Webhooks da Apple V2
│   ├── test_webhook.py                       <-- Teste unitário automatizado de JWS
│   ├── Dockerfile                            <-- Container para deploy em VPS
│   └── docker-compose.yml                    <-- Orquestração do serviço
└── .github/
    └── workflows/
        └── ios_build.yml                     <-- Automação de compilação em Mac Cloud
```

---

## 🛠️ Como Publicar no seu GitHub e Compilar no Mac da Nuvem

1. **Faça login no GitHub CLI (uma única vez):**
   ```bash
   gh auth login
   ```
2. **Crie o repositório remoto e envie o código:**
   ```bash
   cd C:\Users\vinic\.gemini\antigravity\scratch\Apple_iOS_Developer_Docs\Starter_Project_Demo
   gh repo create smart-assistant-ios --public --source=. --remote=origin --push
   ```
3. O GitHub Actions executará o runner **`macos-14` / `macos-15`** na nuvem da Microsoft/Apple e compilará o projeto automaticamente.

---

## 🌐 Como Rodar o Servidor de Webhooks da Apple

### Localmente (Windows):
```bash
uv run --with fastapi --with uvicorn python Backend/webhook_server.py
```

### No seu Servidor VPS Hostinger (Docker):
```bash
scp -r Backend root@vps:/opt/apple-webhook
ssh vps "cd /opt/apple-webhook && docker compose up -d"
```
