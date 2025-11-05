*** Settings ***
# Importa as bibliotecas necessárias para as Keywords da API
Library    RequestsLibrary
Library    Collections
# Importa as variáveis de configuração (URL_BASE)
Resource    api_config.resource

*** Keywords ***
Fazer Login e Obter Token
    [Documentation]    Realiza a requisição de Login e retorna o token JWT.
    [Arguments]    ${email}    ${senha}
    
    # 1. Configura a sessão (garantindo que esteja ativa)
    Create Session    cinema_api    ${URL_BASE}
    
    # 2. Corpo da requisição com os argumentos
    &{BODY}=    Create Dictionary    email=${email}    password=${senha}
    
    # 3. Envia a requisição
    ${RESPONSE}=    POST On Session    cinema_api    /api/login    json=&{BODY}
    
    # 4. Verifica o sucesso do login (Status 200)
    Status Should Be    200    ${RESPONSE}
    
    # 5. Extrai o token do corpo JSON
    ${JSON_BODY}=    To Json    ${RESPONSE.content}
    ${TOKEN}=    Get From Dictionary    ${JSON_BODY}    token
    
    RETURN ${TOKEN}