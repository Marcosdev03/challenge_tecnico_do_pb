*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary
Library    String
Resource    ../../variables/web_variables.robot

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_PAGE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Login Page Should Be Open

Login Page Should Be Open
    Location Should Be    ${LOGIN_PAGE_URL}
    Page Should Contain Element    ${EMAIL_INPUT}
    Page Should Contain Element    ${PASSWORD_INPUT}

Go To Login Page
    Go To    ${LOGIN_PAGE_URL}
    Login Page Should Be Open

Go To Register Page
    Go To    ${REGISTER_PAGE_URL}
    Page Should Contain Element    ${NAME_INPUT}

Go To Home Page
    Go To    ${HOME_PAGE_URL}
    Page Should Contain Element    ${MOVIE_CARDS}

Go To Profile Page
    Go To    ${PROFILE_PAGE_URL}
    Page Should Contain Element    ${PROFILE_NAME_INPUT}

Go To Reservations Page
    Go To    ${RESERVATIONS_PAGE_URL}
    Page Should Contain Element    ${RESERVATION_CARDS}

Take Screenshot
    [Arguments]    ${name}
    Capture Page Screenshot    ${SCREENSHOT_DIR}/${name}.png

Generate Random Email
    ${first_name}=    FakerLibrary.First Name
    ${last_name}=    FakerLibrary.Last Name
    ${email}=    Catenate    SEPARATOR=    ${first_name}    .    ${last_name}    ${TEMPDIR}    @example.com
    ${email}=    Convert To Lower Case    ${email}
    [Return]    ${email}