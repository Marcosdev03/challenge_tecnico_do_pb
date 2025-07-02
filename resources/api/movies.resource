*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    String
Resource    ../../variables/api_variables.robot
Resource    ../../variables/global_variables.robot
*** Keywords ***
Obter Todos Os Filmes
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    GET    ${BASE_API_URL}${MOVIES_ENDPOINT}    headers=${headers}    expected_status=any
    [Return]    ${response}

Obter Filme Por ID
    [Arguments]    ${id_filme}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${url}=    Replace String    ${MOVIES_ID_ENDPOINT}    {id}    ${id_filme}
    ${response}=    GET    ${BASE_API_URL}${url}    headers=${headers}    expected_status=any
    [Return]    ${response}

Criar Filme
    [Arguments]    ${token}    ${dados_filme}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${response}=    POST    ${BASE_API_URL}${MOVIES_ENDPOINT}    json=${dados_filme}    headers=${headers}    expected_status=any
    [Return]    ${response}

Deletar Filme
    [Arguments]    ${token}    ${id_filme}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Bearer ${token}
    ${url}=    Replace String    ${MOVIES_ID_ENDPOINT}    {id}    ${id_filme}
    ${response}=    DELETE    ${BASE_API_URL}${url}    headers=${headers}    expected_status=any
    [Return]    ${response}

# Aliases para compatibilidade
Get All Movies
    ${response}=    Obter Todos Os Filmes
    [Return]    ${response}

Get Movie By ID
    [Arguments]    ${movie_id}
    ${response}=    Obter Filme Por ID    ${movie_id}
    [Return]    ${response}

Create Movie
    [Arguments]    ${token}    ${movie_data}
    ${response}=    Criar Filme    ${token}    ${movie_data}
    [Return]    ${response}

Delete Movie
    [Arguments]    ${token}    ${movie_id}
    ${response}=    Deletar Filme    ${token}    ${movie_id}
    [Return]    ${response}