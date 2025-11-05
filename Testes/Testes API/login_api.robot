*** Settings ***
Library    RequestsLibrary
Library    Collections
Resource    resources/api_config.resource
Resource    resources/api_keywords.resource  # <-- NOVO: Importa as novas Keywords
# ... (O restante das suas configurações)

*** Test Cases ***
CT-LOG-001 - Deve realizar login com credenciais válidas e retornar token
    [Documentation]    Testa se a API autentica um usuário válido.
    
    # CHAMANDO A NOVA KEYWORD
    ${TOKEN}=    Fazer Login e Obter Token    teste@email.com    123456
    
    # 1. Verificação (Confirma que o token foi retornado e não está vazio)
    Should Not Be Empty    ${TOKEN}

# ... (O teste CT-LOG-003 continua igual, pois não precisa do token)