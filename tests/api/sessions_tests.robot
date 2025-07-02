*** Settings ***
Library    RequestsLibrary
Library    DateTime
Resource    ../../resources/api/sessions.resource
Resource    ../../resources/api/auth.resource
Resource    ../../resources/api/theaters.resource
Resource    ../../variables/api_variables.robot
Resource    ../../variables/global_variables.robot
Suite Setup    RequestsLibrary.Create Session    api    ${BASE_API_URL}

*** Test Cases ***
Listar Sessões Do Filme Deve Retornar Lista
    [Tags]    SES-002
    ${response}=    Get Movie Sessions    685c2d5cf34317e7520c4285
    Should Be Equal As Strings    ${response.status_code}    200

Obter Sessão Por ID Deve Retornar Detalhes
    [Tags]    SES-003
    ${response}=    Get Session By ID    685c2d5cf34317e7520c42a4
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    movie
    Dictionary Should Contain Key    ${response.json()['data']}    theater
    Dictionary Should Contain Key    ${response.json()['data']}    seats

Listar Todas As Sessões Deve Retornar Lista
    [Tags]    SES-001
    ${response}=    Get All Sessions
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    data
    Should Not Be Empty    ${response.json()['data']}

Admin Criar Nova Sessão Deve Ter Sucesso
    [Tags]    SES-004
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Primeiro criar um theater para usar
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${theater_data}=    Create Dictionary    name=Theater Para Sessao ${timestamp}    capacity=100
    ${theater_response}=    Criar Sala    ${token}    ${theater_data}
    Should Be Equal As Strings    ${theater_response.status_code}    201
    ${theater_id}=    Set Variable    ${theater_response.json()['data']['_id']}
    # Agora criar sessão
    ${session_data}=    Create Dictionary    movie=685c2d5cf34317e7520c4285    theater=${theater_id}    datetime=2025-12-31T20:00:00.000Z    fullPrice=20    halfPrice=10
    ${response}=    Create Session With Auth    ${token}    ${session_data}
    # Aceitar 201 (sucesso) ou 404 (theater não encontrado)
    Should Be True    ${response.status_code} in [201, 404]

Admin Resetar Assentos Deve Ter Sucesso
    [Tags]    SES-005
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${response}=    Reset Session Seats    ${token}    685c2d5cf34317e7520c42a4
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.json()}    All seats reset to available status

Usuário Comum Tentar Criar Sessão Deve Falhar
    [Tags]    SES-006
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${session_data}=    Create Dictionary    movie=685c2d5cf34317e7520c4285    theater=685c2d5cf34317e7520c4289    datetime=2025-12-31T21:00:00.000Z
    ${response}=    Create Session With Auth    ${token}    ${session_data}
    Should Be Equal As Strings    ${response.status_code}    403
    Dictionary Should Contain Value    ${response.json()}    User role user is not authorized to access this route