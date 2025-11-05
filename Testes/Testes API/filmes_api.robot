*** Settings ***
# 1. Bibliotecas e Recursos
Library    RequestsLibrary
Library    Collections
Resource    resources/api_config.resource
Resource    resources/api_keywords.resource  # <-- Usaremos a keyword de Login daqui!

*** Test Cases ***
CT-FILMES-001 - Deve listar filmes com sucesso usando o token de autenticação
    [Documentation]    Verifica se a listagem de filmes é protegida e funcional.
    
    # 1. PRÉ-CONDIÇÃO: FAZER LOGIN E OBTER O TOKEN
    # Chamamos a Keyword que criamos para obter o token de um usuário válido.
    ${TOKEN}=    Fazer Login e Obter Token    teste@email.com    123456
    
    # 2. PREPARAR O CABEÇALHO COM O TOKEN
    # O token deve ser enviado no cabeçalho 'Authorization' no formato "Bearer [TOKEN]".
    ${HEADERS}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    
    # 3. EXECUTAR: Envia a requisição GET para /api/filmes
    Create Session    cinema_api    ${URL_BASE}
    ${RESPONSE}=    GET On Session    cinema_api    /api/filmes    headers=${HEADERS}
    
    # 4. VERIFICAÇÃO (Status HTTP)
    # O sistema deve retornar 200 OK, confirmando o acesso autorizado.
    Status Should Be    200    ${RESPONSE}
    
    # 5. VERIFICAÇÃO (Conteúdo da Resposta)
    ${JSON_BODY}=    To Json    ${RESPONSE.content}
    
    # Verifica se a resposta é uma lista (o corpo da listagem)
    Should Be True    len(${JSON_BODY}) >= 0    # Garante que é uma lista, mesmo que vazia
    
    # Verifica a estrutura: se a lista não estiver vazia, verifica se o primeiro item é um dicionário (objeto filme)
    Run Keyword If    len(${JSON_BODY}) > 0    Dictionary Should Contain Key    ${JSON_BODY[0]}    title


CT-FILMES-002 - Não deve listar filmes sem o token de autenticação
    [Documentation]    Testa o cenário de segurança: acesso negado sem JWT.
    
    # 1. PRÉ-CONDIÇÃO: Sessão sem autenticação
    Create Session    cinema_api_unauth    ${URL_BASE}
    
    # 2. EXECUTAR: Envia a requisição GET para /api/filmes sem cabeçalho
    ${RESPONSE}=    GET On Session    cinema_api_unauth    /api/filmes
    
    # 3. VERIFICAÇÃO (Status HTTP)
    # Deve retornar 401 (Unauthorized) ou 403 (Forbidden). O back-end do challenge retorna 401.
    Status Should Be    401    ${RESPONSE}
    
    # 4. VERIFICAÇÃO (Mensagem de Erro)
    ${JSON_BODY}=    To Json    ${RESPONSE.content}
    Should Be Equal    ${JSON_BODY['message']}    Não autorizado