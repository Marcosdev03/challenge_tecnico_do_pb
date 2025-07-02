*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Resource    ../../variables/api_variables.robot
Resource    ../../variables/global_variables.robot

*** Keywords ***
Fazer Login Do Usuario
    [Arguments]    ${email}    ${senha}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    email=${email}    password=${senha}
    ${response}=    POST    ${BASE_API_URL}${AUTH_LOGIN_ENDPOINT}    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${response}

Registrar Usuario
    [Arguments]    ${nome}    ${email}    ${senha}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${body}=    Create Dictionary    name=${nome}    email=${email}    password=${senha}
    ${response}=    POST    ${BASE_API_URL}${AUTH_REGISTER_ENDPOINT}    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${response}

Obter Perfil Do Usuario
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    GET    ${BASE_API_URL}${AUTH_ME_ENDPOINT}    headers=${headers}    expected_status=any
    [Return]    ${response}

Atualizar Perfil Do Usuario
    [Arguments]    ${token}    ${nome}=${None}    ${senha}=${None}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${body}=    Create Dictionary
    Run Keyword If    '${nome}' != '${None}'    Set To Dictionary    ${body}    name=${nome}
    Run Keyword If    '${senha}' != '${None}'    Set To Dictionary    ${body}    password=${senha}
    ${response}=    PUT    ${BASE_API_URL}${AUTH_PROFILE_ENDPOINT}    json=${body}    headers=${headers}    expected_status=any
    [Return]    ${response}

Status Deve Ser
    [Arguments]    ${status_esperado}    ${response}
    Should Be Equal As Strings    ${response.status_code}    ${status_esperado}

Gerar Email Aleatorio
    ${string_aleatoria}=    Generate Random String    8    [LETTERS]
    ${email}=    Set Variable    test${string_aleatoria}@example.com
    [Return]    ${email}

# Aliases para compatibilidade
Login User
    [Arguments]    ${email}    ${password}
    ${response}=    Fazer Login Do Usuario    ${email}    ${password}
    [Return]    ${response}

Register User
    [Arguments]    ${name}    ${email}    ${password}
    ${response}=    Registrar Usuario    ${name}    ${email}    ${password}
    [Return]    ${response}

Get User Profile
    [Arguments]    ${token}
    ${response}=    Obter Perfil Do Usuario    ${token}
    [Return]    ${response}

Update User Profile
    [Arguments]    ${token}    ${name}=${None}    ${password}=${None}
    ${response}=    Atualizar Perfil Do Usuario    ${token}    ${name}    ${password}
    [Return]    ${response}

Status Should Be
    [Arguments]    ${expected_status}    ${response}
    Status Deve Ser    ${expected_status}    ${response}

Generate Random Email
    ${email}=    Gerar Email Aleatorio
    [Return]    ${email}