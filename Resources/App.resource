*** Settings ***
Library    SeleniumLibrary
Library    String
Variables  ../Variables/variable.py
Library    ../Library/api.py

*** Keywords ***
Refresh Current Page
    Click Button   ${btn_refresh}
    Wait Until Element Is Visible   ${loading_icon}
    Wait Until Element Is Not Visible    ${loading_icon}