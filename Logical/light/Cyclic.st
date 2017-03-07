
PROGRAM _CYCLIC
	CASE stateLight OF
		
		stateLightInit:		
			stateLight := stateWakingUpLightOn;
		
		stateWakingUpLightOn:
			light := TRUE;

			TON_0(IN := TRUE, PT := T#5m);			
			IF TON_0.Q THEN
				TON_0(IN := FALSE);
				stateLight := stateWakingUpLightOff;
			END_IF					
		
			IF button <> oldButton THEN
				TON_0(IN := FALSE);

				AsArLogWrite_0.enable := TRUE;
				AsArLogWrite_0.asciiString := ADR('light switched off');

				stateLight := stateFallingAsleep;
			END_IF	

		stateWakingUpLightOff:
			light := FALSE;

			TON_0(IN := TRUE, PT := T#15m);	
			IF TON_0.Q THEN
				TON_0(IN := FALSE);
				stateLight := stateWakingUpLightOn;
			END_IF
			
			IF button <> oldButton THEN
				stateLight := stateWakingUpLightOn;
			END_IF	
		
		stateFallingAsleep:			
			light := FALSE;

			TON_0(IN := TRUE, PT := T#20m);		
			IF TON_0.Q OR button <> oldButton THEN
				TON_0(IN := FALSE);
				
				AsArLogWrite_0.enable := TRUE;
				AsArLogWrite_0.asciiString := ADR('light switched on');
				
				stateLight := stateWakingUpLightOn;
			END_IF
		
	END_CASE	
	
	AsArLogWrite_0(ident := arlogBASE_USER_LOG_IDENT, logLevel := arlogLEVEL_INFO);
	IF AsArLogWrite_0.status = 0 THEN
		AsArLogWrite_0.enable := FALSE;
	END_IF
	
	oldButton := button;
	 
END_PROGRAM
