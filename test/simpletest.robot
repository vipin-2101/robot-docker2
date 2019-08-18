*** Settings ***
Library			SeleniumLibrary

*** Variables ***
${BROWSER}		chrome

*** Test Cases ***
Visit Amazon
	Open Browser			https://www.amazon.com		${BROWSER}
	Capture Page Screenshot

Visit Bing
	Open Browser			https://www.bing.com		${BROWSER}
	Capture Page Screenshot

Visit Google
	Open Browser			https://www.google.com		${BROWSER}
	Capture Page Screenshot

Visit Yahoo
	Open Browser			https://search.yahoo.com	${BROWSER}
	Capture Page Screenshot
