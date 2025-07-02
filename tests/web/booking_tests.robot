*** Settings ***
Resource    ../../resources/web/movie_page.resource
Resource    ../../resources/web/seats_page.resource
Resource    ../../resources/web/checkout_page.resource
Suite Teardown    Close Browser Session

*** Test Cases ***
Fluxo Completo De Reserva Deve Ter Sucesso
    [Tags]    WEB-BOOK-01    WEB-BOOK-02    WEB-BOOK-03    WEB-BOOK-04
    Navigate To Home Page
    Click Featured Movie
    Select Movie Session
    Verify Seats Page Is Loaded
    Select Seat    A1
    Confirm Seat Selection
    Verify Checkout Page Is Loaded
    Fill Payment Information    1234567890123456
    Confirm Payment