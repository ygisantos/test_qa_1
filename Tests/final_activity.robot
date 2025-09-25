*** Settings ***
Resource   ../Resources/App.resource
Resource   ../Resources/CustomerPage.resource

Suite Setup   Launch Browser  ${website_url}  ${login_txt_username}

*** Variables ***
${users}
@{COLUMN_NAMES}     Name    Last Seen    Orders    Total Spent    Latest Purchase    News       Segments

*** Test Cases ***
TEST-000001
    [Documentation]   None Task: Login And Fetch API
    Login User  ${username_login}   ${password_login}
    ${status}    Run Keyword And Return Status   Wait Until Element Is Visible   ${nav_btn_customer}
    Check Is Login   ${status}

    ${users}=    Get Five Users
    Set Suite Variable    ${users}    ${users}


TEST-000002
    [Documentation]   TASK 1 Add Five Users And Verify the data
    FOR  ${i}  IN  @{users}
        Create User   ${i}
    END


TEST-000003
    [Documentation]   TASK 2: VERIFY TABLE DISPLAY
    Verify Users In Table 


TEST-000004
    [Documentation]   TASK 3: UPDATE EXISTING CUSTOMER
    ${users}=    Get Five Users    2
    Set Suite Variable    ${users}    ${users}
    FOR   ${table_row}   IN RANGE   6   11
        ${user_index}=    Evaluate    ${table_row} - 6    
        Update Data  ${table_row}  ${users}[${user_index}]
    END


TEST-000005
    [Documentation]   TASK 4: LOG TABLE DATA
    Print All Users In Table


TEST-000006
    [Documentation]    Task 5: Analyze User Spending  (SHOWCASE PASS)
    Analyze User Spending  0


TEST-000007
    [Documentation]    Task 5: Analyze User Spending  (SAME WITH INSTRUCTION)
    Analyze User Spending  3500


TEST-000008
    [Documentation]    Task 5: Analyze User Spending  (SHOWCASE FAILED)
    Analyze User Spending  1000000

*** Keywords ***
Launch Browser
    [Arguments]     ${url}     ${element_to_wait}
    ${prefs}=    Create Dictionary    profile.password_manager_leak_detection=${False}    credentials_enable_service=${False}
    ${chrome_options}=    Create Dictionary    prefs=${prefs}

    Open Browser    ${url}    chrome    options=add_argument("--start-maximized")    desired_capabilities=${chrome_options}
    Wait Until Keyword Succeeds    5x    0.5s    Wait Until Element Is Visible    ${element_to_wait}



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

