*** Settings ***
Resource    ../../resources/api/users.resource
Resource    ../../resources/api/auth.resource
Resource    ../../variables/api_variables.robot
Resource    ../../variables/global_variables.robot
Suite Setup    Create Session    api    ${BASE_API_URL}

*** Test Cases ***
Criar Usuário Sem Autenticação Deve Falhar
    [Tags]    USR-001
    ${user_data}=    Create Dictionary    name=Test User    email=test@test.com
    ${response}=    Create User    ${user_data}
    Should Be Equal As Strings    ${response.status_code}    401
    Dictionary Should Contain Value    ${response.json()}    Not authorized to access this route

Obter Perfil Próprio Via Auth/Me Deve Ter Sucesso
    [Tags]    USR-003
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${response}=    auth.Get User Profile    ${token}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    email
    Dictionary Should Not Contain Key    ${response.json()['data']}    password

Atualizar Perfil Próprio Via Auth/Profile Deve Ter Sucesso
    [Tags]    USR-004
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${response}=    auth.Update User Profile    ${token}    Updated User Name
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    name
    Should Be Equal As Strings    ${response.json()['data']['name']}    Updated User Name

Admin Listar Todos Usuários Deve Ter Sucesso
    [Tags]    USR-001
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${response}=    Get All Users    ${token}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    data
    Should Not Be Empty    ${response.json()['data']}
    # Verificar que nenhum usuário contém senha
    ${users}=    Set Variable    ${response.json()['data']}
    FOR    ${user}    IN    @{users}
        Dictionary Should Not Contain Key    ${user}    password
    END

Tentar Listar Usuários Como Usuário Comum Deve Falhar
    [Tags]    USR-002
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${response}=    Get All Users    ${token}
    Should Be Equal As Strings    ${response.status_code}    403
    Dictionary Should Contain Value    ${response.json()}    User role user is not authorized to access this route

Endpoint Users Por ID Não Existe
    [Tags]    USR-003
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Obter lista para pegar um ID válido
    ${users_response}=    Get All Users    ${token}
    ${user_id}=    Set Variable    ${users_response.json()['data'][0]['_id']}
    # Tentar acessar endpoint que não existe
    ${response}=    users.Get User Profile    ${user_id}
    Should Be Equal As Strings    ${response.status_code}    401
    Dictionary Should Contain Value    ${response.json()}    Not authorized to access this route

Admin Atualizar Usuário Deve Ter Sucesso
    [Tags]    USR-004
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Criar usuário para atualizar
    ${random_email}=    Generate Random Email
    ${create_response}=    Register User    User To Update    ${random_email}    password123
    ${user_id}=    Set Variable    ${create_response.json()['data']['_id']}
    # Atualizar
    ${user_data}=    Create Dictionary    name=Updated User Name    role=admin
    ${response}=    Update User By Admin    ${token}    ${user_id}    ${user_data}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    name
    Should Be Equal As Strings    ${response.json()['data']['name']}    Updated User Name

Tentar Atualizar Outro Usuário Como Usuário Comum Deve Falhar
    [Tags]    USR-005
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Obter ID do admin
    ${admin_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${admin_token}=    Set Variable    ${admin_login.json()['data']['token']}
    ${users_response}=    Get All Users    ${admin_token}
    ${admin_user_id}=    Set Variable    ${users_response.json()['data'][0]['_id']}
    # Tentar atualizar como user comum
    ${user_data}=    Create Dictionary    name=Hacked Name
    ${response}=    Update User By Admin    ${token}    ${admin_user_id}    ${user_data}
    Should Be Equal As Strings    ${response.status_code}    403
    Dictionary Should Contain Value    ${response.json()}    User role user is not authorized to access this route

Admin Deletar Usuário Deve Ter Sucesso
    [Tags]    USR-006
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Criar usuário para deletar
    ${random_email}=    Generate Random Email
    ${create_response}=    Register User    User To Delete    ${random_email}    password123
    ${user_id}=    Set Variable    ${create_response.json()['data']['_id']}
    # Deletar
    ${response}=    Delete User    ${token}    ${user_id}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Value    ${response.json()}    User removed

Usuário Deletado Não Consegue Mais Logar
    [Tags]    USR-007
    # Criar usuário
    ${random_email}=    Generate Random Email
    ${create_response}=    Register User    User Delete Test    ${random_email}    password123
    ${user_id}=    Set Variable    ${create_response.json()['data']['_id']}
    # Deletar como admin
    ${admin_login}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${admin_token}=    Set Variable    ${admin_login.json()['data']['token']}
    Delete User    ${admin_token}    ${user_id}
    # Tentar logar com usuário deletado
    ${response}=    Login User    ${random_email}    password123
    Should Be Equal As Strings    ${response.status_code}    401
    Dictionary Should Contain Value    ${response.json()}    Invalid email or password