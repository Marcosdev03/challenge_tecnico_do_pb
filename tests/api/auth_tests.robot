*** Settings ***
Library           Collections
Library           RequestsLibrary
Resource          ../../resources/api/auth.resource
Resource          ../../variables/api_variables.robot

Suite Setup       Create Session    cinema_api    ${BASE_API_URL}

*** Test Cases ***
Login Com Credenciais Válidas Deve Retornar Token
    [Tags]    AUTH-003
    ${response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    success
    Dictionary Should Contain Key    ${response.json()['data']}    token
    Should Not Be Empty    ${response.json()['data']['token']}

Login Com Senha Inválida Deve Retornar Não Autorizado
    [Tags]    AUTH-004
    ${response}=    Login User    ${USER_EMAIL}    wrongpassword
    Should Be Equal As Strings    ${response.status_code}    401
    Dictionary Should Contain Value    ${response.json()}    Invalid email or password

Cadastrar Novo Usuário Com Dados Válidos Deve Ter Sucesso
    [Tags]    AUTH-001
    ${random_email}=    Generate Random Email
    ${response}=        Register User    Test User    ${random_email}    password123
    Should Be Equal As Strings    ${response.status_code}    201
    Dictionary Should Contain Key    ${response.json()}    success
    Dictionary Should Contain Key    ${response.json()['data']}    token
    Should Not Be Empty    ${response.json()['data']['token']}

Cadastrar Com Email Existente Deve Falhar
    [Tags]    AUTH-002
    ${response}=    Register User    Test User    ${USER_EMAIL}    password123
    Should Be Equal As Strings    ${response.status_code}    400
    Dictionary Should Contain Value    ${response.json()}    User already exists

Obter Perfil Do Usuário Com Token Válido Deve Retornar Dados
    [Tags]    AUTH-005
    # Primeiro faz login para obter token válido
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    Should Be Equal As Strings    ${login_response.status_code}    200
    ${token}=             Set Variable    ${login_response.json()['data']['token']}
    
    # Usa o token para obter perfil
    ${response}=          Get User Profile    ${token}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    email
    Should Be Equal As Strings    ${response.json()['data']['email']}    ${USER_EMAIL}

Obter Perfil Do Usuário Sem Token Deve Falhar
    [Tags]    AUTH-006
    ${response}=    Get User Profile    invalidtoken
    Should Be Equal As Strings    ${response.status_code}    401

Atualizar Perfil Com Nome E Senha Deve Ter Sucesso
    [Tags]    AUTH-007
    # Primeiro faz login para obter token válido
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    Should Be Equal As Strings    ${login_response.status_code}    200
    ${token}=             Set Variable    ${login_response.json()['data']['token']}
    
    # Atualiza o perfil com nome e senha
    ${response}=          Update User Profile    ${token}    New Name    newpassword123
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    name

Atualizar Perfil Apenas Com Nome Deve Ter Sucesso
    [Tags]    AUTH-008
    # Primeiro faz login para obter token válido
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    Should Be Equal As Strings    ${login_response.status_code}    200
    ${token}=             Set Variable    ${login_response.json()['data']['token']}
    
    # Atualiza apenas o nome
    ${response}=          Update User Profile    ${token}    Updated Name Only
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    name