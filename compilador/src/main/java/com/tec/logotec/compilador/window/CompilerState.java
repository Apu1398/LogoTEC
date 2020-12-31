package com.tec.logotec.compilador.window;

public class CompilerState {
	
	private Boolean compilingStatus;
	private Boolean doSomething;
	
	
	private static  CompilerState compilerState;
	
	
	public static Boolean getCompilerStatus() {
		if (compilerState == null) {
			compilerState = new CompilerState();
		}
		
		return compilerState.compilingStatus;
	}
	
	private CompilerState() {
		this.compilingStatus = true;
		this.doSomething = true;
		
	}
	
	public static void errorDetected() {
		if(compilerState == null) {
			compilerState = new CompilerState();
		}
		compilerState.compilingStatus = false;
	}
	
	public static void clearErrors() {
		if(compilerState == null) {
			compilerState = new CompilerState();
		}
		compilerState.compilingStatus = true;
	}
	
	public static void dontDoNothing() {
		if(compilerState == null) {
			compilerState = new CompilerState();
		}
		compilerState.doSomething = false;
	}
	
	public static void doSome() {
		if(compilerState == null) {
			compilerState = new CompilerState();
		}
		compilerState.doSomething = true;
	}
	
	public static Boolean canIDoSomething() {
		if (compilerState == null) {
			compilerState = new CompilerState();
		}
		
		return compilerState.doSomething;
	}

}
