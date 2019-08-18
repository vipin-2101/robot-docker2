*** Settings ***
Library			SeleniumLibrary

*** Variables ***
${BROWSER}		chrome


*** Test Cases ***
Test Google
	Open Browser			https://www.google.com		${BROWSER}
	Capture Page Screenshot

