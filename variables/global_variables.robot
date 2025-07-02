*** Variables ***
# URLs
${BASE_API_URL}      https://challenge-pb-back-n9wmjthu8-marcosdev03s-projects.vercel.app/api/v1
${BASE_WEB_URL}      https://challenge-pb-front.vercel.app

# Browser Configuration
${BROWSER}          chrome
${HEADLESS}         ${True}
${IMPLICIT_WAIT}    10s

# Screenshot Configuration
${SCREENSHOT_DIR}   ${EXECDIR}/screenshots

# Test Data Files
${TEST_DATA_DIR}    ${EXECDIR}/test_data