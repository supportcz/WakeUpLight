
PROGRAM _CYCLIC
	
	IF test THEN
		speedFactor := 60;
	ELSE
		speedFactor := 1;
	END_IF
		
	TP_0(IN := button <> oldButton, PT := T#500ms);
	buttonPressed := EDGEPOS(TP_0.Q);
	oldButton := button;
	
	CASE stateLight OF
		
		stateInit:		

			stateLight := stateBeeingAwake;
		
		stateBeeingAwake:
			
			IF stateEntered THEN
				AsArLogWrite_0.enable := TRUE;
				AsArLogWrite_0.asciiString := ADR('beeing awake');
			END_IF				
			
			TON_0(IN := TRUE, PT := T#1s);	
			IF TON_0.Q THEN
				light := TRUE;		
			ELSE
				light := FALSE;		
			END_IF
				
			IF buttonPressed THEN
				stateLight := stateFallingAsleep;
			END_IF
	
		stateSleeping:

			IF stateEntered THEN
				AsArLogWrite_0.enable := TRUE;
				AsArLogWrite_0.asciiString := ADR('sleeping');
				light := TRUE;
			END_IF				

			IF light THEN
				TON_0(IN := TRUE, PT := T#5m/speedFactor);	
				IF TON_0.Q THEN
					TON_0(IN := FALSE);
					light := FALSE;
				END_IF					
			ELSE
				TON_0(IN := TRUE, PT := T#15m/speedFactor);	
				IF TON_0.Q THEN
					TON_0(IN := FALSE);
					light := TRUE;
				END_IF
			END_IF
					
			IF buttonPressed THEN
				stateLight := stateBeeingAwake;
			END_IF	

		stateFallingAsleep:			

			IF stateEntered THEN
				AsArLogWrite_0.enable := TRUE;
				AsArLogWrite_0.asciiString := ADR('falling asleep');
			END_IF				

			TON_0(IN := TRUE, PT := T#20m/speedFactor);	
			
			IF TON_0.Q THEN
				stateLight := stateSleeping;
			END_IF
			
			IF buttonPressed THEN
				stateLight := stateBeeingAwake;
			END_IF		

			light := FALSE;

	END_CASE	
		
	IF oldStateLight <> stateLight THEN
		TON_0(IN := FALSE);
		stateEntered := TRUE;
	ELSE
		stateEntered := FALSE;		
	END_IF
			
	AsArLogWrite_0(ident := arlogBASE_USER_LOG_IDENT, mem:=ADR(stateLight), len:= SIZEOF(oldStateLight), logLevel := arlogLEVEL_INFO);
	IF AsArLogWrite_0.status = 0 THEN
		AsArLogWrite_0.enable := FALSE;
	END_IF
	
	oldStateLight := stateLight;
	 
END_PROGRAM
