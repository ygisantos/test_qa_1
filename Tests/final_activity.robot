*** Settings ***
Resource   ../Resources/App.resource
Resource   ../Resources/CustomerPage.resource

Suite Setup   Launch Browser  ${website_url}  ${login_txt_username}

*** Test Cases ***
TEST-000001
    [Documentation]   TASK 1: ADD FIRST 5 USERS
    Login User  ${username_login}   ${password_login}
    ${status}    Run Keyword And Return Status   Wait Until Element Is Visible   ${nav_btn_customer}
    Check Is Login   ${status}

    ${users}   Get Five Users
    FOR  ${i}  IN  @{users}
        Create User   ${i}
    END

    Sleep   100s

*** Keywords ***
Launch Browser
    [Arguments]     ${url}     ${element_to_wait}
    Open Browser    ${url}    chrome   options=add_argument("--start-maximized")
    Wait Until Keyword Succeeds    5x   .5s    Wait Until Element Is Visible    ${element_to_wait}

Login User
    [Arguments]     ${username}=${username_login}       ${password}=${password_login}
    Input Text      ${login_txt_username}   ${username}
    Input Text      ${login_txt_password}   ${password}
    Click Button    ${login_btn_submit}

Check Is Login
    [Arguments]   ${status}
    IF    ${status}
        Log To Console   Login Successful
    ELSE
        Log To Console   Login Failed
    END