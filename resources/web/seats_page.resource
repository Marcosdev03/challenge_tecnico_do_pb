*** Settings ***
Resource   common.resource

*** Variables ***
${SEATS_GRID}               id=seats-grid
${AVAILABLE_SEAT}           class=seat-available
${SELECTED_SEAT}            class=seat-selected
${CONFIRM_SEATS_BUTTON}     id=confirm-seats-btn

*** Keywords ***
Verify Seats Page Is Loaded
    Wait Until Element Is Visible    ${SEATS_GRID}    ${TIMEOUT}

Select Seat
    [Arguments]    ${seat_number}
    ${seat_locator}=    Set Variable    xpath=//div[@class='seat-available' and @data-seat='${seat_number}']
    Wait And Click Element    ${seat_locator}

Confirm Seat Selection
    Wait And Click Element    ${CONFIRM_SEATS_BUTTON}