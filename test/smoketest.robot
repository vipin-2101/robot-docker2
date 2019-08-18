*** Settings ***
Library			SeleniumLibrary

*** Variables ***
${BROWSER}		%{BROWSER}
${IS_Frozen_Success} =      xpath=.//*[@id='tsf']/div[2]/div/div[3]/center/input[1]

*** Test Cases ***
Test Google
	Open Browser			https://www.google.com		${BROWSER}
	Capture Page Screenshot

