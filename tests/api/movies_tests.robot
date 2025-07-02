*** Settings ***
Library    RequestsLibrary
Resource    ../../resources/api/movies.resource
Resource    ../../resources/api/auth.resource
Resource    ../../variables/api_variables.robot
Resource    ../../variables/global_variables.robot
Suite Setup    Create Session    api    ${BASE_API_URL}

*** Test Cases ***
Listar Todos Os Filmes Deve Retornar Lista
    [Tags]    MOV-001
    ${response}=    Get All Movies
    Should Be Equal As Strings    ${response.status_code}    200
    Should Not Be Empty    ${response.json()}

Obter Filme Por ID Deve Retornar Detalhes
    [Tags]    MOV-002
    ${response}=    Get Movie By ID    1
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()['data']}    title

Tentar Obter Filme Inexistente Deve Retornar Erro
    [Tags]    MOV-003
    ${response}=    Get Movie By ID    999999
    Should Be Equal As Strings    ${response.status_code}    404

Admin Criar Novo Filme Deve Ter Sucesso
    [Tags]    MOV-004
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${movie_data}=    Create Dictionary    title=Novo Filme Teste    director=Diretor Teste    synopsis=Sinopse do filme    duration=120    classification=PG-13
    ${response}=    Create Movie    ${token}    ${movie_data}
    Status Should Be    201    ${response}
    Dictionary Should Contain Key    ${response.json()['data']}    _id
    Dictionary Should Contain Key    ${response.json()['data']}    title

Usuário Comum Tentar Criar Filme Deve Falhar
    [Tags]    MOV-005
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${movie_data}=    Create Dictionary    title=Filme Não Autorizado    director=Diretor
    ${response}=    Create Movie    ${token}    ${movie_data}
    Status Should Be    403    ${response}
    Dictionary Should Contain Value    ${response.json()}    Access denied

Admin Deletar Filme Deve Ter Sucesso
    [Tags]    MOV-006
    ${login_response}=    Login User    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    # Primeiro criar um filme para deletar
    ${movie_data}=    Create Dictionary    title=Filme Para Deletar    director=Diretor
    ${create_response}=    Create Movie    ${token}    ${movie_data}
    ${movie_id}=    Set Variable    ${create_response.json()['data']['_id']}
    # Agora deletar
    ${response}=    Delete Movie    ${token}    ${movie_id}
    Status Should Be    200    ${response}
    Dictionary Should Contain Value    ${response.json()}    Movie removed

Usuário Comum Tentar Deletar Filme Deve Falhar
    [Tags]    MOV-007
    ${login_response}=    Login User    ${USER_EMAIL}    ${USER_PASSWORD}
    ${token}=    Set Variable    ${login_response.json()['data']['token']}
    ${response}=    Delete Movie    ${token}    685c2d5cf34317e7520c4285
    Status Should Be    403    ${response}
    Dictionary Should Contain Value    ${response.json()}    Access denied