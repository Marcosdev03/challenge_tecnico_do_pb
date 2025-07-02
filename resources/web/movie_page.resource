*** Settings ***
Resource   common.resource

*** Variables ***
${MOVIE_TITLE}              class=movie-title
${MOVIE_DESCRIPTION}        class=movie-description
${SESSIONS_LIST}            class=sessions-list
${SELECT_SESSION_BUTTON}    class=select-session-btn

*** Keywords ***
Verify Movie Page Is Loaded
    Wait Until Element Is Visible    ${MOVIE_TITLE}    ${TIMEOUT}
    Element Should Be Visible    ${MOVIE_DESCRIPTION}

View Movie Sessions
    Element Should Be Visible    ${SESSIONS_LIST}

Select Movie Session
    [Arguments]    ${session_index}=1
    ${session_button}=    Set Variable    xpath=(//button[@class='select-session-btn'])[${session_index}]
    Wait And Click Element    ${session_button}