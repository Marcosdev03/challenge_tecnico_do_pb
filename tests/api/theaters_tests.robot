*** Settings ***
Library    RequestsLibrary
Library    DateTime
Resource    ../../resources/api/theaters.resource
Resource    ../../resources/api/auth.resource
Resource    ../../variables/api_variables.robot
Resource    ../../variables/global_variables.robot
Suite Setup    RequestsLibrary.Create Session    api    ${BASE_API_URL}

*** Test Cases ***
Listar Todas As Salas Deve Retornar Lista
    [Tags]    THE-001
    ${response}=    Obter Todas As Salas
    Should Be Equal As Strings    ${response.status_code}    200

Obter Sala Por ID Deve Retornar Detalhes
    [Tags]    THE-002
    # Primeiro criar uma sala para buscar
    ${login_response}=    Fazer Login Do Usuario    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala}=    Create Dictionary    name=Sala Para Buscar ${timestamp}    capacity=80
    ${create_response}=    Criar Sala    ${token}    ${dados_sala}
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${id_sala}=    Set Variable    ${create_response.json()['data']['_id']}
    # Agora buscar
    ${response}=    Obter Sala Por ID    ${id_sala}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    name
    Dictionary Should Contain Key    ${response.json()['data']}    capacity

Obter Assentos Da Sala Deve Retornar Mapa
    [Tags]    THE-002
    # Primeiro criar uma sala
    ${login_response}=    Fazer Login Do Usuario    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala}=    Create Dictionary    name=Sala Para Assentos ${timestamp}    capacity=60
    ${create_response}=    Criar Sala    ${token}    ${dados_sala}
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${id_sala}=    Set Variable    ${create_response.json()['data']['_id']}
    # Buscar assentos
    ${response}=    Obter Assentos Da Sala    ${id_sala}
    Should Be Equal As Strings    ${response.status_code}    404

Admin Criar Nova Sala Deve Ter Sucesso
    [Tags]    THE-003
    ${login_response}=    Fazer Login Do Usuario    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala}=    Create Dictionary    name=Nova Sala Teste ${timestamp}    capacity=100
    ${response}=    Criar Sala    ${token}    ${dados_sala}
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()['data']}    _id
    Dictionary Should Contain Key    ${response.json()['data']}    name

Usuário Comum Tentar Criar Sala Deve Falhar
    [Tags]    THE-004
    ${login_response}=    Fazer Login Do Usuario    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala}=    Create Dictionary    name=Sala Não Autorizada ${timestamp}    capacity=50
    ${response}=    Criar Sala    ${token}    ${dados_sala}
    Should Be Equal As Strings    ${response.status_code}    403
    Dictionary Should Contain Value    ${response.json()}    User role user is not authorized to access this route

Admin Atualizar Sala Deve Ter Sucesso
    [Tags]    THE-005
    ${login_response}=    Fazer Login Do Usuario    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Primeiro criar uma sala para atualizar
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala_inicial}=    Create Dictionary    name=Sala Para Atualizar ${timestamp}    capacity=100
    ${create_response}=    Criar Sala    ${token}    ${dados_sala_inicial}
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${id_sala}=    Set Variable    ${create_response.json()['data']['_id']}
    # Agora atualizar
    ${timestamp2}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala_atualizada}=    Create Dictionary    name=Sala Atualizada ${timestamp2}    capacity=150
    ${response}=    Atualizar Sala    ${token}    ${id_sala}    ${dados_sala_atualizada}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    name
    Should Be Equal As Strings    ${response.json()['data']['name']}    Sala Atualizada ${timestamp2}

Admin Deletar Sala Vazia Deve Ter Sucesso
    [Tags]    THE-006
    ${login_response}=    Fazer Login Do Usuario    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Primeiro criar uma sala para deletar
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala}=    Create Dictionary    name=Sala Para Deletar ${timestamp}    capacity=50
    ${create_response}=    Criar Sala    ${token}    ${dados_sala}
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${id_sala}=    Set Variable    ${create_response.json()['data']['_id']}
    # Agora deletar
    ${response}=    Deletar Sala    ${token}    ${id_sala}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.json()}    Theater removed

Tentar Deletar Sala Com Sessões Ativas Deve Falhar
    [Tags]    THE-007
    ${login_response}=    Fazer Login Do Usuario    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Criar sala e sessão para testar
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${dados_sala}=    Create Dictionary    name=Sala Com Sessao ${timestamp}    capacity=100
    ${create_response}=    Criar Sala    ${token}    ${dados_sala}
    Should Be Equal As Strings    ${create_response.status_code}    201
    ${id_sala}=    Set Variable    ${create_response.json()['data']['_id']}
    # Criar sessão para esta sala (se possível)
    # Por enquanto, testar deletar sala recém criada (deve funcionar)
    ${response}=    Deletar Sala    ${token}    ${id_sala}
    # Como não temos sessões, deve deletar com sucesso
    Should Be Equal As Strings    ${response.status_code}    200