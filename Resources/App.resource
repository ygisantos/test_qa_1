*** Settings ***
Library    SeleniumLibrary
Library    String
Variables  ../Variables/variable.py
Library    ../Library/api.py
Library    Collections

*** Keywords ***
Refresh Current Page
    Click Button   ${btn_refresh}
    Wait Until Element Is Visible   ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}


Clear And Input Text
    [Arguments]   ${locator}    ${text}   
    Wait Until Element Is Visible    ${locator}
    Press Keys   ${locator}   CTRL+a   BACKSPACE
    Input Text   ${locator}    ${text}