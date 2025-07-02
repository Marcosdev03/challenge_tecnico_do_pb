*** Settings ***
Resource   common.resource

*** Variables ***
${CHECKOUT_TITLE}           xpath=//h1[contains(text(),'Checkout')]
${PAYMENT_FORM}             id=payment-form
${CARD_NUMBER_FIELD}        id=card-number
${CONFIRM_PAYMENT_BUTTON}   id=confirm-payment-btn

*** Keywords ***
Verify Checkout Page Is Loaded
    Wait Until Element Is Visible    ${CHECKOUT_TITLE}    ${TIMEOUT}
    Element Should Be Visible    ${PAYMENT_FORM}

Fill Payment Information
    [Arguments]    ${card_number}
    Wait And Input Text    ${CARD_NUMBER_FIELD}    ${card_number}

Confirm Payment
    Wait And Click Element    ${CONFIRM_PAYMENT_BUTTON}