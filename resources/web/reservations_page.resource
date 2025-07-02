*** Settings ***
Resource   common.resource

*** Variables ***
${RESERVATIONS_TITLE}       xpath=//h1[contains(text(),'Reservas')]
${RESERVATIONS_LIST}        id=reservations-list
${CANCEL_RESERVATION_BTN}   class=cancel-reservation-btn

*** Keywords ***
Navigate To Reservations Page
    Open Browser To URL    ${RESERVATIONS_URL}

Verify Reservations Page Is Loaded
    Wait Until Element Is Visible    ${RESERVATIONS_TITLE}    ${TIMEOUT}
    Element Should Be Visible    ${RESERVATIONS_LIST}

Cancel Reservation
    [Arguments]    ${reservation_index}=1
    ${cancel_button}=    Set Variable    xpath=(//button[@class='cancel-reservation-btn'])[${reservation_index}]
    Wait And Click Element    ${cancel_button}