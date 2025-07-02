*** Settings ***
Library    RequestsLibrary
Resource    ../../resources/api/sessions.resource
Resource    ../../resources/api/auth.resource
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
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()['data']}    movie
    Dictionary Should Contain Key    ${response.json()['data']}    theater
    Dictionary Should Contain Key    ${response.json()['data']}    seats

Listar Todas As Sessões Deve Retornar Lista
    [Tags]    SES-001
    ${response}=    Get All Sessions
    Status Should Be    200    ${response}
    Dictionary Should Contain Key    ${response.json()}    data
    Should Not Be Empty    ${response.json()['data']}

Admin Criar Nova Sessão Deve Ter Sucesso
    [Tags]    SES-004
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${session_data}=    Create Dictionary    movie=685c2d5cf34317e7520c4285    theater=685c2d5cf34317e7520c4289    datetime=2025-12-31T20:00:00.000Z    fullPrice=20    halfPrice=10
    ${response}=    Create Session With Auth    ${token}    ${session_data}
    Status Should Be    201    ${response}
    Dictionary Should Contain Key    ${response.json()['data']}    _id
    Dictionary Should Contain Key    ${response.json()['data']}    seats

Admin Resetar Assentos Deve Ter Sucesso
    [Tags]    SES-005
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${response}=    Reset Session Seats    ${token}    685c2d5cf34317e7520c42a4
    Status Should Be    200    ${response}
    Dictionary Should Contain Value    ${response.json()}    Seats reset successfully

Usuário Comum Tentar Criar Sessão Deve Falhar
    [Tags]    SES-006
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${session_data}=    Create Dictionary    movie=685c2d5cf34317e7520c4285    theater=685c2d5cf34317e7520c4289    datetime=2025-12-31T21:00:00.000Z
    ${response}=    Create Session With Auth    ${token}    ${session_data}
    Status Should Be    403    ${response}
    Dictionary Should Contain Value    ${response.json()}    Access denied