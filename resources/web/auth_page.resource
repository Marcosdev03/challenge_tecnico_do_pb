*** Settings ***
Resource    common.resource

*** Keywords ***
Input Email
    [Arguments]    ${email}
    Input Text    ${EMAIL_INPUT}    ${email}

Input Password
    [Arguments]    ${password}
    Input Text    ${PASSWORD_INPUT}    ${password}

Submit Credentials
    Click Button    ${LOGIN_BUTTON}

Login With Valid Credentials
    [Arguments]    ${email}    ${password}
    Input Email    ${email}
    Input Password    ${password}
    Submit Credentials

Register New User
    [Arguments]    ${name}    ${email}    ${password}    ${confirm_password}
    Go To Register Page
    Input Text    ${NAME_INPUT}    ${name}
    Input Text    ${EMAIL_INPUT}    ${email}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Input Text    ${CONFIRM_PASSWORD_INPUT}    ${confirm_password}
    Click Button    ${REGISTER_BUTTON}

Logout User
    Click Button    ${LOGOUT_BUTTON}

Verify Successful Login
    Page Should Not Contain Element    ${LOGIN_BUTTON}
    Page Should Contain Element    ${LOGOUT_BUTTON}

Verify Login Error Message
    [Arguments]    ${expected_message}
    Page Should Contain    ${expected_message}

Verify Successful Registration
    Location Should Be    ${LOGIN_PAGE_URL}
    Page Should Contain    Conta criada com sucesso!