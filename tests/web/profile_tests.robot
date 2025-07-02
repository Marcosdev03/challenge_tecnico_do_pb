*** Settings ***
Library    SeleniumLibrary
Resource    ../../resources/web/auth_page.resource
Resource    ../../resources/web/common.resource
Resource    ../../variables/web_variables.robot

Suite Setup    Open Browser To Login Page
Test Setup     Login With Valid Credentials    ${USER_EMAIL}    ${USER_PASSWORD}
Test Teardown  Logout User
Suite Teardown    Close Browser

*** Test Cases ***
Visualizar Informações Do Perfil Deve Mostrar Dados
    [Tags]    WEB-PROF-01
    Go To Profile Page
    ${current_name}=    Get Value    ${PROFILE_NAME_INPUT}
    Should Not Be Empty    ${current_name}
    Page Should Contain Element    ${EMAIL_INPUT}
    Element Should Be Disabled    ${EMAIL_INPUT}

Atualizar Nome Do Perfil Deve Salvar Alterações
    [Tags]    WEB-PROF-02
    Go To Profile Page
    ${new_name}=    Set Variable    Updated Name
    Input Text    ${PROFILE_NAME_INPUT}    ${new_name}
    Click Button    ${SAVE_PROFILE_BUTTON}
    Page Should Contain    Perfil atualizado com sucesso!
    ${updated_name}=    Get Value    ${PROFILE_NAME_INPUT}
    Should Be Equal    ${updated_name}    ${new_name}

Visualizar Lista De Reservas Deve Mostrar Reservas Do Usuário
    [Tags]    WEB-PROF-03
    Go To Reservations Page
    ${reservations}=    Get Element Count    ${RESERVATION_CARDS}
    Run Keyword If    ${reservations} > 0
    ...    Log    User has ${reservations} reservations
    ...  ELSE
    ...    Page Should Contain Element    ${NO_RESERVATIONS_MESSAGE}

Acessar Rota Protegida Sem Login Deve Redirecionar
    [Tags]    WEB-AUTH-06
    Logout User
    Go To Profile Page
    Location Should Be    ${LOGIN_PAGE_URL}