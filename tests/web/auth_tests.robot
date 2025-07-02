*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary
Resource    ../../resources/web/auth_page.resource
Resource    ../../resources/web/common.resource
Resource    ../../variables/web_variables.robot
Resource    ../../variables/global_variables.robot

Suite Setup    Open Browser To Login Page
Suite Teardown    Close Browser

*** Test Cases ***
Login Válido Deve Ter Sucesso
    [Tags]    WEB-AUTH-01
    Login With Valid Credentials    ${USER_EMAIL}    ${USER_PASSWORD}
    Verify Successful Login
    Logout User

Login Inválido Deve Mostrar Erro
    [Tags]    WEB-AUTH-02
    [Template]    Login With Invalid Credentials Should Show Error
    invalid@example.com    password123    Credenciais inválidas
    ${USER_EMAIL}         wrongpassword  Credenciais inválidas
    ${EMPTY}              ${EMPTY}       E-mail é obrigatório

Cadastrar Novo Usuário Deve Ter Sucesso
    [Tags]    WEB-AUTH-03
    ${name}=    FakerLibrary.Name
    ${email}=    Generate Random Email
    ${password}=    Set Variable    password123
    
    Register New User    ${name}    ${email}    ${password}    ${password}
    Verify Successful Registration
    
    # Verify new user can login
    Login With Valid Credentials    ${email}    ${password}
    Verify Successful Login
    Logout User

Cadastrar Com Senhas Diferentes Deve Mostrar Erro
    [Tags]    WEB-AUTH-04
    ${name}=    FakerLibrary.Name
    ${email}=    Generate Random Email
    
    Go To Register Page
    Input Text    ${NAME_INPUT}    ${name}
    Input Text    ${EMAIL_INPUT}    ${email}
    Input Text    ${PASSWORD_INPUT}    password123
    Input Text    ${CONFIRM_PASSWORD_INPUT}    differentpassword
    Click Button    ${REGISTER_BUTTON}
    
    Page Should Contain    As senhas não coincidem

*** Keywords ***
Login With Invalid Credentials Should Show Error
    [Arguments]    ${email}    ${password}    ${expected_error}
    Go To Login Page
    Input Email    ${email}
    Input Password    ${password}
    Submit Credentials
    Verify Login Error Message    ${expected_error}