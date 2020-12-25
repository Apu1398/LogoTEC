grammar LogoTec;

start
:
	'hello' 'world'
;

WS
:
	[ \t\r\n]+ -> skip
;